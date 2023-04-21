//
//  TextAloudKitTests.swift
//  TextAloudKitTests
//
//  Created by Gavin Henderson on 20/04/2023.
//

import XCTest
import TextAloudKit

final class TextSelectionTests: XCTestCase {
    /// Basic test for getting all the text
    func testValidLocationForAllText() throws {
        let input = "This is a full sentence"
        let location = 0
        let expected = NSRange(location: 0, length: 23)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    func testTextWithNonEnglishCharacters() throws {
        let input = "هذا نص عربي"
        let location = 0
        let expected = NSRange(location: 0, length: 11)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    func testNegativeLocationWhenGettingAllText() throws {
        let input = "This is a test"
        let location = -99
        let expected = NSRange(location: 0, length: 14)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    func testLocationThatIsTooHighGettingAllText() throws {
        let input = "This is a sentence"
        let location = 99
        let expected = NSRange(location: 0, length: 18)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
}
