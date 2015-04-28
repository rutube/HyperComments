//
//  HCMedia.h
//  HyperComments
//
//  Created by Juraldinio on 3/24/15.
//
//

#import <Foundation/Foundation.h>

@interface HCMedia : NSObject

@property (readonly) NSString* mediaType;
@property (readonly) NSString* mediaService;
@property (readonly) NSString* mediaHref;
@property (readonly) NSString* mediaId;
@property (readonly) NSString* mediaPreview;

+(HCMedia*)mediaByRawDictionary:(NSDictionary*)rawDict;

/*
 type	Тип медиа вложения [images|video|presentation]
 service	Сервис через который отправлено медиа вложение
 href	Путь к ресурсу
 id	ID медиа вложения (для type = video)
 preview	Путь к картинке предварительного просмотра видео
*/

@end
