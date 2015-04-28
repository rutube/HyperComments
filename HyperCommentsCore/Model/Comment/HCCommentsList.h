//
//  HyperCommentCommentsList.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import <Foundation/Foundation.h>
#import "HCComment.h"

@class HCStream;

@interface HCCommentsList : NSObject

-(id)initWithStream:(HCStream*)stream;

-(void)retrieve;
-(void)retrievePage:(NSUInteger)page withBlock:(HyperCommentsCompleteHandler)handler;

@property (nonatomic) HyperCommentSorting sortType;
@property (nonatomic) NSUInteger limit;

@property (readonly) NSArray* comments;

@end
