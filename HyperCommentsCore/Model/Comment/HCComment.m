//
//  HCComment.m
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import "HCComment.h"
#import "HCNetwork.h"
#import "HCStream.h"
#import "HCMedia.h"

@interface HCComment()
-(id)initWithId:(NSString*)commentId stream:(HCStream*)stream;
-(void)parse:(NSDictionary*)rawData;
-(void)addChildComment:(HCComment*)comment;
-(void)removeChildComment:(HCComment*)comment;
@end

@implementation HCComment {
    NSMutableArray* _files;
    NSMutableArray* _childComments;
}

#pragma mark - Properties

-(BOOL)isJustCreated {
    return self.commentId == 0;
}

-(NSArray*)childComments {
    return _childComments;
}

-(NSArray*)files {
    return _files;
}

#pragma mark - Static

+(HCComment*)commentByRaw:(NSDictionary*)rawDict inStream:(HCStream*)stream {
    
    NSString* commentId = rawDict[@"id"];
    
    HCComment* comment = [HCComment commentById:commentId inStream:stream];
    [comment parse:rawDict];
    
    return comment;
    
}

+(HCComment*)commentById:(NSString*)commentId inStream:(HCStream*)stream {
    static NSMutableDictionary* accumulatedComments;
    if( !accumulatedComments )
        accumulatedComments = [NSMutableDictionary dictionaryWithCapacity:10];
    HCComment* comment = accumulatedComments[commentId];
    if( !comment ) {
        comment = [[HCComment alloc] initWithId:commentId stream:stream];
        accumulatedComments[commentId] = comment;
    }
    return comment;
}

+(HCComment*)createComment:(NSString*)title message:(NSString*)message inStream:(HCStream*)stream withBlock:(HyperCommentsCompleteHandler)handler; {
    
    if( !stream )
        return nil;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"link"] = stream.link;
    
    if( stream.xId && [stream.xId length] > 0 ) {
        params[@"xid"] = stream.xId;
    }
    
    params[@"title"] = title;
    params[@"text"] = message;
    
    HCComment* createdComment = [[HCComment alloc] initWithId:nil stream:nil];
    
    [[HCNetwork instance] apiRequestPath:@"comments/create" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            [createdComment parse:((NSDictionary*)responseObject)];
            [createdComment.stream.commentsList retrieve]; // HACK
        }
        
        if( handler )
            handler( error?nil:createdComment, error);
        
    }];
    
    return createdComment;
    
}

+(HCComment*)createReply:(HCComment*)comment withTitle:(NSString*)title message:(NSString*)message withBlock:(HyperCommentsCompleteHandler)handler {
    
    if( !comment || comment.isJustCreated )
        return nil;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:5];
    params[@"link"] = comment.stream.link;
    
    if( comment.stream.xId && [comment.stream.xId length] > 0 ) {
        params[@"xid"] = comment.stream.xId;
    }
    
    params[@"parent_id"] = comment.commentId;
    
    params[@"title"] = title;
    params[@"text"] = message;
    
    HCComment* createdComment = [[HCComment alloc] initWithId:nil stream:nil];
    
    [[HCNetwork instance] apiRequestPath:@"comments/create" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            [createdComment parse:((NSDictionary*)responseObject)];
        }
        
        if( handler )
            handler( error?nil:createdComment, error);
        
    }];
    
    return createdComment;
    
}

#pragma mark - Methods

-(id)initWithId:(NSString*)commentId stream:(HCStream*)stream {
    if( self = [super init]) {
        _childComments = [NSMutableArray arrayWithCapacity:1];
        _commentId = commentId;
        _stream = stream;
    }
    return self;
}

-(void)parse:(NSDictionary*)rawData {
    
    if( _commentId && ![_commentId isEqualToString:rawData[@"id"]] )
        return;
    
    if( !self.stream && rawData[@"stream_id"] && rawData[@"link"] ) {
        _stream = [HCStream streamByLink:rawData[@"link"] xId:rawData[@"stream_id"]];
    }
    
    _author = [HCUser userByJSON:rawData];
    _categoryId = [NSNull null] == rawData[@"category"] ? 0 : [rawData[@"category"] unsignedIntegerValue];
    
    _isHypercomment = [[NSNumber numberWithInteger:[rawData[@"hc_comment"] integerValue]] boolValue];
    
    _message = rawData[@"text"];
    _countLikes = [rawData[@"vote_up"] unsignedIntegerValue];
    _countDislikes = [rawData[@"vote_dn"] unsignedIntegerValue];
    _countChildren = [rawData[@"children"] unsignedIntegerValue];
    _quoteId = [NSNull null] == rawData[@"quote_id"] ? 0 : [rawData[@"quote_id"] unsignedIntegerValue];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE, d MMM yyyy HH:mm:ss  z";//Tue, 24 Mar 2015 20:29:43 GMT
    _creationDate = [dateFormatter dateFromString:rawData[@"time"]];
    
    if( [NSNull null] != rawData[@"parent_id"] ) {
        _parentComment = [HCComment commentById:rawData[@"parent_id"] inStream:_stream];
        [_parentComment addChildComment:self];
    }
    
    if( [NSNull null] != rawData[@"root_id"] ) {
        _rootComment = [HCComment commentById:rawData[@"root_id"] inStream:_stream];
    }
    
    if( [NSNull null] != rawData[@"files"] ) {
        
        NSArray* rawFiles = (NSArray*)rawData[@"files"];
        
        _files = [NSMutableArray arrayWithCapacity:rawFiles.count];
        
        NSEnumerator* filesEnum = [rawFiles objectEnumerator];
        NSDictionary* rawFile;
        
        while( rawFile = [filesEnum nextObject] ) {
            [_files addObject:[HCMedia mediaByRawDictionary:rawFile]];
        }
        
    }
    
    /*
     "reason_del" = "<null>";
     state = 1;
     t = 0;
     
     @property (readonly) NSArray* childComments;
     */
    
}

-(BOOL)equals:(HCComment*)comment {
    return [self.commentId isEqualToString:comment.commentId];
}

-(void)addChildComment:(HCComment*)comment {
    
    NSEnumerator* childEnum = [_childComments objectEnumerator];
    HCComment* childComment;
    
    while( childComment = [childEnum nextObject] ) {
        if( [childComment equals:comment] )
            return;
    }
    
    [_childComments addObject:comment];
    
}

-(void)removeChildComment:(HCComment*)comment {
    
    NSEnumerator* childEnum = [_childComments objectEnumerator];
    HCComment* childComment;
    
    while( childComment = [childEnum nextObject] ) {
        if( [childComment equals:comment] ) {
            [_childComments removeObject:comment];
            break;
        }
    }

    
}

-(BOOL)vote:(HyperCommentVoteType)type {
    return [self vote:type withBlock:nil];
}

-(BOOL)vote:(HyperCommentVoteType)type withBlock:(HyperCommentsCompleteHandler)handler {
    
    if( !self.stream || self.isJustCreated )
        return NO;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"link"] = self.stream.link;
    
    if( self.stream.xId && [self.stream.xId length] > 0 ) {
        params[@"xid"] = self.stream.xId;
    }
    
    params[@"id"] = self.commentId;
    params[@"vote"] = type == VotePositive ? @"up" : @"dn";
    
    return [[HCNetwork instance] apiRequestPath:@"comments/vote" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            if(type == VotePositive)
                _countLikes++;
            else
                _countDislikes++;
        }
        
    }];
    
}

-(BOOL)remove {
    
    if( !self.stream || self.isJustCreated )
        return NO;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"link"] = self.stream.link;
    
    if( self.stream.xId && [self.stream.xId length] > 0 ) {
        params[@"xid"] = self.stream.xId;
    }
    
    params[@"id"] = self.commentId;
    
    return [[HCNetwork instance] apiRequestPath:@"comments/delete" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( !error && self.parentComment ) {
            [self.parentComment removeChildComment:self];
        }
        
    }];

}

-(BOOL)editText:(NSString*)text {
    if( !self.stream || self.isJustCreated )
        return NO;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"link"] = self.stream.link;
    
    if( self.stream.xId && [self.stream.xId length] > 0 ) {
        params[@"xid"] = self.stream.xId;
    }
    
    params[@"id"] = self.commentId;
    params[@"text"] = text;
    
    return [[HCNetwork instance] apiRequestPath:@"comments/edit" withParams:params authRequire:YES networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            self->_message = text;
        }
        
    }];
}

-(void)retrieve {
    [self retrieveWithBlock:nil];
}

-(void)retrieveWithBlock:(HyperCommentsCompleteHandler)handler {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"link"] = self.stream.link;
    
    if( self.stream.xId && [self.stream.xId length] > 0 ) {
        params[@"xid"] = self.stream.xId;
    }
    
    params[@"id"] = self.commentId;
    
    [[HCNetwork instance] apiRequestPath:@"comments/get" withParams:params networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            
            NSDictionary* rawDictionary = (NSDictionary*)responseObject[0];
            [self parse:rawDictionary];
            
        }
        
        if( handler )
            handler( self, error );
        
    }];
    
}



@end
