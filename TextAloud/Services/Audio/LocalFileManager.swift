//
//  LocalFileManager.swift
//  TextAloud
//
//

import Foundation


class LocalFileManager{

    static let instance = LocalFileManager()

    let fm = FileManager.default
    let rootFolder = "AzureText"
    
    private init(){}

    func save(for data: Data, fileNameWithExt: String, folderName: String) -> URL?{
        createFolderIfNeeded(folderName)
        
        guard let url = createURL(fileNameWithExt: fileNameWithExt, folderName: folderName) else {return nil}
        do {
            try data.write(to: url)
            return url
        } catch let error {
            print("Error saving image. ImageName \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteFolder(folderName: String){
        guard let path = getURLForFolder(folderName)?.path else {return}
        do {
            try fm.removeItem(atPath: path)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func remove(for url: URL) -> Bool{
        if fm.fileExists(atPath: url.path){
            do {
                try FileManager.default.removeItem(atPath: url.path)
                return true
            } catch {
               return false
            }
        }
        return false
    }

    private func createFolderIfNeeded(_ folderName: String){
        guard let url = getURLForFolder(folderName) else {return}
        if !fm.fileExists(atPath: url.path){
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. Folder \(folderName). \(error)")
            }
        }
    }

    private func getURLForFolder(_ folderName: String) -> URL?{
        guard let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(rootFolder).appendingPathComponent(folderName)
    }

    private func createURL(fileNameWithExt: String, folderName: String) -> URL?{
        guard let folderUrl = getURLForFolder(folderName) else {return nil}
        return folderUrl.appendingPathComponent(fileNameWithExt)
    }
}
