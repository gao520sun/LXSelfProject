//
//  LXNetworkHelper.h
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#import "LXParameterHelper.h"
/** 请求成功的Block */
typedef void(^LXRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^LXRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^LXRequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^LXProgress)(NSProgress *progress);

@interface LXNetworkHelper : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *manager;//管理网络接口

+(instancetype)sharedManager;

/**
 *  网络请求状态,如果不执行子类LXNetworkServiceHelper中方法lx_serviceWithUrl:等方法,可以调用该方法请求接口.
 *
 *  @param parameter 网络参数配置
 *  @param success   成功
 *  @param progress  进度
 *  @param error     错误
 *
 *  @return task
 */
-(NSURLSessionTask *)lx_requestNetworkHelper:(LXParameterHelper *)parameter
                                         request:(LXRequestSuccess)success
                                        progress:(LXProgress)progress
                                           error:(LXRequestFailed)error;



@end
