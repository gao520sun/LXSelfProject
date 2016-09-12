//
//  LXParameterHelper.h
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LX_GET = 1,
    LX_POST,
    LX_PUT,
    LX_POSTDATA,
    LX_POSTIMAGES,
    LX_DOWNLOAD,
    LX_DOWNLOAD_REUMEDATA
}LXRequestMethod;

@interface LXParameterHelper : NSObject

+(instancetype)parameterHelper;

/**
 * 请求url
 */
@property (nonatomic, copy) NSString *url;

/*
 * 请求参数
 * 不能为空没有参数的时候给空字典
 */
@property (nonatomic, copy) NSDictionary *parameter;

/**
 * 请求头
 */
@property (nonatomic, copy) NSDictionary *header;

/**
 * 上传文件
 */
@property (nonatomic, copy) NSArray *imageS;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *mimeType;

/**
 *  下载文件临时存储data
 */
@property (nonatomic, copy) NSData *resumeData;

/**
 *  缓存目录文件
 */
@property (nonatomic, copy) NSString *fileDir;

/**
 * 请求类型
 */
@property (nonatomic, assign) LXRequestMethod httpMethod;

/**
 *  打印全部数据
 */
-(void)LX_description;

@end
