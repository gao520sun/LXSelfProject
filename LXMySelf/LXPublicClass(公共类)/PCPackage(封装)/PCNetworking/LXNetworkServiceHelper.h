//
//  LXNetworkServiceHelper.h
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXNetworkHelper.h"
@interface LXNetworkServiceHelper : LXNetworkHelper

-(NSArray *)getDownloadTask;
/**
 *  服务
 *
 *  @param url      请求地址
 *  @param params   请求参数
 *  @param object   转换模型
 *  @param method   请求方法
 *  @param success  成功返回
 *  @param progress 进度
 *  @param failed   错误信息
 *
 *  @return
 */
-(NSURLSessionTask *)lx_serviceWithUrl:(NSString *)url
                        params:(id)params
                   modelObject:(id)object
                   requestType:(LXRequestMethod)method
                       request:(LXRequestSuccess)success
                      progress:(LXProgress)prs
                         failed:(LXRequestFailed)failed;
/**
 *  下载文件
 *
 *  @param url     下载地址
 *  @param params  参数
 *  @param fileDir 缓存目录
 *  @param success 成功返回
 *  @param prs     进度
 *  @param failed  错误信息
 *
 *  @return
 */
-(NSURLSessionDownloadTask *)lx_serviceDownloadWithUrl:(NSString *)url
                  params:(id)params
                 fileDir:(NSString *)fileDir
                 request:(LXRequestSuccess)success
                progress:(LXProgress)prs
                  failed:(LXRequestFailed)failed;

/**
 *  上次文件
 *
 *  @param url      请求地址
 *  @param params   请求参数
 *  @param images   图片
 *  @param name     名字
 *  @param fileName 文件名字
 *  @param mimeType 类型
 *  @param success  成功
 *  @param prs      进度
 *  @param failed   错误
 *
 *  @return
 */
-(NSURLSessionTask *)lx_serviceUploadWithUrl:(NSString *)url
                                        params:(id)params
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                       request:(LXRequestSuccess)success
                                      progress:(LXProgress)prs
                                        failed:(LXRequestFailed)failed;

/**
 *  服务+缓存&下载文件和图片上传不需要缓存.
 *
 *  @param url           请求地址
 *  @param params        请求参数
 *  @param object        转换模型
 *  @param responseCache 返回缓存数据
 *  @param method        调用方法
 *  @param success       成功
 *  @param prs           进度
 *  @param failed        错误信息
 */
-(NSURLSessionTask *)lx_serviceCacheWithUrl:(NSString *)url
                       params:(id)params
                  modelObject:(id)object
                responseCache:(LXRequestCache)responseCache
                  requestType:(LXRequestMethod)method
                      request:(LXRequestSuccess)success
                     progress:(LXProgress)prs
                       failed:(LXRequestFailed)failed;
@end
