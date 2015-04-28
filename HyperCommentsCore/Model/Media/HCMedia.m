//
//  HCMedia.m
//  HyperComments
//
//  Created by Juraldinio on 3/24/15.
//
//

#import "HCMedia.h"

@interface HCMedia()
-(id)initWithDict:(NSDictionary*)rawDict;
@end

@implementation HCMedia

/*
 {
 \"type\" : \"video\",
 \"service\" : \"youtube\",
 \"href\" : \"https:\/\/www.youtube.com\/watch?v=Zelg\",
 \"id\" : \"Zelg"\,
 \"preview"\ : \"http:\/\/img.youtube.com\/vi\/Zelg\/1.jpg\"
 },
 */

-(id)initWithDict:(NSDictionary*)rawDict {
    
    if(self = [super init]) {
        
        if(rawDict) {
            
            _mediaId = rawDict[@"id"];
            _mediaType = rawDict[@"type"];
            _mediaService = rawDict[@"service"];
            _mediaHref = rawDict[@"href"];
            _mediaPreview = rawDict[@"preview"];
            
        }
        
    }
    
    return self;
    
}

+(HCMedia*)mediaByRawDictionary:(NSDictionary*)rawDict {
    return [[HCMedia alloc] initWithDict:rawDict];
}

@end
