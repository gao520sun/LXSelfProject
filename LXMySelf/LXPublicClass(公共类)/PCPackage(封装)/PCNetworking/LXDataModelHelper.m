//
//  LXDataModelHelper.m
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXDataModelHelper.h"
#import "LXNetworkCache.h"
#import "MJExtension.h"
@implementation LXDataModelHelper

+(id)dataMapModel:(id)responseObj modelObject:(id)objectClass{
    if ([responseObj objectForKey:@"respDesc"] && [[responseObj objectForKey:@"respCode"] integerValue] !=0) {
        return nil;
    }else{
        //映射模型对象
        id class = nil;
        if(objectClass==nil){
            return responseObj;
        }else{
            if([objectClass isKindOfClass:[NSString class]]||[objectClass isKindOfClass:[NSObject class]]){
                if(responseObj && [responseObj isKindOfClass:[NSDictionary class]]){
                    
                    class  = [NSClassFromString(objectClass) mj_objectWithKeyValues:(NSDictionary *)responseObj];
                    
                }else if(responseObj && [responseObj isKindOfClass:[NSArray class]]){
                    
                    class  = [NSClassFromString(objectClass) mj_objectArrayWithKeyValuesArray:(NSDictionary *)responseObj];
                }
            }
            
        }
        return class;
    }
    return nil;

}


+(id)dataMapModelCache:(id)responseObj modelObject:(id)objectClass keyUrl:(NSString *)key{
    [LXNetworkCache saveHttpCache:responseObj forKey:key];
    id class = [self dataMapModel:responseObj modelObject:objectClass];
    return class;
}



+(id)getDataModelCache:(NSString *)key modelObject:(id)objectClass{
    id response =  [LXNetworkCache getHttpCacheForKey:key];
    id class = [self dataMapModel:response modelObject:objectClass];
    return class;
}



@end
