//
//  UIImageView+PKuiimage.h
//  异步下载网络图片2
//
//  Created by 刘 on 16/8/1.
//  Copyright © 2016年 刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PKuiimage)
@property (nonatomic, strong) NSString *urlString;

- (void)hm_setImageWithUrlString:(NSString *)string placeholderImage:(UIImage *)image;
@end
