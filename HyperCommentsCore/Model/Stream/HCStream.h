//
//  HyperCommentStream.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import <Foundation/Foundation.h>
#import "HyperCommentsConstants.h"
#import "HCCommentsList.h"

@interface HCStream : NSObject

+(HCStream*)streamByLink:(NSString*)link;
+(HCStream*)streamByLink:(NSString*)link xId:(NSString*)xId;

-(void)retrieve;
-(void)retrieveWithBlock:(HyperCommentsCompleteHandler)handler;

-(BOOL)vote:(HyperCommentVoteType)type;
-(BOOL)vote:(HyperCommentVoteType)type withBlock:(HyperCommentsCompleteHandler)handler;

-(void)switchAccess:(HyperCommentStreamAccess)access;
-(void)switchAccess:(HyperCommentStreamAccess)access withBlock:(HyperCommentsCompleteHandler)handler;

@property (readonly) BOOL isRetrieved;

@property (readonly) NSString* streamId;
@property (readonly) NSString* xId;
@property (readonly) NSString* link;
@property (readonly) NSString* title;
@property (readonly) NSString* type;
@property (readonly) BOOL readOnly;
@property (readonly) NSUInteger countTotalComments; // cm2	Общее количество комментариев
@property (readonly) NSUInteger countHyperComments; // hc	Количество гиперкомментариев
@property (readonly) NSUInteger countTopLevelComments; // cm	Количество комментариев, которые не имеют родительских сообщений (верхнего уровня)
@property (readonly) NSUInteger countPendingComments; // cm_pending	Количество комментариев в ожидании
@property (readonly) NSUInteger countSpamComments; // cm_spam	Количество спама
@property (readonly) NSUInteger countRemovedComments; // cm_removed	Количество удаленных комментариев
@property (readonly) NSUInteger countLikes; // likes	Количество голосов за страницу
@property (readonly) NSUInteger countDislikes; // unlikes	Количество негативных голосов за страницу
@property (readonly) NSUInteger quotesCount; // quotes	Количество цитат на странице
@property (readonly) NSDate* creationTime; // unixtime	Время создания страницы в Unixtime

@property (readonly) HCCommentsList* commentsList;

@end
