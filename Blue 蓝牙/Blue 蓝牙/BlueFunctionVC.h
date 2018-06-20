//
//  BlueFunctionVC.h
//  Blue 蓝牙
//
//  Created by 吾诺翰卓 on 2018/1/26.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueFunctionVC : UIViewController


@property (nonatomic, strong)void(^blueduan)(NSInteger state);

@end
