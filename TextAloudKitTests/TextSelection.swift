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
        let expected = NSRange(location: 0, length: 7)
        
        let result = TextSelectionEnum.sentence.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the everything if there is no capital as its all one sentence
    /// This is a known limitation of the built in iterator
    /// Luckly the built in iOS keyboard auto capitals after a full stop so its not a huge issue.
    func testFirstSentanceNoFullCap() throws {
        let input = "First. second."
        let location = 0
        let expected = NSRange(location: 0, length: 14)
        
        let result = TextSelectionEnum.sentence.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the everything if there is no capital as its all one sentence
    func testAlternativePunctuation() throws {
        let input = "First! Second? Third."
        
        XCTAssertEqual(TextSelectionEnum.sentence.getRangeForIndex(0, input), NSRange(location: 0, length: 7), "The wrong range was calculated")
        XCTAssertEqual(TextSelectionEnum.sentence.getRangeForIndex(7, input), NSRange(location: 7, length: 8), "The wrong range was calculated")
        XCTAssertEqual(TextSelectionEnum.sentence.getRangeForIndex(15, input), NSRange(location: 15, length: 6), "The wrong range was calculated")
    }
    
    /// Wraps back round to the start to find the first sentence if curor is negative
    func testReturnsFirstSentenceIsNegative() throws {
        let input = "This is a sentence. Another one"
        let location = -99
        let expected = NSRange(location: 0, length: 20)
        
        let result = TextSelectionEnum.sentence.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Wraps back round to the start to find the first sentence if curor is too high
    func testReturnsFirstSentenceIsTooHigh() throws {
        let input = "This is a sentence. Another one"
        let location = 99
        let expected = NSRange(location: 0, length: 20)
        
        let result = TextSelectionEnum.sentence.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    
    /// Returns the first paragraph
    func testReturnsTheFirstParagraph() throws {
        let input = """
        This is the first para
        
        This is the second para
        """
        let location = 0
        let expected = NSRange(location: 0, length: 22)
        
        let result = TextSelectionEnum.paragraph.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the second paragraph
    func testReturnsTheSecondaragraph() throws {
        let input = """
        This is the first para
        
        This is the second para
        """
        let location = 24
        let expected = NSRange(location: 24, length: 23)
        
        let result = TextSelectionEnum.paragraph.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Returns the second paragraph when a single new line is in place
    func testParagraphSplitWithSingleNewLine() throws {
        let input = """
        This is the first para
        This is the second para
        """
        let location = 24
        let expected = NSRange(location: 23, length: 23)
        
        let result = TextSelectionEnum.paragraph.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
    
    /// Skips a large group of new lines
    func testParagraphSkipNewLineGroup() throws {
        let input = """
        This is the first para
        
        
        
        
        This is the second para
        """
        let location = 24
        let expected = NSRange(location: 27, length: 23)
        
        let result = TextSelectionEnum.paragraph.getRangeForIndex(location, input)
        XCTAssertEqual(result, expected, "The wrong range was calculated")
    }
}
