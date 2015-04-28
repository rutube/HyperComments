//
//  HyperCommentsCore.m
//  HyperCommentsCore
//
//  Created by Jura on 3/23/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "HyperCommentsCore.h"
#import "HyperCommentsConstants.h"
#import "HCNetwork.h"

static HyperCommentsCore* _instance;

@implementation HyperCommentsCore

-(NSString*)version {return jversion;}

-(NSError*)error {
    return [HCNetwork instance].error;
}

-(void)updateAuthToken:(NSString*)authToken {
    [HCNetwork instance].authToken = authToken;
}

+(HyperCommentsCore*)instance {
    return _instance;
}

+(HyperCommentsCore*)initWithWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey {
    if(!_instance) {
        _instance = [[HyperCommentsCore alloc] init];
        [HCNetwork instanceWithWidgetId:widgetId secretKey:secretKey];
    }
    return _instance;
}

#pragma mark - Stream working

+(HCStream*)streamWithUrl:(NSURL*)url {
    return [self streamWithUrl:url xId:nil];
}

+(HCStream*)streamWithUrl:(NSURL*)url xId:(NSString*)xId {
    return [self streamWithLink:[url absoluteString] xId:xId];
}

+(HCStream*)streamWithLink:(NSString*)link {
    return [HCStream streamByLink:link];
}

+(HCStream*)streamWithLink:(NSString*)link xId:(NSString*)xId {
    return [HCStream streamByLink:link xId:xId];
}

@end
