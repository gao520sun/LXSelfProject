//
//  LXNetworkCache.m
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXNetworkCache.h"
#import "YYCache.h"
@interface LXNetworkCache()
{
}
@end
@implementation LXNetworkCache
static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;

+ (void)initialize{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveHttpCache:(id)httpCache forKey:(NSString *)key
{
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpCache forKey:key withBlock:nil];
}

+ (id)getHttpCacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache
{
    [_dataCache.diskCache removeAllObjects];
}

+ (void)removeHttpCacheForKey:(NSString *)key
{
    [_dataCache.diskCache removeObjectForKey:key];
}

@end
