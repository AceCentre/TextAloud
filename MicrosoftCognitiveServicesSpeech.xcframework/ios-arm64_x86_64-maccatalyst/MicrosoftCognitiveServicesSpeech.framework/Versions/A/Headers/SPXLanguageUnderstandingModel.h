//
// Copyright (c) Microsoft. All rights reserved.
// See https://aka.ms/csspeech/license for the full license information.
//

#import "SPXFoundation.h"

/**
 * Represents the language understanding model used for intent recognition.
 */
SPX_EXPORT
@interface SPXLanguageUnderstandingModel : NSObject

/**
 * Initializes a language understanding model using the specified endpoint URL.
 *
 * The Speech SDK only supports LUIS v2.0 endpoints. For details, see [Get started with intent recognition](https://docs.microsoft.com/azure/cognitive-services/speech-service/quickstarts/intent-recognition).
 *
 * @param uri the endpoint of the language understanding model.
 * @return an instance of language understanding model.
 */
- (nullable instancetype)initWithEndpoint:(nonnull NSString *)uri;

/**
 * Initializes a language understanding model using an application id for the Language Understanding service.
 *
 * @param appId the application id for the Language Understanding service.
 * @return an instance of language understanding model.
 */
- (nullable instancetype)initWithAppId:(nonnull NSString *)appId;

/**
 * Initializes a language understanding model using a subscription key, application id and region for the Language Understanding service.
 *
 * @param key the subscription key for the Language Understanding service.
 * @param appId the application id for the Language Understanding service.
 * @param region the region for the Language Understanding service (see the <a href="https://aka.ms/csspeech/region">region page</a>).
 * @return an instance of language understanding model.
 */
- (nullable instancetype)initWithSubscription:(nonnull NSString *)key withAppId:(nonnull NSString *)appId andRegion:(nonnull NSString *)region;

@end
