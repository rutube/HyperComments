//
//  HyperCommentError.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import <Foundation/Foundation.h>

@interface HCError : NSError

+(NSString*)errorDomain;
+(HCError*)errorWithCode:(NSString*)errorCode message:(NSString*)message;

@end
