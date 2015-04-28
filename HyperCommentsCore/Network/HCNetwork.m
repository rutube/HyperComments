//
//  HyperCommentsNetwork.m
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import "HCNetwork.h"
#import <CommonCrypto/CommonDigest.h>

static HCNetwork* _instance;

@interface HCNetwork()
-(id)initWitWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey;
-(NSString*)sha1:(NSString*)input;
@end

@implementation HCNetwork {
    NSUInteger _widgetId;
    NSString* _secretKey;
}

-(id)initWitWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey {
    
    if( self = [super initWithBaseURL:[NSURL URLWithString:@"http://c1api.hypercomments.com/1.0/"]] ) {
        
        _widgetId = widgetId;
        _secretKey = [secretKey copy];
        
    }
    
    return self;
    
}

+(HCNetwork*)instance {
    return _instance;
}

+(HCNetwork*)instanceWithWidgetId:(NSUInteger)widgetId secretKey:(NSString*)secretKey {
    if( !_instance ) {
        _instance = [[HCNetwork alloc] initWitWidgetId:widgetId secretKey:secretKey];
    }
    return _instance;
}

-(BOOL)apiRequestPath:(NSString*)path withParams:(NSDictionary*)params networkHandler:(NetworkCompleteBlock)networkHandler {
    return [self apiRequestPath:path withParams:params authRequire:NO networkHandler:networkHandler];
}

-(BOOL)apiRequestPath:(NSString*)path withParams:(NSDictionary*)params authRequire:(BOOL)authRequire networkHandler:(NetworkCompleteBlock)networkHandler {
    
    if( authRequire && ( !_authToken || [_authToken length] < 5 ) )
        return false;
    
    NSMutableDictionary* jsonPrepare = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if( authRequire )
        jsonPrepare[@"auth"] = _authToken;
    
    jsonPrepare[@"widget_id"] = [NSNumber numberWithUnsignedLong:_widgetId];
    
    NSError* jsonConvertError;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonPrepare options:0 error:&jsonConvertError];
    
    if( jsonConvertError )
        return NO;
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary* requestParams = @{@"body":jsonString, @"signature":[self sha1:[NSString stringWithFormat:@"%@%@", jsonString, _secretKey]] };
    
    [self GET:path parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _error = nil;
        
        // at first we check is it success or error in answer
        NSDictionary* responce = (NSDictionary*)responseObject;
        
        if( [responce[@"result"] isEqualToString:@"error"] ) {
            
            _error = [HCError errorWithCode:responce[@"code"] message:responce[@"description"]];
            
        }
        
        if( networkHandler ) {
            networkHandler( (_error ? nil : responce[@"data"]) ,_error );
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _error = error;
        
        if( networkHandler ) {
            networkHandler(nil, _error);
        }
        
    }];
    
    return true;
    
}

#pragma mark - Helper methods

-(NSString*)sha1:(NSString*)input {
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:strlen(cstr)];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

@end
