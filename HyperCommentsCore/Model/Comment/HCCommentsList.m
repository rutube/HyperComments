//
//  HyperCommentCommentsList.m
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import "HCCommentsList.h"
#import "HCStream.h"
#import "HCNetwork.h"

@interface HCCommentsList()
-(void)addComment:(HCComment*)comment;
@end

@implementation HCCommentsList {
    
    HCStream* _stream;
    NSMutableArray* _comments;
    HyperCommentSorting _sortType;
    
}

-(id)initWithStream:(HCStream*)stream {
    
    if( self = [super init] ) {
        _stream = stream;
        _limit = 20;
        _comments = [NSMutableArray arrayWithCapacity:5];
    }
    
    return self;
    
}

-(void)retrieve {
    [self retrievePage:0 withBlock:nil];
}

-(void)retrievePage:(NSUInteger)page withBlock:(HyperCommentsCompleteHandler)handler {
    
    if( !_stream )
        return;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"link"] = _stream.link;
    
    if( _stream.xId && [_stream.xId length] > 0 ) {
        params[@"xid"] = _stream.xId;
    }
    
    switch( self.sortType ) {
        case SortAll:
            params[@"sort"] = @"all";
            break;
        case SortNew:
            params[@"sort"] = @"new";
            break;
        default:
            params[@"sort"] = @"popular";
    }
    
    params[@"limit"] = ( self.limit > 20 ) ? @20 : [NSNumber numberWithUnsignedInteger:self.limit];
    
    params[@"offset"] = [NSNumber numberWithUnsignedInteger:(page * self.limit)];
    
    
    [[HCNetwork instance] apiRequestPath:@"comments/list" withParams:params networkHandler:^(id responseObject, NSError *error) {
        
        if( !error ) {
            
            NSEnumerator* rawCommentsEnum = [((NSArray*)responseObject) objectEnumerator];
            NSDictionary* rawComment;
            HCComment* comment;
            
            while( rawComment = [rawCommentsEnum nextObject] ) {
                
                comment = [HCComment commentByRaw:rawComment inStream:_stream];
                
                [self addComment:comment];
                
            }
            
            
        }
        
        if(handler)
            handler(self, error);
        
    }];
    
}

//
-(HyperCommentSorting)sortType {
    return _sortType;
}

-(void)setSortType:(HyperCommentSorting)sortType {
    
    if( _sortType == sortType )
        return;
    
    [_comments removeAllObjects];
    
    _sortType = sortType;
    
}

#pragma mark - Private

-(void)addComment:(HCComment*)comment {
    
    // Prvent add same comment
    HCComment* hcComment;
    
    if( comment && comment.parentComment )
        return;
    
    for( unsigned i = 0; i < _comments.count; i++ ) {
        
        hcComment = _comments[i];
        
        if( [hcComment equals:comment] )
            return;
        
        if( [hcComment.creationDate compare:comment.creationDate] == NSOrderedAscending ) {
            [_comments insertObject:comment atIndex:i];
            return;
        }
        
    }
    
    [_comments addObject:comment];
    
}


@end
