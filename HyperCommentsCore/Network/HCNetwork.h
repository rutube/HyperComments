//
//  HyperCommentsNetwork.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import <Foundation/Foundation.h>
#import "HCError.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^NetworkCompleteBlock)(id responseObject, NSError *error);

@interface HCNetwork : AFHTTPRequestOperationManager

+(HCNetwork*)instance;
+(HCNetwork*)instanceWithWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey;

-(BOOL)apiRequestPath:(NSString*)path withParams:(NSDictionary*)params networkHandler:(NetworkCompleteBlock)networkHandler;
-(BOOL)apiRequestPath:(NSString*)path withParams:(NSDictionary*)params authRequire:(BOOL)authRequire networkHandler:(NetworkCompleteBlock)networkHandler;

@property (nonatomic, copy) NSString* authToken;

@property (nonatomic) NSError* error;

@end
