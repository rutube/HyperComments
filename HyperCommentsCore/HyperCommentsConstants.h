//
//  HyperCommentsConstants.h
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#ifndef HyperComments_HyperCommentsConstants_h
#define HyperComments_HyperCommentsConstants_h

#define jversion @"01.00.01"

typedef NS_ENUM(NSInteger, HyperCommentVoteType) {
    VotePositive,
    VoteNegative
};

typedef NS_ENUM(NSInteger, HyperCommentStreamAccess) {
    AccessRead,
    AccessReadWrite
};

typedef NS_ENUM(NSInteger, HyperCommentSorting) {
    SortAll,
    SortNew,
    SortPopular
};

typedef void (^HyperCommentsCompleteHandler)(id sender, NSError* error);

#endif
