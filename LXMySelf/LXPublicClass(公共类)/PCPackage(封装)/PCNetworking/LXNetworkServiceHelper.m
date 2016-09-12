//
//  LXNetworkServiceHelper.m
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXNetworkServiceHelper.h"
#import "LXDataModelHelper.h"
#import "LXFileCacheManager.h"
#import <objc/runtime.h>
@interface LXNetworkHelper()
@property (nonatomic,copy)NSMutableDictionary *requestNetWorkDic;//保存网络状态
@end

@implementation LXNetworkServiceHelper


-(NSArray *)getDownloadTask{
    return self.manager.downloadTasks;
}

-(NSURLSessionTask *)lx_serviceWithUrl:(NSString *)url
                        params:(id)params
                   modelObject:(id)object
                   requestType:(LXRequestMethod)method
                       request:(LXRequestSuccess)success
                      progress:(LXProgress)prs
                        failed:(LXRequestFailed)failed{
    
    LXParameterHelper *lxparam = [self lx_url:url params:params requestType:method fileDir:nil];
    
     NSURLSessionTask *task = [self lx_requestNetworkHelper:lxparam request:^(id responseObject) {
         id resObj = [LXDataModelHelper dataMapModel:responseObject modelObject:object];
         success(resObj);
     } progress:^(NSProgress *progress) {
         prs(progress);
     } error:^(NSError *error) {
         failed(error);
     }];
    return task;
}

-(NSURLSessionTask *)lx_serviceCacheWithUrl:(NSString *)url
                  params:(id)params
             modelObject:(id)object
            responseCache:(LXRequestCache)responseCache
             requestType:(LXRequestMethod)method
                 request:(LXRequestSuccess)success
                progress:(LXProgress)prs
                  failed:(LXRequestFailed)failed{
    
    LXParameterHelper *lxparam = [self lx_url:url params:params requestType:method fileDir:nil];
    responseCache([LXDataModelHelper getDataModelCache:lxparam.url modelObject:object]);
    NSURLSessionTask *task = [self lx_requestNetworkHelper:lxparam request:^(id responseObject) {
        id resO = [LXDataModelHelper dataMapModelCache:responseObject modelObject:object keyUrl:lxparam.url];
        success(resO);
    } progress:^(NSProgress *progress) {
        prs(progress);
    } error:^(NSError *error) {
        failed(error);
    }];
    return task;
}

-(NSURLSessionDownloadTask *)lx_serviceDownloadWithUrl:(NSString *)url
                                                params:(id)params
                                               fileDir:(NSString *)fileDir
                                               request:(LXRequestSuccess)success
                                              progress:(LXProgress)prs
                                                failed:(LXRequestFailed)failed{
    BOOL resume = NO;
   long long size =  [[LXFileCacheManager sharedManager]directorySizeName:url];
    if(size>0){
        resume = [[LXFileCacheManager sharedManager]fileTempExistsAtPath:[[LXFileCacheManager sharedManager]getPlistContent:url]];
    }else{
        resume = NO;
    }
    
    if(!resume){
        LXParameterHelper *lxparam = [self lx_url:url params:params requestType:LX_DOWNLOAD fileDir:fileDir];
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)[self lx_requestNetworkHelper:lxparam request:^(id responseObject) {
            if(responseObject){
                [self deleteTo:url];
            }
            
            success(responseObject);
        } progress:^(NSProgress *progress) {
            prs(progress);
        } error:^(NSError *error) {
            failed(error);
        }];
        [self tempFile:task key:url];
        return task;
    }else{
        LXParameterHelper *lxparam = [self lx_reumeUrl:url params:params requestType:LX_DOWNLOAD_REUMEDATA fileDir:fileDir];
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)[self lx_requestNetworkHelper:lxparam request:^(id responseObject) {
            if(responseObject){
                [self deleteTo:url];
            }
            success(responseObject);
        } progress:^(NSProgress *progress) {
            prs(progress);
        } error:^(NSError *error) {
            failed(error);
        }];
        return task;
    }
    return nil;
}

-(NSURLSessionTask *)lx_serviceUploadWithUrl:(NSString *)url
                                      params:(id)params
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                     request:(LXRequestSuccess)success
                                    progress:(LXProgress)prs
                                      failed:(LXRequestFailed)failed{
    LXParameterHelper *lxparam = [self lx_url:url params:params images:images name:name fileName:fileName mimeType:mimeType];
    NSURLSessionTask *task = [self lx_requestNetworkHelper:lxparam request:^(id responseObject) {
        success(responseObject);
    } progress:^(NSProgress *progress) {
        prs(progress);
    } error:^(NSError *error) {
        failed(error);
    }];
    return task;
}

-(void)deleteTo:(NSString *)url{
    
    BOOL b =  [[LXFileCacheManager sharedManager]deleteResumeDatakey:[url lastPathComponent]];
    if(b){
        NSLog(@"ResumeData删除成功");
    }
    BOOL b1 =  [[LXFileCacheManager sharedManager]deleteResumeDatakey:url];
    if(b1){
        NSLog(@"temp删除成功");
    }
}
-(LXParameterHelper *)lx_reumeUrl:(NSString *)url
                           params:(id)params
                      requestType:(LXRequestMethod)method
                          fileDir:(NSString *)fileDir{
    id data = [[LXFileCacheManager sharedManager]getPlistContent:[url lastPathComponent]];
//    NSMutableDictionary *resumeDataDict = [NSMutableDictionary dictionary];
//    NSMutableURLRequest *newResumeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [newResumeRequest addValue:[NSString stringWithFormat:@"bytes=%ld-",((NSData *)data).length] forHTTPHeaderField:@"Range"];
//    NSData *newResumeRequestData = [NSKeyedArchiver archivedDataWithRootObject:newResumeRequest];
//    [resumeDataDict setObject:[NSNumber numberWithInteger:((NSData *)data).length]forKey:@"NSURLSessionResumeBytesReceived"];
//    [resumeDataDict setObject:newResumeRequestData forKey:@"NSURLSessionResumeCurrentRequest"];
//    [resumeDataDict setObject:[[[LXFileCacheManager sharedManager]getPlistContent:url] lastPathComponent] forKey:@"NSURLSessionResumeInfoTempFileName"];
//    NSData *resumeData = [NSPropertyListSerialization dataWithPropertyList:data format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
    
    
    LXParameterHelper *lxpara = [LXParameterHelper parameterHelper];
    lxpara.url = url;
    lxpara.resumeData = data;
    lxpara.fileDir = fileDir;
    lxpara.parameter = params;
    lxpara.httpMethod = method;
    return lxpara;
}


-(LXParameterHelper *)lx_url:(NSString *)url
                      params:(id)params
                      images:(NSArray<UIImage *> *)images
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)mimeType{
    LXParameterHelper *lxpara = [LXParameterHelper parameterHelper];
    lxpara.url = url;
    lxpara.parameter = params;
    lxpara.httpMethod = LX_POSTIMAGES;
    lxpara.name = name;
    lxpara.fileName = fileName;
    lxpara.mimeType = mimeType;
    [lxpara LX_description];
    return lxpara;
}

-(LXParameterHelper *)lx_url:(NSString *)url
                   params:(id)params
              requestType:(LXRequestMethod)method
                  fileDir:(NSString *)fileDir{
    LXParameterHelper *lxpara = [LXParameterHelper parameterHelper];
    lxpara.url = url;
    lxpara.parameter = params;
    lxpara.httpMethod = method;
    lxpara.fileDir = fileDir;
    [lxpara LX_description];
    return lxpara;
}


-(void)tempFile:(NSURLSessionDownloadTask *)task key:(NSString *)key{
    //拉取属性
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([task class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        if ([@"downloadFile" isEqualToString:propertyName])
        {
            id propertyValue = [task valueForKey:(NSString *)propertyName];
            unsigned int downloadFileoutCount, downloadFileIndex;
            objc_property_t *downloadFileproperties = class_copyPropertyList([propertyValue class], &downloadFileoutCount);
            for (downloadFileIndex = 0; downloadFileIndex < downloadFileoutCount; downloadFileIndex++)
            {
                objc_property_t downloadFileproperty = downloadFileproperties[downloadFileIndex];
                const char* downloadFilechar_f =property_getName(downloadFileproperty);
                NSString *downloadFilepropertyName = [NSString stringWithUTF8String:downloadFilechar_f];
                if([@"path" isEqualToString:downloadFilepropertyName])
                {
                    id downloadFilepropertyValue = [propertyValue valueForKey:(NSString *)downloadFilepropertyName];
                    //                    if(!contiueDownload)
                    //                    {
                    
                    [[LXFileCacheManager sharedManager]saveTempFiles:downloadFilepropertyValue url:key];
                    //                    }
                    
                    break;
                }
            }
            free(downloadFileproperties);
        }
        else
        {
            continue;
        }
    }
    free(properties);
}

@end
