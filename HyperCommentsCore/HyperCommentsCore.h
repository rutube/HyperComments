//
//  HyperCommentsCore.h
//  HyperCommentsCore
//
//  Created by Jura on 3/23/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCStream.h"

//https://www.hypercomments.com/ru/documentation/comments-get

//http://rutube.ru/api/comments/hypercomments/auth/?_=1427228004936

@interface HyperCommentsCore : NSObject

@property (readonly) NSString* version;
@property (readonly) NSError* error;

-(void)updateAuthToken:(NSString*)authToken;

+(HyperCommentsCore*)instance;
+(HyperCommentsCore*)initWithWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey;


// Get Stream
+(HCStream*)streamWithUrl:(NSURL*)url;
+(HCStream*)streamWithUrl:(NSURL*)url xId:(NSString*)xId;
+(HCStream*)streamWithLink:(NSString*)link;
+(HCStream*)streamWithLink:(NSString*)link xId:(NSString*)xId;

@end
