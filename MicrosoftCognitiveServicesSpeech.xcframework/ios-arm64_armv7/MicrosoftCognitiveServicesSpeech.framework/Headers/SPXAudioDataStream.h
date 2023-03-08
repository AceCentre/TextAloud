//
// Copyright (c) Microsoft. All rights reserved.
// See https://aka.ms/csspeech/license for the full license information.
//

#import "SPXFoundation.h"
#import "SPXSpeechEnums.h"
#import "SPXSpeechSynthesisResult.h"
#import "SPXKeywordRecognitionResult.h"

/**
 * Represents audio data stream used for operating audio data as a stream. 
 * 
 * Added in version 1.7.0
 */
SPX_EXPORT
@interface SPXAudioDataStream : NSObject

/**
 * Initializes an audio data stream from given speech synthesis result.
 * 
 * @param result the speech synthesis result.
 * @return an instance of audio data stream.
 */
- (nullable instancetype)initFromSynthesisResult:(nonnull SPXSpeechSynthesisResult *)result
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Initializes an audio data stream from given speech synthesis result.
 * 
 * @param result the speech synthesis result.
 * @param outError error information.
 * @return an instance of audio data stream.
 */
- (nullable instancetype)initFromSynthesisResult:(nonnull SPXSpeechSynthesisResult *)result error:(NSError * _Nullable * _Nullable)outError;

/**
 * Obtains the memory backed AudioDataStream associated with a given KeywordRecognition result.
 * 
 * @param result the keyword recognition result.
 * @return An audio stream with the input to the KeywordRecognizer starting from right before the Keyword.
 */
- (nullable instancetype)initFromKeywordRecognitionResult:(nonnull SPXKeywordRecognitionResult *)result
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Obtains the memory backed AudioDataStream associated with a given KeywordRecognition result.
 * 
 * @param result the keyword recognition result.
 * @param outError error information.
 * @return An audio stream with the input to the KeywordRecognizer starting from right before the Keyword.
 */
- (nullable instancetype)initFromKeywordRecognitionResult:(nonnull SPXKeywordRecognitionResult *)result error:(NSError * _Nullable * _Nullable)outError;

/**
 * Get current status of the audio data stream.
 * 
 * @return current status.
 */
- (SPXStreamStatus)getStatus;

/**
 * Check wheather the stream has enough data to be read.
 * 
 * @param bytesRequested the request data size in bytes.
 * @return a bool indicating whether the stream has enough data to be read.
 */
- (BOOL)canReadData:(NSUInteger)bytesRequested;

/**
 * Check whether the stream has enough data to be read, starting from the specified position.
 * 
 * @param pos the position counting from start of the stream.
 * @param bytesRequested the request data size in bytes.
 * @return a bool indicating whether the stream has enough data to be read.
 */
- (BOOL)canReadDataFromPosition:(NSUInteger)pos bytesRequested:(NSUInteger)bytesRequested;

/**
 * Reads a chunk of the audio data and fill it to given buffer.
 * 
 * @param data a buffer to receive read data.
 * @param length length of the data to be received.
 * @return length of data filled to the buffer, 0 means end of stream.
 */
- (NSUInteger)readData:(nonnull NSMutableData *)data length:(NSUInteger)length;

/**
 * Reads a chunk of the audio data and fill it to given buffer, starting from the specified position.
 * 
 * @param pos the position counting from start of the stream.
 * @param data a buffer to receive read data.
 * @param length length of the data to be received.
 * @return length of data filled to the buffer, 0 means end of stream.
 */
- (NSUInteger)readDataFromPosition:(NSUInteger)pos data:(nonnull NSMutableData *)data length:(NSUInteger)length;

/**
 * Save the audio data to a file.
 * 
 * @param fileName the file name with full path.
 */
- (void)saveToWavFile:(nonnull NSString *)fileName;

/**
 * Get current position of the audio data stream.
 * 
 * @return current position
 */
- (NSUInteger)getPosition;

/**
 * Set current position of the audio data stream.
 * 
 * @param pos position to be set.
 */
- (void)setPosition:(NSUInteger)pos;

/**
 * Stops any more data from getting to the stream.
 * 
 */
- (void)detachInput
NS_SWIFT_UNAVAILABLE("Use the method with Swift-compatible error handling.");

/**
 * Stops any more data from getting to the stream.
 * 
 * @param outError error information.
 */
- (void)detachInput:(NSError * _Nullable * _Nullable)outError;

@end
