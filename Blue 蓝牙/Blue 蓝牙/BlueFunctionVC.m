//
//  BlueFunctionVC.m
//  Blue 蓝牙
//
//  Created by 吾诺翰卓 on 2018/1/26.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "BlueFunctionVC.h"
#import "ETK.h"

@interface BlueFunctionVC ()

@end

@implementation BlueFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self nav];
    [self createUI];
    
    ETK * YiTieKang = [ETK shareBLEManager];
    
    //蓝牙设备中途断开
    YiTieKang.blueContentState = ^(id object) {
        NSInteger index = [object integerValue];
        switch (index) {
            case -2:
                [self dismissViewControllerAnimated:YES completion:nil];
                if (_blueduan) {
                    _blueduan(1);
                }
                break;
            default:
                break;
        }
    };
    //蓝牙设备当前电量：百分比
    YiTieKang.blueNowBettery = ^(NSString *bettery) {
        NSLog(@"当前电量：%@", bettery);
    };
    //蓝牙设备是否开启  开启关闭设备时候返回
    YiTieKang.blueIsOpen = ^(BOOL state) {
        if (state) {
            NSLog(@"设备已开启");
        } else{
            NSLog(@"设备已关闭");
        }
    };
    //蓝牙设备当前强度  增减强度成功时返回
    YiTieKang.blueNowStrength = ^(NSString *blueStrength) {
        NSLog(@"蓝牙设备当前强度:%@", blueStrength);
    };
    //设备当前状态
    YiTieKang.blueNowState = ^(NSString *blueState, NSString *blueTime, NSString *blueStrength) {
        NSLog(@"当前设备处在 %@ 阶段", blueState);
        NSLog(@"当前设备已运行 %@ s", blueTime);
        NSLog(@"当前设备强度 %@ ", blueStrength);
    };
}

- (void)nav{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k_NavigationHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(60, k_NavigationHeight - 44, kScreenWidth - 120, 44)];
    title.text = @"蓝牙";
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, k_NavigationHeight - 44, 60, 44);
    [leftBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:title];
    [navView addSubview:leftBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, k_NavigationHeight - 0.5, kScreenWidth, 0.5)];
    line.backgroundColor = HOME_COLOR;
    [navView addSubview:line];
    [self.view addSubview:navView];
}

- (void)createUI{
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(kScreenWidth/2 - 120, k_NavigationHeight + 50, 100, 40);
    openBtn.backgroundColor = [UIColor blueColor];
    [openBtn setTitle:@"开启设备" forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBlue) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kScreenWidth/2 + 20, k_NavigationHeight + 50, 100, 40);
    closeBtn.backgroundColor = [UIColor blueColor];
    [closeBtn setTitle:@"关闭设备" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBlue) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:openBtn];
    [self.view addSubview:closeBtn];
    
    UIButton * MaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    MaskBtn.frame = CGRectMake(kScreenWidth/2 - 130, kMaxY(closeBtn.frame) + 50, 120, 40);
    MaskBtn.backgroundColor = [UIColor blueColor];
    [MaskBtn setTitle:@"查看当前状态" forState:UIControlStateNormal];
    [MaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MaskBtn addTarget:self action:@selector(lookMask) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * BetteryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BetteryBtn.frame = CGRectMake(kScreenWidth/2 + 10, kMaxY(closeBtn.frame) + 50, 120, 40);
    BetteryBtn.backgroundColor = [UIColor blueColor];
    [BetteryBtn setTitle:@"查看当前电量" forState:UIControlStateNormal];
    [BetteryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BetteryBtn addTarget:self action:@selector(lookBettery) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:MaskBtn];
    [self.view addSubview:BetteryBtn];
}

#pragma mark - 开启设备
/**
 *  开启设备
 */
- (void)openBlue{
    ETK * blue = [ETK shareBLEManager];
    
    [blue openBlue];
    [blue BlueStrength:@"10"];
}
#pragma mark - 关闭设备
/**
 *  关闭设备
 */
- (void)closeBlue{
    ETK * blue = [ETK shareBLEManager];
    
    [blue  closeBlue];
}

#pragma mark - 查看蓝牙设备状态
/**
 *  查看蓝牙设备状态
 */
- (void)lookMask{
    ETK * blue = [ETK shareBLEManager];
    
    [blue FacialMask];
}
#pragma mark - 查看蓝牙电池电量
/**
 *  查看蓝牙电池电量
 */
- (void)lookBettery{
    ETK * blue = [ETK shareBLEManager];
    
    [blue blueBettery];
}

- (void)leftEvent{
    ETK * blue = [ETK shareBLEManager];
    [blue.centralManager cancelPeripheralConnection:blue.peripheral];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
