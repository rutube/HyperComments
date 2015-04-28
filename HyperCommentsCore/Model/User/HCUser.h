//
//  HCUser.h
//  HyperComments
//
//  Created by Jura on 3/24/15.
//
//

#import <Foundation/Foundation.h>

@interface HCUser : NSObject

@property (readonly) NSUInteger userId;
@property (readonly) NSString* userName;
@property (readonly) NSString* userGravatarHash;
@property (readonly) NSString* userAvatarLink;

+(HCUser*)userById:(NSUInteger)userId;
+(HCUser*)userByJSON:(NSDictionary*)rawDictionary;

@end
