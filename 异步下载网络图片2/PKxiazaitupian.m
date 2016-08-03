//
//  PKxiazaitupian.m
//  异步下载网络图片2
//
//  Created by 刘 on 16/7/31.
//  Copyright © 2016年 刘. All rights reserved.
//

#import "PKxiazaitupian.h"
#import "NSString+path.h"
#import "PKwangluoxiazai.h"

@interface PKxiazaitupian ()
/**
 *  图片内存缓存
 */
@property (nonatomic, strong) NSCache *imageCache;

/**
 *  操作缓存
 */
@property (nonatomic, strong) NSMutableDictionary *operationCache;

/**
 *  队列
 */
@property (nonatomic, strong) NSOperationQueue *queue;


@end

@implementation PKxiazaitupian
+ (instancetype)sharedManager {
    static PKxiazaitupian *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化两个缓存&一个队列
        self.imageCache = [[NSCache alloc]init];
        self.operationCache = [NSMutableDictionary dictionary];
        self.queue = [NSOperationQueue new];
        
        // 注册内存警告的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

/**
 *  接收到内存警告的通知之后要做的事情
 */
- (void)memoryWarning {
    NSLog(@"收到内存警告");
    // 1. 清除图片
    [self.imageCache removeAllObjects];
    // 2. 清除操作
    [self.operationCache removeAllObjects];
    // 3. 取消队列中所有的操作
    [self.queue cancelAllOperations];
}

/**
 *  在此里面去移除通知,虽然当前是一个单例
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)downloadImageWithUrlString:(NSString *)urlString compeletion:(void(^)(UIImage *))compeletion{
    
    UIImage*image=[self.imageCache objectForKey:urlString];
    if (image) {
        compeletion(image);
        return;
        
    }
    NSString *sanboxPath = [urlString appendCachePath];
        image = [UIImage imageWithContentsOfFile:sanboxPath];
        if (image != nil) {
            NSLog(@"从沙盒中取");
            // 2.2 如果沙盒中有,使用block将图片回调
            compeletion(image);
            // 2.3 把图片保存到内存中一份,以便下次直接从内存中加载
            [self.imageCache setObject:image forKey:urlString];
            return;
        }
    // 3. 判断操作有没有
    if (self.operationCache[urlString] != nil) {
        // 3.1 如果操作有,直接什么事情都不做直接返回
        NSLog(@"操作已存在,代表正在下载,请骚等!!!");
        return;
    }
    
    PKwangluoxiazai*op=[PKwangluoxiazai operationWithUrlString:urlString];
    __weak PKwangluoxiazai*ooop=op;
    [op setCompletionBlock:^{
        UIImage *image = ooop.image;
        if (ooop.isCancelled) {
            NSLog(@"该操作已被取消,所以不用回调");
            return;
        }
        // 回到主线程调用block,将image传出去
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 保存到内存中一份
            [self.imageCache setObject:image forKey:urlString];
            // 将当前操作从缓存中移除
            [self.operationCache removeObjectForKey:urlString];
            compeletion(image);
        }];
        
    }];
    // 将操作添加到操作的缓存
    [self.operationCache setObject:op forKey:urlString];
    // 5. 将操作添加到队列
    [self.queue addOperation:op];
    
}
- (void)cancelOperationWithUrlString:(NSString *)urlString{
    
    // 1. 取到这个url对应的操作
    NSOperation *op = [self.operationCache objectForKey:urlString];
    // 2. 取消它
    if (op != nil) {
        [op cancel];
        // 3. 将该操作从操作缓存中移除
        [self.operationCache removeObjectForKey:urlString];
        
    }
}

@end
