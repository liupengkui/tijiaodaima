//
//  PKmoxing.h
//  异步下载网络图片2
//
//  Created by 刘 on 16/7/30.
//  Copyright © 2016年 刘. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PKmoxing : NSObject
/**
 *  下载数量
 */
@property (nonatomic, copy) NSString *download;
/**
 *  图标地址
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  app名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  当前模型对像的image
 */
@property (nonatomic, strong) UIImage *image;

@end
