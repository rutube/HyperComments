//
//  HCComment.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import <Foundation/Foundation.h>
#import "HyperCommentsConstants.h"
#import "HCUser.h"

@class HCStream;

@interface HCComment : NSObject

@property (readonly) BOOL isJustCreated; // Just created and waiting responce
@property (readonly) NSArray* childComments;

@property (readonly) HCComment* parentComment;
@property (readonly) HCComment* rootComment;
@property (readonly) HCUser* author;
@property (readonly) NSArray* files;
@property (readonly) HCStream* stream;

@property (readonly) NSDate* creationDate;
@property (readonly) NSString* commentId;
@property (readonly) NSString* message;
@property (readonly) NSUInteger countLikes;
@property (readonly) NSUInteger countDislikes;
@property (readonly) NSUInteger countChildren;
@property (readonly) BOOL isHypercomment;
@property (readonly) NSUInteger categoryId;
@property (readonly) NSUInteger quoteId;

/*
 {
 
 files = "<null>";
 
 "reason_del" = "<null>";
 state = 1;
 t = 0;
 
 }
 */

-(BOOL)equals:(HCComment*)comment;

-(void)retrieve;
-(void)retrieveWithBlock:(HyperCommentsCompleteHandler)handler;

-(BOOL)vote:(HyperCommentVoteType)type;
-(BOOL)vote:(HyperCommentVoteType)type withBlock:(HyperCommentsCompleteHandler)handler;

-(BOOL)editText:(NSString*)text;
-(BOOL)remove;

+(HCComment*)commentByRaw:(NSDictionary*)rawDict inStream:(HCStream*)stream;
+(HCComment*)commentById:(NSString*)commentId inStream:(HCStream*)stream;

+(HCComment*)createComment:(NSString*)title message:(NSString*)message inStream:(HCStream*)stream withBlock:(HyperCommentsCompleteHandler)handler;
+(HCComment*)createReply:(HCComment*)comment withTitle:(NSString*)title message:(NSString*)message withBlock:(HyperCommentsCompleteHandler)handler;




@end
