//
//  PKwangluoxiazai.h
//  异步下载网络图片2
//
//  Created by 刘 on 16/8/1.
//  Copyright © 2016年 刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKwangluoxiazai : NSOperation
@property (nonatomic, strong) UIImage *image;

/**
 *  通过一个urlString创建一个操作
 *
 *  @param urlString <#urlString description#>
 */
+ (instancetype)operationWithUrlString:(NSString *)urlString;
@end
