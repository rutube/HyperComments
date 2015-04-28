//
//  HCUser.m
//  HyperComments
//
//  Created by Jura on 3/24/15.
//
//

#import "HCUser.h"

@interface HCUser()
-(id)initWithId:(NSUInteger)userId;
-(void)parse:(NSDictionary*)rawDict;
@end

@implementation HCUser

+(HCUser*)userById:(NSUInteger)userId {
    static NSMutableDictionary* _users = nil;
    
    if(!_users)
        _users = [NSMutableDictionary dictionaryWithCapacity:2];
    
    HCUser* user = _users[[NSString stringWithFormat:@"%lu", (unsigned long)userId]];
    if(!user) {
        user = [[HCUser alloc] initWithId:userId];
        _users[[NSString stringWithFormat:@"%lu", (unsigned long)userId]] = user;
    }
    return user;
    
}

+(HCUser*)userByJSON:(NSDictionary*)rawDictionary {
    if( !rawDictionary || !rawDictionary[@"acc_id"] )
        return nil;
    HCUser* user = [HCUser userById:[rawDictionary[@"acc_id"] unsignedIntegerValue]];
    [user parse:rawDictionary];
    return user;
}

-(id)initWithId:(NSUInteger)userId {
    if(self = [super init]){
        _userId = userId;
    }
    return self;
}

-(void)parse:(NSDictionary*)rawDict {
    
    if( !rawDict || !rawDict[@"acc_id"] || self.userId != [rawDict[@"acc_id"] unsignedIntegerValue] )
        return;
    
    _userName = rawDict[@"nick"];
    _userGravatarHash = [NSNull null] != rawDict[@"md5email"] ? rawDict[@"md5email"] : nil;
    _userAvatarLink = [NSNull null] != rawDict[@"avatar"] ? rawDict[@"avatar"] : nil;
    
}

/*
 "acc_id" = 473785;
 nick = Juraldinio;
 md5email = "<null>";
 avatar = "http://pic.rutube.ru/user/9e/85/9e855638858d91a776c0bc5868d9dbf9.jpeg";
 */

@end
