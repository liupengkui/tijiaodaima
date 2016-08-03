//
//  PKxiazaitupian.h
//  异步下载网络图片2
//
//  Created by 刘 on 16/7/31.
//  Copyright © 2016年 刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKxiazaitupian : NSObject
+ (instancetype)sharedManager;
- (void)downloadImageWithUrlString:(NSString *)urlString compeletion:(void(^)(UIImage *))compeletion;
- (void)cancelOperationWithUrlString:(NSString *)urlString;
@end
