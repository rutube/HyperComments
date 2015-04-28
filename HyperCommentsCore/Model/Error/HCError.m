//
//  HyperCommentError.m
//  HyperComments
//
//  Created by Jura on 3/23/15.
//
//

#import "HCError.h"

@interface HCError()

+(NSArray*)rawErrorStrings;
+(NSArray*)errorStrings;

+(NSUInteger)errorCodeForString:(NSString*)errorString;

@end

@implementation HCError

+(NSString*)errorDomain {
    return @"HyperComment.Error";
}

+(HCError*)errorWithCode:(NSString*)errorCode message:(NSString*)message {
    
    NSUInteger code = [HCError errorCodeForString:errorCode];
    
    return [[HCError alloc] initWithDomain:[HCError errorDomain]
                                                code:code
                                  userInfo:@{NSLocalizedDescriptionKey: (message ? message : [HCError errorStrings][code]) }];
    
}

#pragma mark - Helper methods

+(NSArray*)rawErrorStrings {
    static NSArray* _errorStrings;
    if(!_errorStrings) {
        _errorStrings = @[@"", @"err_missing", @"err_empty", @"err_wrong",
                            @"err_path", @"err_ip_request_limit", @"err_widget_request_limit",
                            @"err_widgetid_error", @"err_empty_secret_key", @"err_invalid_signature",
                            @"err_site_auth_off", @"err_stream_not_found", @"err_user_not_logged",
                            @"err_flood", @"err_no_parent", @"err_access_denied",
                            @"err_already_vote", @"err_already_vote_page"];
    }
    return _errorStrings;
}

+(NSArray*)errorStrings {
    static NSArray* _errorLocalStrings;
    if(!_errorLocalStrings) {
        _errorLocalStrings = @[@"", @"Обязательный параметр не был передан", @"Обязательный параметр пуст", @"Значение параметра некорректно",
                               @"Неверный путь к API", @"Вы достигли лимита запросов с одно ip адреса", @"Вы достигли лимита запросов для Вашего тарифного плана",
                               @"Виджет не найден в базе или он был заблокирован", @"Секретный ключ не введен в настройках API для этого виджета", @"Неверная подпись запроса",
                               @"SSO авторизация отключена в настройках API", @"Страница с указанным id не найдена", @"Пользователь не авторизирован",
                               @"Комментарий помечен как флуд", @"Нет родительского комментария", @"Доступ закрыт",
                               @"Пользователь уже проголосовал за комментарий", @"Пользователь уже проголосовал за страницу"];
    }
    return _errorLocalStrings;
}

+(NSUInteger)errorCodeForString:(NSString*)errorString {
    
    NSArray* rawErrors = [HCError rawErrorStrings];
    
    for(NSUInteger i = 0;i < rawErrors.count; i++) {
        if( [errorString isEqualToString:rawErrors[i]] )
            return i;
    }
    
    return 0;
    
}

@end
