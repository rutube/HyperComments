//
//  HyperCommentStream.m
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import "HCStream.h"
#import "HCNetwork.h"

static NSMutableDictionary* _streams;

@interface HCStream()
-(id)initWithLink:(NSString*)link xId:(NSString*)xId;
-(void)parse:(NSDictionary*)rawStream;
+(NSString*)normalizeLink:(NSString*)link;
@end

@implementation HCStream {
    HCCommentsList* _commentsList;
}

#pragma mark - Static methods

+(HCStream*)streamByLink:(NSString*)link {
    return [HCStream streamByLink:link xId:nil];
}

+(HCStream*)streamByLink:(NSString*)link xId:(NSString*)xId {
    
    if( !_streams ) {
        _streams = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    // cut link
    link = [HCStream normalizeLink:link];
    HCStream* stream = _streams[link];
    if(!stream) {
        stream = [[HCStream alloc] initWithLink:link xId:xId];
        _streams[stream.link] = stream;
    }
    
    return stream;
    
}

+(NSString*)normalizeLink:(NSString*)link {
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[htps]*[:/]*[w]*[.]*"
                                                                           options:NSRegularExpressionCaseInsensitive error:&error];
    
    return [regex stringByReplacingMatchesInString:link
                                           options:NSMatchingReportCompletion
                                             range:NSMakeRange(0, [link length])
                                      withTemplate:@""];
    
}

#pragma mark - Private methods

-(id)initWithLink:(NSString*)link xId:(NSString*)xId {
    if(self = [super init]) {
        _link = [link copy];
        _xId = [xId copy];
    }
    return self;
}

-(void)parse:(NSDictionary*)rawStream {
    
    _countTopLevelComments = (NSUInteger)rawStream[@"cm"];
    _countPendingComments = (NSUInteger)rawStream[@"cm_pending"];
    _countRemovedComments = (NSUInteger)rawStream[@"cm_removed"];
    _countSpamComments = (NSUInteger)rawStream[@"cm_spam"];
    _streamId = rawStream[@"id"];
    _countTotalComments = (NSUInteger)rawStream[@"cm2"];
    _countHyperComments = (NSUInteger)rawStream[@"hc"];
    _countLikes = (NSUInteger)rawStream[@"likes"];
    _countDislikes = (NSUInteger)rawStream[@"unlikes"];
    _quotesCount = (NSUInteger)rawStream[@"quotes"];
    _xId = rawStream[@"xid"];
    _link = rawStream[@"href"];
    _title = rawStream[@"title"];
    _type = rawStream[@"type"];
    _readOnly = [[NSNumber numberWithInteger:[rawStream[@"readonly"] integerValue]] boolValue];
    
    if( [NSNull null] != rawStream[@"unixtime"] )
        _creationTime = [NSDate dateWithTimeIntervalSince1970:[rawStream[@"unixtime"] doubleValue]];
    
}

#pragma mark - Methods

-(HCCommentsList*)commentsList {
    if( !_commentsList )
        _commentsList = [[HCCommentsList alloc] initWithStream:self];
    return _commentsList;
}

-(void)retrieve {
    [self retrieveWithBlock:nil];
}

-(void)retrieveWithBlock:(HyperCommentsCompleteHandler)handler {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"link"] = self.link;
    
    if( self.xId && [self.xId length] > 0 ) {
        params[@"xid"] = self.xId;
    }
    
    [[HCNetwork instance] apiRequestPath:@"streams/get" withParams:params networkHandler:^(id responseObject, NSError *error) {
        
        if( error ) {
            if(handler)
                handler(self, error);
            return;
        }
        
        NSDictionary* rawStream = (NSDictionary*)responseObject[0];

        [self parse:rawStream];
        
        if(handler)
            handler(self, error);
        
    }];
    
}

-(BOOL)vote:(HyperCommentVoteType)type {
    return [self vote:type withBlock:nil];
}

-(BOOL)vote:(HyperCommentVoteType)type withBlock:(HyperCommentsCompleteHandler)handler {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"link"] = self.link;
    
    if( self.xId && [self.xId length] > 0 ) {
        params[@"xid"] = self.xId;
    }
    
    params[@"vote"] = (type == VotePositive) ? @"up" : @"dn";
    
    return [[HCNetwork instance] apiRequestPath:@"streams/vote" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( error ) {
            if(handler)
                handler(self, error);
            return;
        }
        
        NSDictionary* rawStream = (NSDictionary*)responseObject;
        
        BOOL isLike =  [[NSNumber numberWithInteger:[rawStream[@"like"] integerValue]] boolValue];

        if( isLike ) {
            _countLikes++;
        } else {
            _countDislikes++;
        }
        
        if(handler)
            handler(self, error);
        
    }];
    
}

-(void)switchAccess:(HyperCommentStreamAccess)access {
    [self switchAccess:access withBlock:nil];
}

-(void)switchAccess:(HyperCommentStreamAccess)access withBlock:(HyperCommentsCompleteHandler)handler {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"link"] = self.link;
    
    if( self.xId && [self.xId length] > 0 ) {
        params[@"xid"] = self.xId;
    }
    
    params[@"readonly"] = [NSNumber numberWithBool:(access == AccessRead)];
    
    [[HCNetwork instance] apiRequestPath:@"streams/readonly" withParams:params networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            _readOnly = (access == AccessRead);
        }
        
        if(handler)
            handler(self, error);
        
    }];
    
}

@end
