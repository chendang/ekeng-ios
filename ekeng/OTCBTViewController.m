//
//  ViewController.m
//  OTCBT
//
//  Created by 张玉龙0 on 2017/9/20.
//  Copyright © 2017年 zyl. All rights reserved.
//

#import "OTCBTViewController.h"
#import "GraphicView.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AFNetworking.h>
#import "PCNetworkManager.h"
#import "PNChart.h"
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define Device_4_0 @"OTC-GLU"
#define Device_4_1 @"0TC-GLU"
#define Device_3_0 @"BGM-3.0"
#define Device_P_3_0 @"BPM-3.0"//血压计

@interface OTCBTViewController ()
<CBCentralManagerDelegate, CBPeripheralDelegate, //蓝牙代理协议
UITableViewDelegate, UITableViewDataSource // 表视图代理协议和数据源协议
>

@property (nonatomic,retain) NSString *userid;
@property (nonatomic,retain) NSString *deviceType;
@property (nonatomic, strong) CBCentralManager *cMgr; // 中心管理者
@property (nonatomic, strong) CBPeripheral *peripheral; // 连接到的外设
@property (nonatomic, strong) CBCharacteristic *characteristic; // 服务特征
@property (strong, nonatomic) PNLineChart *lineChart;
//@property (nonatomic, strong) ZBNetworking *httpMgr;// 网络管理者
@property (strong, nonatomic)  NSString *_temp ;//因为会重复读取三遍数据 临时增加此方法
@end

@implementation OTCBTViewController
{
    NSMutableArray *_perArr; // 蓝牙设备列表
    UITableView *_tableView; // 蓝牙设备表视图
    UIView *_backView; // 蓝牙设备表视图背景视图
    NSString *_userid;//用户唯一ID
    NSString *_deviceType;//监测设备种类0 血糖 1 血压
    NSMutableArray *_tipArr; // 提示信息
    UITableView *_tipTable; // 信息展示表视图
    
    NSMutableArray *_pointArr; // 测试数据点
    GraphicView *_gView; // 数据记录视图
    
    BOOL hadShow; // 检测到蓝牙未开启提醒用户一次
    
}
@synthesize userid=_userid,deviceType=_deviceType;
-(void)updateName:(NSString*)userid{
    _userid = [userid copy];
}
-(void)updateDeviceType:(NSString*)deviceType{
    _deviceType = [deviceType copy];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"传入的ID值：%@,设备类型值：%@", _userid,_deviceType);
    _gView = [self graphicView];
    
    //PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    //[lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
   
    _lineChart = [self initLineChartViewWithData];
    [self.view addSubview:_lineChart];
//    [self.view addSubview:_gView];
//    _perArr = [NSMutableArray array];
    _perArr = [[NSMutableArray alloc] init];
//    _tipArr = [NSMutableArray array];
    _tipArr = [[NSMutableArray alloc] init];
//    _pointArr = [NSMutableArray array];
    _pointArr = [[NSMutableArray alloc] init];
    [self initSubviews];
    _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

- (void)initSubviews
{
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarStyleBlack target:self action:@selector(buttonAction:)];
    leftButton.tag=203;
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索设备"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(buttonAction:)];
    
    rightButton.tag=201;
    //设置导航栏内容
    if([_deviceType isEqualToString:@"0"]){
        [navigationItem setTitle:@"血糖"];
    }else if ([_deviceType isEqualToString:@"1"]){
         [navigationItem setTitle:@"血压"];
    }
    
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    //把左右两个按钮添加入导航栏集合中
    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setRightBarButtonItem:rightButton];
    
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
    
    //释放对象
    [navigationItem release];
    [leftButton release];
    [rightButton release];
    
    
    
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(20, 330, 85, 40);
//    [button setTitle:@"搜索设备" forState:UIControlStateNormal];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 5;
//    button.layer.borderWidth = 1;
//    button.layer.borderColor = [[UIColor colorWithWhite:.9 alpha:1] CGColor];
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    button.tag = 201;
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button2.frame = CGRectMake(kScreenWidth - 20 - 85, 330, 85, 40);
//    [button2 setTitle:@"断开连接" forState:UIControlStateNormal];
//    button2.layer.masksToBounds = YES;
//    button2.layer.cornerRadius = 5;
//    button2.layer.borderWidth = 1;
//    button2.layer.borderColor = [[UIColor colorWithWhite:.9 alpha:1] CGColor];
//    button2.backgroundColor = [UIColor whiteColor];
//    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:button2];
//    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    button2.tag = 202;
//
//    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button3.frame = CGRectMake(100, 330, 85, 40);
//    [button3 setTitle:@"返回" forState:UIControlStateNormal];
//    button3.layer.masksToBounds = YES;
//    button3.layer.cornerRadius = 5;
//    button3.layer.borderWidth = 1;
//    button3.layer.borderColor = [[UIColor colorWithWhite:.9 alpha:1] CGColor];
//    button3.backgroundColor = [UIColor whiteColor];
//    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:button3];
//    [button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    button3.tag = 203;
    
    
    [self showTipView];
    [self showBackView];
}

- (void)showTipView
{
//    CGFloat y = 330 + 40 + 5+50;
    CGFloat y = 250 + 44 + 20+20;
    _tipTable = [[UITableView alloc] initWithFrame:CGRectMake(20, y, kScreenWidth - 40, kScreenHeight - y - 5 ) style:UITableViewStylePlain];
    _tipTable.delegate = self;
    _tipTable.dataSource = self;
    _tipTable.layer.borderWidth = 1;
    _tipTable.layer.borderColor = [[UIColor colorWithWhite:.7 alpha:1] CGColor];
    [self.view addSubview:_tipTable];
    
    [_tipArr insertObject:@"请打开设备开始测量..." atIndex:0];
    [_tipTable reloadData];
}

- (void)showBackView
{
    _backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backView];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, kScreenHeight - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.dataSource = self;
    [_backView addSubview:_tableView];
}

- (void)hideBackView
{
    [_backView removeFromSuperview];
}

- (GraphicView *)graphicView{
    CGFloat width = self.view.frame.size.width;
    GraphicView *view = [[GraphicView alloc] initWithFrame:CGRectMake(0, 64, width, 260)];
    view.xTitle = @"n";
    view.yTitle = @"血糖(mmol/L)";
    view.yArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    view.xArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    return view;
}

- (PNLineChart *)initLineChartViewWithData{
    //初始化
//    _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 250.0)];
    _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(5, 70, SCREEN_WIDTH-10, 250.0)];
    //设置背景颜色
    _lineChart.backgroundColor = [UIColor clearColor];
//    _lineChart.backgroundColor = [UIColor blueColor];
    //设置坐标轴是否可见
    _lineChart.showCoordinateAxis = YES;
    //设置是否显示网格线
    _lineChart.showYGridLines = YES;
    //设置网格线颜色
    _lineChart.yGridLinesColor = [UIColor grayColor];
    
    [self refreshChartData];
    //设置是否显示图例
    _lineChart.hasLegend = YES;
    //设置图例样式
    _lineChart.legendStyle = PNLegendItemStyleSerial;
    //设置图例位置
    //    _lineChart.legendPosition = PNLegendPositionLeft;
    
    _lineChart.legendStyle = PNLegendItemStyleSerial;
    //    _lineChart.legendFont =;
    UIView *legend = [_lineChart getLegendWithMaxWidth:320];
    legend.frame = CGRectMake(5, 330, legend.bounds.size.width, legend.bounds.size.height);
    [self.view addSubview:legend];
     return _lineChart;
}

-(void)refreshChartData{
    //血氧 血压数据分开解析
    NSDictionary *params = @{
                             @"userid" : _userid,
                             @"devicetype" : _deviceType,
                             @"count" :@"7"
                             };

      
        [[PCNetworkManager defaultManager] sendRequestMethod:(HTTPMethodGET) serverUrl:@"http://healthapi.ekeng.com.cn" apiPath:@"/api/HItemRecord/getIosRecord" parameters:params progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
            NSLog(@"get success:%@",responseObject);
            //        NSLog(@"response code:%@",[responseObject objectForKey:@"ReturnCode"]);
            //        NSLog(@"response msg2:%@",[[responseObject objectForKey:@"ReturnMessage"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            //设置X轴标签
            NSMutableArray *xLabels = [[NSMutableArray alloc] init];
            
            if([_deviceType isEqualToString:@"0"]){
                //设置血糖数据折线
                //曲线数据
                PNLineChartData *gludata = [PNLineChartData new];
                //数据点颜色
                gludata.color = PNRed;
                //数据点格式
                gludata.inflexionPointStyle = PNLineChartPointStyleCircle;
                
                //设置数据标注名称
                gludata.dataTitle = @"周收入";
                NSMutableArray *gludataArray = [[NSMutableArray alloc] init];
                //        NSArray *highdataArray = @[@1,@9,@6,@3,@8,@7,@4];
                NSArray * GLUdata =[responseObject objectForKey:@"gludata"];
                if([GLUdata count]>0){
                    for(NSDictionary *obj in GLUdata)
                    {
                        [gludataArray addObject:[obj objectForKey:@"value"]];
                        [xLabels addObject:[obj objectForKey:@"CreateTime"]];
                        
                    }
                    gludata.itemCount = gludataArray.count;
                    gludata.getData = ^(NSUInteger index){
                        CGFloat yValue = [gludataArray[index] floatValue];
                        return [ PNLineChartDataItem dataItemWithY:yValue];
                    };
                    _lineChart.chartData = @[gludata];
                }
                
            }else if([_deviceType isEqualToString:@"1"]){
                //设置高压数据折线
                //曲线数据
                PNLineChartData *highdata = [PNLineChartData new];
                //数据点颜色
                highdata.color = PNRed;
                //数据点格式
                highdata.inflexionPointStyle = PNLineChartPointStyleCircle;
                
                //设置数据标注名称
                highdata.dataTitle = @"高压";
                NSMutableArray *highdataArray = [[NSMutableArray alloc] init];
                //        NSArray *highdataArray = @[@1,@9,@6,@3,@8,@7,@4];
                NSArray * BPHighdata =[responseObject objectForKey:@"BPHighdata"];
                 if([BPHighdata count]>0){
                    for(NSDictionary *obj in BPHighdata)
                    {
                        [highdataArray addObject:[obj objectForKey:@"value"]];
                        [xLabels addObject:[obj objectForKey:@"CreateTime"]];
                        
                    }
                    highdata.itemCount = highdataArray.count;
                    highdata.getData = ^(NSUInteger index){
                        CGFloat yValue = [highdataArray[index] floatValue];
                        return [ PNLineChartDataItem dataItemWithY:yValue];
                    };
                }
                
                
                
                
                //设置低压数据折线
                //曲线数据
                PNLineChartData *lowdata = [PNLineChartData new];
                //数据点颜色
                lowdata.color = PNGreen;
                //数据点格式
                lowdata.inflexionPointStyle = PNLineChartPointStyleCircle;
                
                //设置数据标注名称
                lowdata.dataTitle = @"低压";
                NSMutableArray *lowdataArray = [[NSMutableArray alloc] init];
                //        NSArray *highdataArray = @[@1,@9,@6,@3,@8,@7,@4];
                
                
                NSArray * BPLowdata =[responseObject objectForKey:@"BPLowdata"];
                if([BPLowdata count]>0){
                    for(NSDictionary *obj in BPLowdata)
                    {
                        [lowdataArray addObject:[obj objectForKey:@"value"]];
                    }
                    lowdata.itemCount = lowdataArray.count;
                    lowdata.getData = ^(NSUInteger index){
                        CGFloat yValue = [lowdataArray[index] floatValue];
                        return [ PNLineChartDataItem dataItemWithY:yValue];
                    };
                }
                
                
                //设置心率数据折线
                //曲线数据
                PNLineChartData *prdata = [PNLineChartData new];
                //数据点颜色
                prdata.color = PNBlue;
                //数据点格式
                prdata.inflexionPointStyle = PNLineChartPointStyleCircle;
                
                //设置数据标注名称
                prdata.dataTitle = @"心率";
                NSMutableArray *prdataArray = [[NSMutableArray alloc] init];
                //        NSArray *highdataArray = @[@1,@9,@6,@3,@8,@7,@4];
                
                
                NSArray * BPPRdata =[responseObject objectForKey:@"BPPRdata"];
                if([BPPRdata count]>0){
                    for(NSDictionary *obj in BPPRdata)
                    {
                        [prdataArray addObject:[obj objectForKey:@"value"]];
                    }
                    prdata.itemCount = prdataArray.count;
                    prdata.getData = ^(NSUInteger index){
                        CGFloat yValue = [prdataArray[index] floatValue];
                        return [ PNLineChartDataItem dataItemWithY:yValue];
                    };
                }
                
                _lineChart.chartData = @[highdata,lowdata,prdata];
            }
            
            
            
            [self.lineChart setXLabels:xLabels];
            
            
            [_lineChart strokeChart];
            
        } failure:^(NSString * _Nullable errorMessage) {
            NSLog(@"post failure:%@",errorMessage);
        }];
   
    
    
    
    
}
- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 102) { // 关闭
        [self.cMgr stopScan];
        [self hideBackView];
        return;
    } else if (button.tag == 101) { // 搜索
        [_perArr removeAllObjects];
        [_tableView reloadData];
        [_perArr addObject:@"正在搜索..."];
        [button setTitle:@"重新搜索" forState:UIControlStateNormal];
         [_tableView reloadData];
        [self.cMgr stopScan];
        [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                          options:nil];
    } else if (button.tag == 201) { // 搜索设备
        [_perArr removeAllObjects];
        [self showBackView];
        [self.cMgr stopScan];
        [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                          options:nil];
    } else if (button.tag == 202) { // 断开连接
        if (self.peripheral) {
            [_cMgr cancelPeripheralConnection:self.peripheral];
            self.peripheral = nil;
        }
    } else if (button.tag == 203) { // 返回
        if (self.peripheral) {
            [_cMgr cancelPeripheralConnection:self.peripheral];
            self.peripheral = nil;
        }
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

// 检测蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
            if (!hadShow) {
                hadShow = YES;
                [self showOpenBluetoothAlert];
            }
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            hadShow = YES;
            // 在中心管理者成功开启后再进行一些操作
            // 搜索外设
            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
        }
            break;
        default:
            break;
    }
}

// 蓝牙未开启，提示用户开启
- (void)showOpenBluetoothAlert
{
    UIAlertController *ctr = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙未开启，请开启蓝牙" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:NO];

    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不开启" style:UIAlertActionStyleCancel handler:nil];
    [ctr addAction:doAction];
//    [ctr addAction:cancelAction];
    [self presentViewController:ctr animated:YES completion:nil];
}

// 发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    /*
     4.0 name: OTC-GLU
     3.0 name: BGM-3.0
     
     */
    NSLog(@"搜索到的设备%@  mac = %@" ,peripheral.name,peripheral.identifier.UUIDString);
    if([_deviceType isEqualToString:@"0"]){
        if ([peripheral.name isEqualToString:Device_4_0] || [peripheral.name isEqualToString:Device_3_0] || [peripheral.name isEqualToString:Device_4_1]) {
            
            // 将血糖仪加入设备列表，用户手动选择连接
            [_perArr addObject:peripheral];
            [_tableView reloadData];
        }
    }
    if([_deviceType isEqualToString:@"1"]){
        if ([peripheral.name isEqualToString:Device_P_3_0] ) {
            
            // 将血糖仪加入设备列表，用户手动选择连接
            [_perArr addObject:peripheral];
            [_tableView reloadData];
        }
    }
    
}

// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    NSString *str = [NSString stringWithFormat:@"设备 %@ 已连接.", peripheral.name];
    [_tipArr insertObject:str atIndex:0];
    if([_deviceType isEqualToString:@"0"]){
        str = @"请将试纸插入卡槽...";
    }else if([_deviceType isEqualToString:@"1"]){
        str = @"请开始测量...";
    }
    
    [_tipArr insertObject:str atIndex:0];
    [_tipTable reloadData];
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    self.peripheral.delegate = self;
    
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:nil];
}
// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
    NSString *str = [NSString stringWithFormat:@"设备 %@ 已断开连接", peripheral.name];
    [_tipArr insertObject:str atIndex:0];
    [_tipTable reloadData];
}

//返回的蓝牙服务通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService * service in peripheral.services) {
        NSLog(@"Service found with UUID :%@",service.UUID);
        NSString * _Nullable extractedExpr = peripheral.name;
        if ([peripheral.name isEqualToString:Device_3_0]) {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]]) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        } else if ([extractedExpr isEqualToString:Device_4_0]) {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]] || [service.UUID isEqual:[CBUUID UUIDWithString:@"FFF3"]]) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }else if ([extractedExpr isEqualToString:Device_P_3_0]) {
            NSLog(@"CBUUID :%@",[CBUUID UUIDWithString:@"FFF0"]);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]] || [service.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}
//查找到该设备所对应的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    //每个peripheral都有很多服务service（这个依据蓝牙而定），每个服务都会有几个特征characteristic，区分这些就是UUID
    //这里可以利用开头说的LightBlue软件连接蓝牙看看你的蓝牙硬件有什么服务和每个服务所包含的特征，然后根据你的协议里面看看你需要用到哪个特征的哪个服务
    NSLog(@"%@", service.characteristics);
    for (CBCharacteristic * characteristic in service.characteristics) {
        
        //所对应的属性用于接收和发送数据
        if ([peripheral.name isEqualToString:Device_3_0]) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];//监听这个服务发来的数据
                [peripheral readValueForCharacteristic:characteristic];//主动去读取这个服务发来的数据
            }
        } else if ([peripheral.name isEqualToString:Device_4_0]) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) { // service.UUID: FFF0
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];//监听这个服务发来的数据
                [peripheral readValueForCharacteristic:characteristic];//主动去读取这个服务发来的数据
            }
        }else if ([peripheral.name isEqualToString:Device_P_3_0]) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) { // service.UUID: FFF0
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];//监听这个服务发来的数据
                [peripheral readValueForCharacteristic:characteristic];//主动去读取这个服务发来的数据
            }
        }
    }
}
//接收数据的函数.处理蓝牙发过来得数据   读数据代理，这里已经收到了蓝牙发来的数据
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSDateFormatter *dateformmater=[[NSDateFormatter alloc] init];
    [dateformmater setDateStyle:NSDateFormatterShortStyle];
    [dateformmater setDateFormat:@"YYYY-MM-DD HH:mm"];
    NSString *date=[dateformmater stringFromDate:[NSDate date]];
    
    
    
    
    //这里区分血压 血糖
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
         NSLog(@"%@", characteristic.value);
        NSString * string = [self hexadecimalString:characteristic.value];
        NSLog(@"%s, line 1= %d, %@", __FUNCTION__, __LINE__, string);
        //血氧
        if([_deviceType isEqualToString:@"0"]){
//            if ([string rangeOfString:@"88cks"].location != NSNotFound) {
            if ([string hasPrefix:@"fe6a755a"] && [string rangeOfString:@"88"].location != NSNotFound) {
                NSString *str = [string substringWithRange:NSMakeRange(10, 2)];
                str = [self to10:str];
                CGFloat n = [str floatValue];
                n = n/18;
                str = [NSString stringWithFormat:@"%.1f", n];
                [_pointArr insertObject:str atIndex:0];
                [_gView rushUpWithArray:_pointArr];
                NSString *tStr = [NSString stringWithFormat:@"%@ mmol/L", str];
                [_tipArr insertObject:tStr atIndex:0];
                
                //post 数据到服务端
                NSDictionary *onerecord = @{
                                             @"iType" : @"GLU",
                                             @"value1" : str,
                                             @"idesc" : @"血氧",
                                             };
                NSDictionary *params = @{
                                          @"UserName" : _userid,
                                          @"CreateTime" : date,
                                          @"data" :onerecord
                                          };
                NSString *url= @"http://healthapi.ekeng.com.cn";
                NSLog(@"post url:%@",url);
                NSLog(@"post data:%@",params);
                [[PCNetworkManager defaultManager] sendRequestMethod:(HTTPMethodPOST) serverUrl:url apiPath:@"/device/api/OtcPushData" parameters:params progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
                    NSLog(@"post success:%@",responseObject);
                    NSLog(@"response code:%@",[responseObject objectForKey:@"ReturnCode"]);
                    NSLog(@"response msg2:%@",[[responseObject objectForKey:@"ReturnMessage"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                } failure:^(NSString * _Nullable errorMessage) {
                    NSLog(@"post failure:%@",errorMessage);
                }];
            } else {
                // FE 6A75 5A 55 AABB CC
                if (![string isEqualToString:@"fe6a755a55aabbcc"]) {
                    [_tipArr insertObject:string atIndex:0];
                }
            }
            [_tipTable reloadData];
        }
        //血压
        if([_deviceType isEqualToString:@"1"]){
           
            //显示结果 "fe6a735a"
//            NSLog(@"%@", _temp);
            if([string hasPrefix:@"fe6a735a"] && ![self._temp isEqualToString:string]){
                self._temp = string;
                //高压  hi
                NSString *hi = [string substringWithRange:NSMakeRange(10, 2)];
                hi = [self to10:hi];
                //低压  lo
                NSString *lo = [string substringWithRange:NSMakeRange(12, 2)];
                lo = [self to10:lo];
                //心率 pr
                NSString *pr = [string substringWithRange:NSMakeRange(14, 2)];
                pr = [self to10:pr];
                NSLog(@"读取血压计数据 高压 %@mmHg ,低压 %@mmHg,心率 %@次/分钟",hi,lo,pr);
                NSString *tStr = [NSString stringWithFormat:@"高压 %@mmHg ,低压 %@mmHg,心率 %@次/分钟", hi,lo,pr];
                [_tipArr insertObject:tStr atIndex:0];
                [_tipTable reloadData];
                
                //post 数据到服务端
                NSDictionary *onerecord1 = @{
                                            @"iType" : @"BPHigh",
                                            @"value1" : hi,
                                            @"idesc" : @"高压",
                                            };
                NSDictionary *onerecord2 = @{
                                            @"iType" : @"BPLow",
                                            @"value1" : lo,
                                            @"idesc" : @"低压",
                                            };
                NSDictionary *onerecord3 = @{
                                            @"iType" : @"BPPR",
                                            @"value1" : pr,
                                            @"idesc" : @"心率",
                                            };
                
                NSDictionary *params1 = @{
                                         @"UserName" : _userid,
                                         @"CreateTime" : date,
                                         @"data" :onerecord1
                                         };
                NSDictionary *params2 = @{
                                          @"UserName" : _userid,
                                          @"CreateTime" : date,
                                          @"data" :onerecord2
                                          };
                NSDictionary *params3 = @{
                                          @"UserName" : _userid,
                                          @"CreateTime" : date,
                                          @"data" :onerecord3
                                          };
                
                NSString *url= @"http://healthapi.ekeng.com.cn";
                NSLog(@"post url:%@",url);
                NSLog(@"post data:%@",params1);
                [[PCNetworkManager defaultManager] sendRequestMethod:(HTTPMethodPOST) serverUrl:url apiPath:@"/device/api/OtcPushData" parameters:params1 progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
                    NSLog(@"post success:%@",responseObject);
                    NSLog(@"response code:%@",[responseObject objectForKey:@"ReturnCode"]);
                    NSLog(@"response msg2:%@",[[responseObject objectForKey:@"ReturnMessage"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                } failure:^(NSString * _Nullable errorMessage) {
                    NSLog(@"post failure:%@",errorMessage);
                }];
                NSLog(@"post data:%@",params2);
                [[PCNetworkManager defaultManager] sendRequestMethod:(HTTPMethodPOST) serverUrl:url apiPath:@"/device/api/OtcPushData" parameters:params2 progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
                    NSLog(@"post success:%@",responseObject);
                    NSLog(@"response code:%@",[responseObject objectForKey:@"ReturnCode"]);
                    NSLog(@"response msg2:%@",[[responseObject objectForKey:@"ReturnMessage"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                } failure:^(NSString * _Nullable errorMessage) {
                    NSLog(@"post failure:%@",errorMessage);
                }];
                NSLog(@"post data:%@",params3);
                [[PCNetworkManager defaultManager] sendRequestMethod:(HTTPMethodPOST) serverUrl:url apiPath:@"/device/api/OtcPushData" parameters:params3 progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
                    NSLog(@"post success:%@",responseObject);
                    NSLog(@"response code:%@",[responseObject objectForKey:@"ReturnCode"]);
                    NSLog(@"response msg2:%@",[[responseObject objectForKey:@"ReturnMessage"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                    [self refreshChartData];
                   
                } failure:^(NSString * _Nullable errorMessage) {
                    NSLog(@"post failure:%@",errorMessage);
                }];
                
                
            }
        }
        
        
        
        //在这里解析收到的数据，一般是data类型的数据，这里要根据蓝牙厂商提供的协议进行解析并且配合LightBlue来查看数据结构，我当时收到的数据是十六进制的数据但是是data类型，所以我先讲data解析出来之后转为十进制来使用。具体方法后面我会贴出
        //还有一点收到数据后有的硬件是需要应答的，如果应答的话就是在这里再给蓝牙发一个指令（写数据）：“我收到发的东西了，你那边要做什么操作可以做了”。
    }
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//转换成十进制
- (NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}

#pragma mark tableView delegate and dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tipTable) {
        return _tipArr.count;
    }
    return _perArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tipTable) {
        static NSString *identifier = @"tipCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *str = _tipArr[indexPath.row];
        cell.textLabel.text = [self tipString:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CBPeripheral *peripheral = _perArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self transDeviceName:peripheral.name]];
    //cell.textLabel.text = peripheral.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tipTable) {
        return;
    }
    CBPeripheral *peripheral = _perArr[indexPath.row];
    self.peripheral = peripheral;
    [_cMgr connectPeripheral:self.peripheral options:nil];
    [self hideBackView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tipTable) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5, 85, 40);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = 101;
    
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(kScreenWidth - 40 - 85 - 5, 5, 85, 40);
    [cBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cBtn];
    [cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cBtn.tag = 102;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tipTable) {
        return 0;
    }
    return 50;
}

- (NSString *)tipString:(NSString *)tipStr
{
    if ([tipStr isEqualToString:@"fe6a755a55aabbcc"]) {
        return @"请将试纸插入卡槽...";
    } else if ([tipStr isEqualToString:@"fe6a755a55bbbbcc"]) {
        return @"请滴血进行测试...";
    } else if ([tipStr isEqualToString:@"fe6a755a5505bb05"]) {
        return @"请稍候 5s...";
    } else if ([tipStr isEqualToString:@"fe6a755a5504bb04"]) {
        return @"请稍候 4s...";
    } else if ([tipStr isEqualToString:@"fe6a755a5503bb03"]) {
        return @"请稍候 3s...";
    } else if ([tipStr isEqualToString:@"fe6a755a5502bb02"]) {
        return @"请稍候 2s...";
    } else if ([tipStr isEqualToString:@"fe6a755a5501bb01"]) {
        return @"请稍候 1s...";
    }
    return tipStr;
}
- (NSString *)transDeviceName:(NSString *)str
{
    if ([str isEqualToString:@"OTC-GLU"]) {
        return @"血糖仪OTC-GLU";
    } else if ([str isEqualToString:@"0TC-GLU"]) {
        return @"血糖仪0TC-GLU";
    } else if ([str isEqualToString:@"BGM-3.0"]) {
        return @"血糖仪BGM-3.0";
    } else if ([str isEqualToString:@"BPM-3.0"]) {
        return @"血压计BPM-3.0";
    }
    return str;
}

@end

