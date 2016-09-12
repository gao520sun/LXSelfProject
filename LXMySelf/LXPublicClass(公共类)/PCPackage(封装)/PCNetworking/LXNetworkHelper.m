//
//  LXNetworkHelper.m
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXNetworkHelper.h"
#define GSNetWeakSelf typeof(self) __weak weakNetSelf = self;
@interface LXNetworkHelper()

@end

@implementation LXNetworkHelper

static LXNetworkHelper * net = NULL;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        net =  [[[self class] alloc] init];
    });
    return net;
}

-(id)init{
    if(self == [super init]){
        self.manager = [self createAFHTTPSessionManager];
    }
    return self;
}

#pragma mark - 设置AFHTTPSessionManager相关属性

- (AFHTTPSessionManager *)createAFHTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}

-(NSURLSessionTask *)lx_requestNetworkHelper:(LXParameterHelper *)parameter request:(LXRequestSuccess)success progress:(LXProgress)progress error:(LXRequestFailed)error{
    if(parameter.httpMethod == LX_GET){
        return [self getRequest:parameter request:success progress:progress error:error];
    }else if(parameter.httpMethod == LX_POST){
        return [self postRequest:parameter request:success progress:progress error:error];
    }else if(parameter.httpMethod == LX_POSTDATA){
        return [self postData:parameter request:success progress:progress error:error];
    }else if(parameter.httpMethod == LX_POSTIMAGES){
        return [self postImageSRequest:parameter request:success progress:progress error:error];
    }else if(parameter.httpMethod == LX_DOWNLOAD){
        return [self downloadWithURL:parameter progress:progress success:success failure:error];
    }else if(parameter.httpMethod == LX_DOWNLOAD_REUMEDATA){
        return [self downloadWithResumeDataURL:parameter progress:progress success:success failure:error];
    }
    return nil;
}


#pragma mark GET
-(NSURLSessionTask *)getRequest:(LXParameterHelper *)lxParm request:(LXRequestSuccess)success progress:(LXProgress)progress error:(LXRequestFailed)failure{
    
     NSURLSessionTask *dataTask = [self.manager GET:lxParm.url parameters:lxParm.parameter progress:^(NSProgress * _Nonnull downloadProgress) {
         progress ? progress(downloadProgress) :assert(@"progress为空");
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure ? failure(error) : nil;
     }];
    [dataTask resume];
    return dataTask;
}

#pragma mark POST
-(NSURLSessionTask *)postRequest:(LXParameterHelper *)lxParm request:(LXRequestSuccess)success progress:(LXProgress)progress error:(LXRequestFailed)failure{
    
    NSURLSessionTask *dataTask =  [self.manager POST:lxParm.url parameters:lxParm.parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) :assert(@"progress为空");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark POSTIMAGE
-(NSURLSessionTask *)postImageSRequest:(LXParameterHelper *)lxParm
                                   request:(LXRequestSuccess)success
                                  progress:(LXProgress)progress
                                     error:(LXRequestFailed)failure{
    
    NSURLSessionTask *dataTask = [self.manager POST:lxParm.url parameters:lxParm.parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传图片
        [lxParm.imageS enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:lxParm.name fileName:[NSString stringWithFormat:@"%@%ld.%@",lxParm.fileName,idx,lxParm.mimeType?lxParm.mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",lxParm.mimeType?lxParm.mimeType:@"jpeg"]];
        }];
//        for(int i = 0 ; i<lxParm.imageS.count; i++){
//            NSData *data = lxParm.imageS[i];
//            [formData appendPartWithFileData:data name:@"img" fileName:@"picfile.jpg" mimeType:@"jpg/png"];
//        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) :assert(@"progress为空");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    [dataTask resume];
    return dataTask;
}

#pragma mark POSTDATA
- (NSURLSessionTask *)postData:(LXParameterHelper *)lxParm
                           request:(LXRequestSuccess)success
                          progress:(LXProgress)progress
                             error:(LXRequestFailed)failure{
    
//    GSNetWeakSelf
//    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    _manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:lxParm.url]];
    
    if(lxParm.parameter){
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:session.parameters options:NSJSONWritingPrettyPrinted error: nil];
        NSData *jsonData;
        NSMutableString *temMutableString = [NSMutableString stringWithString:@""];
        for(NSString *key in lxParm.parameter.allKeys)
        {
            [temMutableString appendFormat:@"&%@=%@",key,[lxParm.parameter objectForKey:key]];
        }
        jsonData = [temMutableString dataUsingEncoding:NSUTF8StringEncoding];
        //        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        [request setHTTPBody:jsonData];
        [request setValue:[NSString stringWithFormat:@"%d",(int)jsonData.length] forHTTPHeaderField:@"Content-Length"];
    }
    [request setHTTPMethod:@"POST"];
    
    __block NSURLSessionTask *dataTask =[self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
         progress ? progress(uploadProgress) :assert(@"progress为空");
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            success(responseObject);
        }else{
            failure ? failure(error) : nil;
        }
        
    }];
    [dataTask resume];
    return dataTask;}




#pragma mark 下载文件

- (NSURLSessionTask *)downloadWithURL:(LXParameterHelper *)lxParm
                             progress:(LXProgress)progress
                              success:(LXRequestSuccess)success
                              failure:(LXRequestFailed)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lxParm.url]];
    
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
//        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:lxParm.fileDir ? lxParm.fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
//        NSLog(@"downloadDir = %@",downloadDir);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(!success){
            failure(error);
        }else{
            success(filePath.absoluteString);
        }
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;

}




- (NSURLSessionTask *)downloadWithResumeDataURL:(LXParameterHelper *)lxParm
                             progress:(LXProgress)progress
                              success:(LXRequestSuccess)success
                              failure:(LXRequestFailed)failure{

    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithResumeData:lxParm.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress(downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:lxParm.fileDir ? lxParm.fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(!success){
            failure(error);
        }else{
            success(filePath.absoluteString);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}






@end
