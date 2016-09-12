//
//  LXDataModelHelper.h
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXDataModelHelper : NSObject

/**
 *  数据处理
 *
 *  @param responseObj 网络返回原始数据
 *  @param objectClass 需要映射模型字符串,objectClass=nil时候返回原始数据
 *
 *  @return 返回原始数据或模型数据
 */
+(id)dataMapModel:(id)responseObj modelObject:(id)objectClass;

/**
 *  缓存数据处理
 *
 *  @param responseObj 网络返回原始数据
 *  @param objectClass 需要映射模型字符串,objectClass=nil时候返回原始数据
 *  @param key         根据key标示缓存，这里默认接口url
 *
 *  @return 返回原始数据或模型数据
 */
+(id)dataMapModelCache:(id)responseObj modelObject:(id)objectClass keyUrl:(NSString *)key;

/**
 *  获取缓存数据
 *
 *  @param key         根据key获取缓存，这里默认接口url
 *  @param objectClass 需要映射模型字符串,objectClass=nil时候返回原始数据
 *
 *  @return 返回数据
 */
+(id)getDataModelCache:(NSString *)key modelObject:(id)objectClass;

@end
