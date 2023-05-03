//
//  Language.swift
//  TextAloudKitTests
//
//  Created by Gavin Henderson on 02/05/2023.
//

import XCTest
import TextAloudKit

final class LanguageTests: XCTestCase {
    func testFullLanguageString() throws {
        let input = "en-GB"
        
        let result = Language(input)
        
        XCTAssertEqual(result.languageName, "English")
        XCTAssertEqual(result.languageRegion, "United Kingdom")
    }
    
    func testNoRegion() throws {
        let input = "en"
        
        let result = Language(input)
        
        XCTAssertEqual(result.languageName, "English")
        XCTAssertEqual(result.languageRegion, nil)
    }
    
    func testUnknownRegion() throws {
        let input = "zz"
        
        let result = Language(input)
        
        XCTAssertEqual(result.languageName, "zz")
        XCTAssertEqual(result.languageRegion, nil)
    }
    
    func testInvalidRegion() throws {
        let input = "en-zz"
        
        let result = Language(input)
        
        XCTAssertEqual(result.languageName, "English")
        XCTAssertEqual(result.languageRegion, nil)
    }
    
    func testSemiValidCode() throws {
        let input = "engb"
        
        let result = Language(input)
        
        XCTAssertEqual(result.languageName, "engb")
        XCTAssertEqual(result.languageRegion, nil)
    }
}
