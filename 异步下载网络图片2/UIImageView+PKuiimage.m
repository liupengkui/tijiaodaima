//
//  UIImageView+PKuiimage.m
//  异步下载网络图片2
//
//  Created by 刘 on 16/8/1.
//  Copyright © 2016年 刘. All rights reserved.
//

#import "UIImageView+PKuiimage.h"
#import <objc/runtime.h>
#import "PKxiazaitupian.h"
const char *kUrlString = "kUrlString";

@implementation UIImageView (PKuiimage)

- (void)hm_setImageWithUrlString:(NSString *)string placeholderImage:(UIImage *)image {
    
    // 判断之前下载的图片,如果有,就取消之前的下载
    
    if (self.urlString != nil && ![self.urlString isEqualToString:string]) {
        NSLog(@"之的操作被取消了");
        // 取消掉之前的下载操作
        // 如何才能取到之前的下载地址 --> 在每一次下载的时候,将下载地址保存一下
        /**
         1. 下载`爸爸去哪儿`的时候,将该图片地址保存起来
         2. 当用户滑动到最上面的时候,又会去下载植物,在这个时候就可以取到上一次的下载地址
         3. 再通过地址去取消`爸爸去哪儿`的下载操作
         
         */
        [[PKxiazaitupian sharedManager] cancelOperationWithUrlString:self.urlString];
        
    }
    
        self.urlString = string;
        
        // 再下载新的图片
        /**
         如果每一张图片下载的时候不一定,那么还是会产生图片错乱 ,怎么解决
         */
        [[PKxiazaitupian sharedManager] downloadImageWithUrlString:string compeletion:^(UIImage *image) {
            NSLog(@"已下载好的image:%@", image);
            self.image = image;
            // 当前图片已下载成功 : 当前图片已经下载成功了,所以不需要再保存图片地址,因为下次再进来的时候就重新去下载另外一张图片
            self.urlString = nil;
        }];
    

    }

-(NSString*)urlString{
    return objc_getAssociatedObject(self, kUrlString);
    
}

-(void)setUrlString:(NSString *)urlString{
    
    objc_setAssociatedObject(self, kUrlString, urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

@end
