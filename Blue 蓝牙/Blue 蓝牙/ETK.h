//
//  ETK.h
//  ETK
//
//  Created by 吾诺翰卓 on 2018/1/23.
//  Copyright © 2018年 吾诺翰卓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^blueAction)(id object);

@interface ETK : NSObject

@property (nonatomic, strong) CBCentralManager * centralManager;         //蓝牙管理
@property (nonatomic, strong) CBPeripheral     * peripheral;             //连接的设备信息
@property (nonatomic, strong) CBCharacteristic * writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic * readCharacteristic;
@property (nonatomic, strong) CBCharacteristic * characteristic;
/**
 *  搜索时间
 */
@property (nonatomic, assign) NSInteger searchTime;


/**
 *  蓝牙当前状态  1 开启    -1 关闭   -2 不支持  -3 未授权   -4 重置  -5 未知
 */
@property (nonatomic, strong)blueAction blueState;
/**
 *  所搜索到的蓝牙设备的信息
 */
@property (nonatomic, strong)blueAction blueInfo;
/**
 *  蓝牙搜索一定时间后结束 默认15s
 */
@property (nonatomic, strong)blueAction blueSearchEnd;
/**
 *   蓝牙设备连接状态   1-连接成功  2-成功获到取特征  -1-连接失败    -2-中途断开连接
 */
@property (nonatomic, strong)blueAction blueContentState;
/**
 *   蓝牙设备成功获取到服务和特征，可发送数据
 */
@property (nonatomic, strong)blueAction blueSuccess;
/**
 *  蓝牙设备设备是否开启  开启关闭设备时候返回
 */
@property (nonatomic, strong)void(^blueIsOpen)(BOOL state);
/**
 *  蓝牙设备设备当前电量百分比  电量不足或者查看电量是返回
 */
@property (nonatomic, strong)void(^blueNowBettery)(NSString * bettery);
/**
 *  蓝牙设备当前状态    查看蓝牙状态时候返回
 *  blueState: 蓝牙运行当前状态 01-蓝牙设备阶段1   02-蓝牙设备阶段2  03-蓝牙设备阶段3
 *  blueTime: 蓝牙运行时间（从开启到结束12分钟720s）
 *  blueStrength: 蓝牙运行当前强度
 */
@property (nonatomic, strong)void(^blueNowState)(NSString * blueState, NSString * blueTime, NSString * blueStrength);
/**
 *  蓝牙设备当前强度  增减强度成功时返回
 */
@property (nonatomic, strong)void(^blueNowStrength)(NSString * blueStrength);
/*---------------------------------------------*/
/**
 *  单例,开启蓝牙设备
 */
+ (instancetype)shareBLEManager;
/**
 *  重置蓝牙设备,可重新开启蓝牙设备
 */
+ (void)deallocBLE;
/**
 *  连接蓝牙设备
 */
- (void)contentBlue:(CBPeripheral *)peripheral;
/**
 *  开启蓝牙设备
 */
- (void)openBlue;
/**
 *  关闭蓝牙设备
 */
- (void)closeBlue;
/**
 *  查看蓝牙设备状态
 */
- (void)FacialMask;
/**
 *  查看蓝牙设备电池电量
 */
- (void)blueBettery;
/**
 *   蓝牙设备的强度调整
 */
- (void)BlueStrength:(NSString *)strength;

@end
