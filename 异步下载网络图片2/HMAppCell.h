//
//  HMAppCell.h
//  09-异步下载网络图片
//
//  Created by heima on 16/7/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAppCell : UITableViewCell

/**
 *  图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  下载数量
 */
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end
