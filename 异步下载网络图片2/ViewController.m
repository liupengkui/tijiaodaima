//
//  ViewController.m
//  异步下载网络图片2
//
//  Created by 刘 on 16/7/30.
//  Copyright © 2016年 刘. All rights reserved.
//

#import "ViewController.h"
#import "NSString+path.h"
#import "AFNetworking.h"
#import "PKmoxing.h"
#import "HMAppCell.h"
#import "PKxiazaitupian.h"
#import "UIImageView+PKuiimage.h"

@interface ViewController ()
/**
 *  装有模型信息的数组
 */
@property (nonatomic, strong) NSMutableArray *appInfos;
/**
 *  操作
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 *  图片缓存的字典 <key: 图片地址, value: 图片>;
 */
@property (nonatomic, strong) NSMutableDictionary *imageCache;

/**
 *  下载操作的缓存,避免重复下载
 */
@property (nonatomic, strong) NSMutableDictionary *queueCache;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self jiazaishuju];
}

-(void)jiazaishuju{
    
    NSString *urlString = @"https://raw.githubusercontent.com/yinqiaoyin/SimpleDemo/master/apps.json";
    AFHTTPSessionManager*manger=[AFHTTPSessionManager manager];
    [manger GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray*arry=responseObject;
        for (NSDictionary*dic in arry) {
            // 2. 初始化模型
            PKmoxing *info = [[PKmoxing alloc] init];
            // 3. 使用 kvc 的方式赋值
            [info setValuesForKeysWithDictionary:dic];
            
            // 4. 将模型添加到可变数组
            [self.appInfos addObject:info];
        }
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appInfos.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMAppCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // 取到对应位置的模型
    PKmoxing *info = self.appInfos[indexPath.row];
    // 设置数据
    cell.nameLabel.text = info.name;
    cell.downloadLabel.text = info.download;
    cell.iconView.image = nil;
    [cell.iconView hm_setImageWithUrlString:info.icon placeholderImage:[UIImage imageNamed:@"user_default"]];

//    [[PKxiazaitupian sharedManager] downloadImageWithUrlString:info.icon compeletion:^(UIImage *image) {
//        cell.iconView.image = image;
//    }];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.imageCache removeAllObjects];
    
    // 2. 取消掉队列中的所有操作
    [self.queue cancelAllOperations];
    // 3. 移除所有的操作
    [self.queueCache removeAllObjects];
}

- (NSMutableArray *)appInfos {
    if (_appInfos == nil) {
        _appInfos = [NSMutableArray array];
    }
    return _appInfos;
}

@end
