//
//  ViewController.m
//  Blue 蓝牙
//
//  Created by 吾诺翰卓 on 2018/1/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import "ViewController.h"

#import "BlueFunctionVC.h"
#import "ETK.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    BOOL connect;
}
@property (nonatomic, strong) ETK * YiTieKang;
@property (nonatomic, strong) UITableView * homeTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation ViewController

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NavigationHeight, kScreenWidth, kScreenHeight - k_NavigationHeight) style:UITableViewStyleGrouped];
        _homeTableView.backgroundColor = HOME_COLOR;
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO; 
        
    }
    return _homeTableView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self rightEvent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nav];
    [self.view addSubview:self.homeTableView];
    connect = NO; 
}

- (void)nav{
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k_NavigationHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(60, k_NavigationHeight - 44, kScreenWidth - 120, 44)];
    title.text = @"搜索蓝牙";
    title.font = [UIFont boldSystemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kScreenWidth - 60, k_NavigationHeight - 44, 60, 44);
    [rightBtn setImage:[UIImage imageNamed:@"ic_blue_refresh"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:title];
    [navView addSubview:rightBtn];
    
    [self.view addSubview:navView];
}

- (void)searchBlue{
    _YiTieKang = [ETK shareBLEManager];
    _YiTieKang.searchTime = 15;
    
    //当前手机蓝牙状态
    _YiTieKang.blueState = ^(id object) {
        NSInteger index = [object integerValue];
        switch (index) {
            case 1:
                NSLog(@"蓝牙已开启");
                break;
            case -1:
                NSLog(@"请开启蓝牙");
                break;
            default:
                NSLog(@"蓝牙发生未知错误");
                break;
        }
    };
    //所搜索到的蓝牙设备信息
    _YiTieKang.blueInfo = ^(id object) {
        NSDictionary * diction = object;
        if (self.dataArray.count == 0) {
            [self.dataArray addObject:diction];
        } else{
            for (int i = 0 ; i < self.dataArray.count; i++) {
                NSString * name = [self.dataArray[i][@"peripheral"] name];
                if ([name isEqualToString: [diction[@"peripheral"] name]]) {
                    break;
                }
                if (i == self.dataArray.count - 1) {
                    [self.dataArray addObject:diction];
                }
            }
        }
        [self.homeTableView reloadData];
    };
    //蓝牙设备搜索完毕
    _YiTieKang.blueSearchEnd = ^(id object) {
        NSLog(@"蓝牙搜索完毕");
    };
    //蓝牙设备连接情况
    _YiTieKang.blueContentState = ^(id object) {
        NSInteger index = [object integerValue];
        switch (index) {
            case 1:
                NSLog(@"蓝牙连接成功");
                break;
            case 2:
                NSLog(@"蓝牙获到取特征");
                break;
            case -1:
                NSLog(@"蓝牙连接失败");
                break;
            case -2:
                NSLog(@"蓝牙中途断开连接");
                break;
            default:
                break;
        }
    };
    //蓝牙设备连接成功， 以获取到蓝牙设备名称 + 自己获取用户 id + 蓝牙连接时间（时间可后台生成） 发送给后台
    _YiTieKang.blueSuccess = ^(id object) {
        NSLog(@"蓝牙%@连接成功", object);
        connect = YES;
        BlueFunctionVC * vc = [[BlueFunctionVC alloc] init];
        
        vc.blueduan = ^(NSInteger state) {
            connect = NO;
        };
        [self presentViewController:vc animated:YES completion:nil];
    };
}

- (void)rightEvent{
    [ETK deallocBLE];
    connect = NO;
    self.dataArray = [NSMutableArray array];
    [self searchBlue];
    
    [self.homeTableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dict = self.dataArray[indexPath.row];
    
    cell.textLabel.text = [dict[@"peripheral"] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!connect) {
        NSDictionary * diction = self.dataArray[indexPath.row];
        ETK * blue = [ETK shareBLEManager];
        
        [blue contentBlue:diction[@"peripheral"]];
    } else{
        NSLog(@"正在连接中");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
