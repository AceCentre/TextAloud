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
    
    /// Getting all the text when using non-english characters
    func testTextWithNonEnglishCharacters() throws {
        let input = "هذا نص عربي"
        let location = 0
        let expected = NSRange(location: 0, length: 11)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Get all the text even when the location is negative
    func testNegativeLocationWhenGettingAllText() throws {
        let input = "This is a test"
        let location = -99
        let expected = NSRange(location: 0, length: 14)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Get all the text even when the location is negative
    func testLocationThatIsTooHighGettingAllText() throws {
        let input = "This is a sentence"
        let location = 99
        let expected = NSRange(location: 0, length: 18)
        
        let result = TextSelectionEnum.all.getRangeForIndex(location, input)
        
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Get the first word when the location is 0
    func testGetWordFromStart() throws {
        let input = "This is a sentence"
        let location = 0
        let expected = NSRange(location: 0, length: 4)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// The second word should be returned when the cursor is at the end of the current word
    func testGetSecondWordWhenLocationIsAtEndOfFirstWord() throws {
        let input = "This is a sentence"
        let location = 4
        let expected = NSRange(location: 5, length: 2)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }

    /// Returns a single letter word
    func testFindsSingleLetterWords() throws {
        let input = "This is a sentence"
        let location = 8
        let expected = NSRange(location: 8, length: 1)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Wraps back round to the start to find the first word if curor is at the end
    func testReturnsFirstWordIfCursorIsAtTheEnd() throws {
        let input = "This is a sentence"
        let location = 18
        let expected = NSRange(location: 0, length: 4)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Wraps back round to the start to find the first word if curor is over the end
    func testReturnsFirstWordIfCursorIsOverTheEnd() throws {
        let input = "This is a sentence"
        let location = 99
        let expected = NSRange(location: 0, length: 4)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Wraps back round to the start to find the first word if curor is negative
    func testReturnsFirstWordIsNegative() throws {
        let input = "This is a sentence"
        let location = -99
        let expected = NSRange(location: 0, length: 4)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the first sentance from the start
    func testFirstSentanceFromStart() throws {
        let input = "First. Second."
        let location = 0
        let expected = NSRange(location: 0, length: 5)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the first sentance even if second setance has no Capital
    func testFirstSentanceNoFullCap() throws {
        let input = "First. second."
        let location = 0
        let expected = NSRange(location: 0, length: 5)
        
        let result = TextSelectionEnum.word.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }

}
