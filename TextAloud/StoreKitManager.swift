//
//  StoreKitManager.swift
//  TextAloud
//
//  Created by Gavin Henderson on 16/03/2023.
//  Credit to https://github.com/olopsman/storekit2-youtube-demo
//

import Foundation
import StoreKit
import SwiftUI

class StoreKitManager: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedProducts: [Product] = []
    
    @Published var unlimitedVoiceAllowance: Product? = nil
    @Published var hasPurchasedUnlimitedVoiceAllowance: Bool? = nil
    
    @Published var sayThankYou: Bool = false
    @AppStorage("thankYouAcknowledged") var thankYouAcknowledged: Bool = false

    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        // Bypass all store code if we are on TextAloudPro
        if let isTextAloudPro = ProcessInfo.processInfo.environment["TEXTALOUDPRO"] {
            hasPurchasedUnlimitedVoiceAllowance = true
            return
        }
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await self.requestProducts()
            await self.updateCustomerStatus()
        }
    }
    
    deinit {
        // Bypass all store code if we are on TextAloudPro
        if let isTextAloudPro = ProcessInfo.processInfo.environment["TEXTALOUDPRO"] {
            return
        }
        
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //iterate through any transactions that don't come from a direct call to 'purchase()'
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    //the transaction is verified, deliver the content to the user
                    await self.updateCustomerStatus()
                    
                    //Always finish a transaction
                    await transaction.finish()
                } catch {
                    //storekit has a transaction that fails verification, don't delvier content to the user
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    
    @MainActor
    func requestProducts() async {
        do {
            self.storeProducts = try await Product.products(for: ["unlimited_voice_allowance"])
            
            if self.storeProducts.count != 1 {
                throw StoreError.incorrectProductCount
            }
            
            self.unlimitedVoiceAllowance = self.storeProducts[0]
        } catch {
            print("Failed - error getting products \(error)")
        }
    }
    
    //Generics - check the verificationResults
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //check if JWS passes the StoreKit verification
        switch result {
        case .unverified:
            //failed verificaiton
            throw StoreError.failedVerification
        case .verified(let signedType):
            //the result is verified, return the unwrapped value
            return signedType
        }
    }
    
    @MainActor
    func updateCustomerStatus() async {
        var purchasedProducts: [Product] = []
        
        print("Updating status")
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                                
                // Make sure to add everything to our list of purchasedProducts
                if let product = storeProducts.first(where: { $0.id == transaction.productID}) {
                    purchasedProducts.append(product)
                }
                                
                if let unwrappedVoiceAllowance = self.unlimitedVoiceAllowance {
                    
                    if transaction.productID == unwrappedVoiceAllowance.id {
                        self.hasPurchasedUnlimitedVoiceAllowance = true
                        
                        if !self.thankYouAcknowledged {
                            self.sayThankYou = true
                        }
                      
                    } else {
                        throw StoreError.invalidProductPurchased
                    }
                } else {
                    throw StoreError.checkingStatusBeforeProductsRetrieved
                }
            } catch {
                // storekit has a transaction that fails verification, don't delvier content to the user
                print("Transaction failed verification")
            }
        }
        
        if self.hasPurchasedUnlimitedVoiceAllowance == nil {
            self.hasPurchasedUnlimitedVoiceAllowance = false
        }
        
        self.purchasedProducts = purchasedProducts
    }
    
    func purchase(_ product: Product?) async throws -> StoreKit.Transaction? {
        
        if let unwrappedProduct = product {
            let result = try await unwrappedProduct.purchase()

            switch result {
            case .success(let verificationResult):
                print("SUCCESS")
                let transaction = try checkVerified(verificationResult)
                
                await updateCustomerStatus()
                await transaction.finish()
                
                return transaction
                
            case .userCancelled, .pending:
                print("PENDING")
                
                return nil
            default:
                print("DEFAULT")
                
                return nil
            }
        } else {
            throw StoreError.noProductProvided
        }
        
        
        
    }
}

enum StoreError: Error {
    case incorrectProductCount
    case failedVerification
    case checkingStatusBeforeProductsRetrieved
    case invalidProductPurchased
    case noProductProvided
}
