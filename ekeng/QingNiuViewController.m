//
//  ViewController.m
//  SDKTest
//
//  Created by pengyunfei on 15/12/22.
//  Copyright © 2015年 qingniu. All rights reserved.
//

#define kScreenBounds [UIScreen mainScreen].bounds

#import "QingNiuViewController.h"
#import "QingNiuSDK.h"
#import "QingNiuDevice.h"
#import "QingNiuUser.h"
#import <BRPickerView.h>
#import "BRTextField.h"
#import "NSDate+BRAdd.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface QingNiuViewController ()<UITableViewDelegate,UITableViewDataSource>


    @property (nonatomic, strong)  UIView *headView;
    @property (nonatomic, strong)  BRTextField *idTextField;
    @property (nonatomic, strong)  BRTextField *heightTextField;
//    @property (nonatomic, strong)  UIButton *maleButton;
//    @property (nonatomic, strong)  UIButton *femaleButton;
    @property (nonatomic, strong)  BRTextField *gender;
    @property (nonatomic, strong)  BRTextField *birthdayTextField;
//    UITextField *_idTextField;
    
    @property (nonatomic, strong)  UIButton *scanButton;
    
    @property (nonatomic, strong)  NSMutableArray *allScanDevice;
    @property (nonatomic, strong)  NSMutableArray *deviceData;
    @property (nonatomic, strong)  UITableView *tableView;
    @property (nonatomic, strong)  UITableView *headTableView;
    @property (nonatomic, strong) NSArray *titleArr;

    @property (nonatomic)  BOOL *scanFlag;
    @property (nonatomic, strong)  NSString *userid;//用户唯一ID
    @property (nonatomic, strong)  NSString *deviceType;//监测设备种类0 血糖 1 血压

@end



@implementation QingNiuViewController

-(void)updateName:(NSString*)userid{
    _userid = [userid copy];
}
-(void)updateDeviceType:(NSString*)deviceType{
    _deviceType = [deviceType copy];
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    [self initSubviews];
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    _allScanDevice = [NSMutableArray array];
    _deviceData = [NSMutableArray array];
    
    [self addHeadViews];
    
    [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //一般来说如果该ViewController是测量界面，那么在该方法里面就调用扫描方法
    [self scanBle:_scanButton];
}

#pragma mark 添加头部views
- (void)addHeadViews
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenBounds.size.width, 280)];
    [self.view addSubview:_headView];
    
    CGFloat subViewsHeight = 60;
//    UILabel *idLabel = [self createLabelWithFrame:CGRectMake(0, 0, 20, subViewsHeight) andTitle:@"id:" onView:_headView];
//    _idTextField = [self createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(idLabel.frame), CGRectGetMinY(idLabel.frame), 60, subViewsHeight) andText:_userid onSuperView:_headView];
    

//    _idTextField = [YJJTextField yjj_textField];
//    _idTextField.frame = CGRectMake(0, 0, self.view.frame.size.width, subViewsHeight);
//    _idTextField.maxLength = 11;
//    _idTextField.errorStr = @"*字数长度不得超过11位";
//    _idTextField.placeholder = @"请输入手机号";
//    _idTextField.historyContentKey =_userid;
//
//   // self.idTextField = _idTextField;
//    [_headView addSubview:_idTextField];
//
//
//
//
//
//    _heightTextField = [YJJTextField yjj_textField];
//    _heightTextField.frame = CGRectMake(0, 60, self.view.frame.size.width, subViewsHeight);
//    _heightTextField.maxLength = 3;
//    _heightTextField.errorStr = @"长度不得超过3位";
//    _heightTextField.placeholder = @"请输入身高";
//
//    [_headView addSubview:_heightTextField];
//
//    UILabel *genderLabel = [self createLabelWithFrame:CGRectMake(0, 120, 40, subViewsHeight) andTitle:@"性别:" onView:_headView];
//    _maleButton = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(genderLabel.frame), CGRectGetMinY(genderLabel.frame) + 5, 40, 20) andTitle:@"男" andSelector:@selector(chooseGender:) onSuperView:_headView];
//    _maleButton.tag = 3;
//
//    _femaleButton = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(_maleButton.frame), CGRectGetMinY(_maleButton.frame), 40, 20) andTitle:@"女" andSelector:@selector(chooseGender:) onSuperView:_headView];
//    _femaleButton.tag = 4;
//
//    [self chooseGender:_maleButton];
//
//
//
//    _birthdayTextField = [YJJTextField yjj_textField];
//    _birthdayTextField.frame = CGRectMake(0, 180, self.view.frame.size.width, subViewsHeight);
//    _birthdayTextField.maxLength = 3;
//    _birthdayTextField.errorStr = @"长度不得超过3位";
//    _birthdayTextField.placeholder = @"请输入生日";
//    [_headView addSubview:_birthdayTextField];
    
    
//    UILabel *heightLabel = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(_idTextField.frame) + 10, CGRectGetMinY(_idTextField.frame), 40, subViewsHeight) andTitle:@"身高:" onView:_headView];
//    _heightTextField = [self createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(heightLabel.frame), CGRectGetMinY(heightLabel.frame), 60, subViewsHeight) andText:@"176" onSuperView:_headView];
    
 
    
//    UILabel *birthdayLabel = [self createLabelWithFrame:CGRectMake(0, 240, 40, subViewsHeight) andTitle:@"生日:" onView:_headView];
//    _birthdayTextField = [self createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(birthdayLabel.frame), CGRectGetMinY(birthdayLabel.frame), 120, subViewsHeight) andText:@"1992-01-10" onSuperView:_headView];
//
    
    if (!_headTableView) {
        _headTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210) style:UITableViewStylePlain];
        _headTableView.backgroundColor = [UIColor whiteColor];
        _headTableView.dataSource = self;
        _headTableView.delegate = self;
        _headTableView.tableFooterView = [[UIView alloc]init];
        [_headView addSubview:_headTableView];
    }
    
    CGFloat scanButtonWidth = 80;
    _scanButton = [self createButtonWithFrame:CGRectMake(self.view.frame.size.width/2-40,240, scanButtonWidth, subViewsHeight) andTitle:@"开始扫描" andSelector:@selector(scanBle:) onSuperView:_headView];
    //_scanButton.tag = 1;
}


//- (void)chooseGender:(UIButton *)button
//{
//    button.backgroundColor = [UIColor lightGrayColor];
//    if (button.tag == 3) {
//        _femaleButton.backgroundColor = [UIColor whiteColor];
//        _gender = @"1";
//    }else {
//        _maleButton.backgroundColor = [UIColor whiteColor];
//        _gender = @"0";
//    }
//}

- (void)initSubviews
{
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarStyleBlack target:self action:@selector(scanBle:)];
    leftButton.tag=2;
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索设备"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(scanBle:)];
    
    rightButton.tag=201;
    //设置导航栏内容
   
        [navigationItem setTitle:@"体脂称"];
    
    
    
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
   
}

#pragma mark 添加tableView
- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), kScreenBounds.size.width, kScreenBounds.size.height - CGRectGetMaxY(_headView.frame) - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark 扫描
- (void)scanBle:(UIButton *)button
{
    if (button.tag == 1) {
        NSLog(@"开始扫描");
        [button setTitle:@"停止扫描" forState:UIControlStateNormal];
        button.tag = 2;
        [QingNiuSDK startBleScan:nil scanSuccessBlock:^(QingNiuDevice *qingNiuDevice) {
            NSLog(@"qingNiuDevice：%@",qingNiuDevice);
            if (_allScanDevice.count == 0) {
                [_allScanDevice insertObject:qingNiuDevice atIndex:0];
            }else {
                for (int i = 0; i<_allScanDevice.count; i++) {
                    QingNiuDevice *savedDevice = _allScanDevice[i];
                    if ([savedDevice.macAddress isEqualToString:qingNiuDevice.macAddress]) {
                        break;
                    }else if (i == _allScanDevice.count - 1){
                        [_allScanDevice insertObject:qingNiuDevice atIndex:0];
                        break;
                    }
                }
            }
            _scanFlag = YES;
            [_tableView reloadData];
        } scanFailBlock:^(QingNiuScanDeviceFail qingNiuScanDeviceFail) {
            NSLog(@"scanfail：%ld",(long)qingNiuScanDeviceFail);
            if (qingNiuScanDeviceFail == QingNiuScanDeviceFailValidationFailure) {
                [QingNiuSDK registerApp:@"123456789" andReleaseModeFlag:NO registerAppBlock:^(QingNiuRegisterAppState qingNiuRegisterAppState) {
                    NSLog(@"register result：%ld",(long)qingNiuRegisterAppState);
                }];
            }
        }];
    }else if(button.tag == 2){
        [QingNiuSDK stopBleScan];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {//申明：在实际开发过程当中，如果扫描到设备就连接的话，停止扫描方法可不调用，因为连接方法会停止扫描
        [button setTitle:@"开始扫描" forState:UIControlStateNormal];
        button.tag = 1;
        [QingNiuSDK stopBleScan];
        NSLog(@"停止扫描");
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        if (_scanFlag) {
            return _allScanDevice.count;
        }else {
            //NSLog(_deviceData);
            return 0;
        }
    }else{
         //NSLog(@"titleArr %d",self.titleArr.count);
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        if (_scanFlag) {
            static NSString *deviceCell = @"DeviceCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:deviceCell];
            }
            QingNiuDevice *qingNiuDevice = _allScanDevice[indexPath.row];
            cell.textLabel.text = qingNiuDevice.name;
            cell.detailTextLabel.text = qingNiuDevice.macAddress;
            return cell;
        } else {
            static NSString *deviceDataCell = @"DeviceDataCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceDataCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:deviceDataCell];
            }
            NSDictionary *oneIndex = _deviceData[indexPath.row];
            cell.textLabel.text = oneIndex[@"name"];
            cell.detailTextLabel.text = [oneIndex[@"value"] stringByAppendingString:oneIndex[@"unit"]];
            return cell;
        }
    }else {
        static NSString *cellID = @"testCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        //cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
        NSString *title = [self.titleArr objectAtIndex:indexPath.row];
        if ([title hasPrefix:@"* "]) {
            NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:title];
            [textStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[[textStr string]rangeOfString:@"* "]];
            cell.textLabel.attributedText = textStr;
        } else {
            cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self setupNameTF:cell];
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupGenderTF:cell];
            }
                break;
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupBirthdayTF:cell];
            }
                break;
//            case 3:
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [self setupBirthtimeTF:cell];
//            }
//                break;
//            case 4:
//            {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                [self setupPhoneTF:cell];
//            }
//                break;
//            case 5:
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [self setupAddressTF:cell];
//            }
//                break;
//            case 6:
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [self setupEducationTF:cell];
//            }
//                break;
//            case 7:
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [self setupOtherTF:cell];
//            }
//                break;
                
            default:
                break;
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
#pragma mark 点击其中一行开始连接
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_scanFlag) {
        QingNiuDevice *qingNiuDevice = _allScanDevice[indexPath.row];
        QingNiuUser *user = [[QingNiuUser alloc] init];
        user.userId = _idTextField.text;
        user.height = [_heightTextField.text intValue];
        user.gender = [_gender intValue];
        user.birthday = _birthdayTextField.text;
        [QingNiuSDK connectDevice:qingNiuDevice user:user connectSuccessBlock:^(NSMutableDictionary *deviceData, QingNiuDeviceConnectState qingNiuDeviceConnectState) {
            if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateConnectedSuccess) {
                [self scanBle:_scanButton];
                NSLog(@"连接成功%@",deviceData);
            }
            else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsWeighting) {
                NSLog(@"实时体重：%@",deviceData[@"weight"]);
            }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateWeightOver){
                NSLog(@"测量完毕：%@",deviceData);
            }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsGettingSavedData){
                NSLog(@"正在获取存储数据：%@",deviceData);
            }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateGetSavedDataOver){
                NSLog(@"存储数据接收完毕：%@",deviceData);
            }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateDisConnected) {
                /*
                 1、如果用户需要连续测量，那么就在这里开启一个定时器启动扫描，该方法是在轻牛app里面采用的方式
                 [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanBleAgain) userInfo:nil repeats:NO];
                 2、如果确保qingNiuDevice对象没有改变，那么可以直接调用connectDevice:方法
                 */
                NSLog(@"自动断开连接%@",deviceData);
            }
            if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsWeighting || qingNiuDeviceConnectState == QingNiuDeviceConnectStateWeightOver || qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsGettingSavedData) {
                [self getShowDeviceData:deviceData];
                _scanFlag = NO;
                [_tableView reloadData];
            }
        } connectFailBlock:^(QingNiuDeviceConnectState qingNiuDeviceConnectState) {
            NSLog(@"connectState:%ld",(long)qingNiuDeviceConnectState);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"连接失败" message:[NSString stringWithFormat:@"%@%ld",@"错误码：",(long)qingNiuDeviceConnectState] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }];
    }
}

- (NSMutableArray *)getShowDeviceData:(NSDictionary *)deviceData
{
    [_deviceData removeAllObjects];
    if (deviceData[@"weight"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"体重",@"name",deviceData[@"weight"],@"value",@"kg",@"unit", nil]];
    }
    if (deviceData[@"bmi"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"bmi",@"name",deviceData[@"bmi"],@"value",@"",@"unit", nil]];
    }
    if (deviceData[@"bodyfat"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"脂肪率",@"name",deviceData[@"bodyfat"],@"value",@"%",@"unit", nil]];
    }
    if (deviceData[@"subfat"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"皮下脂肪率",@"name",deviceData[@"subfat"],@"value",@"%",@"unit", nil]];
    }
    if (deviceData[@"visfat"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"内脏脂肪等级",@"name",deviceData[@"visfat"],@"value",@"",@"unit", nil]];
    }
    if (deviceData[@"water"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"体水分",@"name",deviceData[@"water"],@"value",@"%",@"unit", nil]];
    }
    if (deviceData[@"bmr"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"基础代谢量",@"name",deviceData[@"bmr"],@"value",@"kcal",@"unit", nil]];
    }
    if (deviceData[@"muscle"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"骨骼肌率",@"name",deviceData[@"muscle"],@"value",@"%",@"unit", nil]];
    }
    if (deviceData[@"bone"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"骨量",@"name",deviceData[@"bone"],@"value",@"kg",@"unit", nil]];
    }
    if (deviceData[@"protein"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"蛋白质",@"name",deviceData[@"protein"],@"value",@"%",@"unit", nil]];
    }
    if (deviceData[@"bodyage"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"体年龄",@"name",deviceData[@"bodyage"],@"value",@"岁",@"unit", nil]];
    }
    if (deviceData[@"sinew"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"肌肉量",@"name",deviceData[@"sinew"],@"value",@"kg",@"unit", nil]];
    }
    if (deviceData[@"fat_free_weight"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"去脂体重",@"name",deviceData[@"fat_free_weight"],@"value",@"kg",@"unit", nil]];
    }
    if (deviceData[@"body_shape"] != nil) {
        [_deviceData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"体型",@"name",[self getBodyShapeDescriptionWithBodyShape:deviceData[@"body_shape"]],@"value",@"",@"unit", nil]];
    }
    return _deviceData;
}

- (NSString *)getBodyShapeDescriptionWithBodyShape:(NSString *)bodyShape
{
    NSString *bodyShapeDescription = @"";
    if ([bodyShape intValue] == 1) {
        bodyShapeDescription = @"隐形肥胖型";
    }else if ([bodyShape intValue] == 2) {
        bodyShapeDescription = @"运动不足型";
    }else if ([bodyShape intValue] == 3) {
        bodyShapeDescription = @"偏瘦型";
    }else if ([bodyShape intValue] == 4) {
        bodyShapeDescription = @"标准型";
    }else if ([bodyShape intValue] == 5) {
        bodyShapeDescription = @"偏瘦肌肉型";
    }else if ([bodyShape intValue] == 6) {
        bodyShapeDescription = @"肥胖型";
    }else if ([bodyShape intValue] == 7) {
        bodyShapeDescription = @"偏胖型";
    }else if ([bodyShape intValue] == 8) {
        bodyShapeDescription = @"标准肌肉型";
    }else if ([bodyShape intValue] == 9) {
        bodyShapeDescription = @"非常肌肉型";
    }
    return bodyShapeDescription;
}

#pragma mark 再次扫描秤
- (void)scanBleAgain
{
    [self scanBle:_scanButton];
}

#pragma mark 创建Label
- (UILabel *)createLabelWithFrame:(CGRect)frame andTitle:(NSString *)title onView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return label;
}

#pragma mark 创建button
- (UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andSelector:(SEL)selectorName onSuperView:(UIView *)superView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:selectorName forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    return button;
}

#pragma mark 创建textField
- (UITextField *)createTextFieldWithFrame:(CGRect)frame andText:(NSString *)text onSuperView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor clearColor];
    textField.text = text;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [superView addSubview:textField];
    return textField;
}

#pragma mark 切换用户登录的时候，请调用该方法清除缓存(在轻牛app里面是不需要调用该方法的，因为切换用户会清楚所有数据)
- (void)clearCache
{
    [QingNiuSDK clearCache];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
 轻牛app不调用该方法，直接等自动断开，除非工程中有中断连接的需求才调用该方法
 */
#pragma mark 断开连接
- (void)disconnect
{
    //_qingNiuDevice：连接的设备
//    [QingNiuSDK cancelConnect:_qingNiuDevice disconnectFailBlock:^(QingNiuDeviceDisconnectState qingNiuDeviceDisconnectState) {
//        NSLog(@"%ld",(long)qingNiuDeviceDisconnectState);
//    } disconnectSuccessBlock:^(QingNiuDeviceDisconnectState qingNiuDeviceDisconnectState) {
//        NSLog(@"%ld",(long)qingNiuDeviceDisconnectState);
//    }];
}


- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth - 230, 0, 200, 50)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    //textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}

#pragma mark - 姓名 textField
- (void)setupNameTF:(UITableViewCell *)cell {
    if (!_idTextField) {
        _idTextField = [self getTextField:cell];
        _idTextField.placeholder = @"请输入";
        _idTextField.returnKeyType = UIReturnKeyDone;
        _idTextField.tag = 0;
    }
}

#pragma mark - 性别 textField
- (void)setupGenderTF:(UITableViewCell *)cell {
    if (!_gender) {
        _gender = [self getTextField:cell];
        _gender.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _gender.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.gender.text = selectValue;
            }];
        };
    }
}

#pragma mark - 出生日期 textField
- (void)setupBirthdayTF:(UITableViewCell *)cell {
    if (!_birthdayTextField) {
        _birthdayTextField = [self getTextField:cell];
        _birthdayTextField.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _birthdayTextField.tapAcitonBlock = ^{
            [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.birthdayTextField.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.birthdayTextField.text = selectValue;
            }];
        };
    }
}

#pragma mark - 出生时刻 textField
//- (void)setupBirthtimeTF:(UITableViewCell *)cell {
//    if (!_birthtimeTF) {
//        _birthtimeTF = [self getTextField:cell];
//        _birthtimeTF.placeholder = @"请选择";
//        __weak typeof(self) weakSelf = self;
//        _birthtimeTF.tapAcitonBlock = ^{
//            [BRDatePickerView showDatePickerWithTitle:@"出生时刻" dateType:UIDatePickerModeTime defaultSelValue:weakSelf.birthtimeTF.text minDateStr:@"" maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
//                weakSelf.birthtimeTF.text = selectValue;
//            }];
//        };
//    }
//}

#pragma mark - 联系方式 textField
//- (void)setupPhoneTF:(UITableViewCell *)cell {
//    if (!_phoneTF) {
//        _phoneTF = [self getTextField:cell];
//        _phoneTF.placeholder = @"请输入";
//        _phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        _phoneTF.returnKeyType = UIReturnKeyDone;
//        _phoneTF.tag = 4;
//    }
//}

#pragma mark - 地址 textField
//- (void)setupAddressTF:(UITableViewCell *)cell {
//    if (!_addressTF) {
//        _addressTF = [self getTextField:cell];
//        _addressTF.placeholder = @"请选择";
//        __weak typeof(self) weakSelf = self;
//        _addressTF.tapAcitonBlock = ^{
//            [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
//                weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
//            }];
//        };
//    }
//}

#pragma mark - 学历 textField
- (void)setupHeightTF:(UITableViewCell *)cell {
    if (!_heightTextField) {
        _heightTextField = [self getTextField:cell];
        _heightTextField.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _heightTextField.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"120", @"121", @"122", @"123", @"124", @"125",@"126", @"127", @"128", @"129", @"130", @"131",@"132", @"133", @"134", @"135", @"136", @"137",@"138", @"139", @"140", @"141", @"142", @"143",@"144", @"145", @"146", @"123", @"124", @"125",@"120", @"121", @"122", @"123", @"124", @"125",@"120", @"121", @"122", @"123", @"124", @"125",@"120", @"121", @"122", @"123", @"124", @"125"] defaultSelValue:@"170" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.heightTextField.text = selectValue;
            }];
        };
    }
}

#pragma mark - 其它 textField
//- (void)setupOtherTF:(UITableViewCell *)cell {
//    if (!_otherTF) {
//        _otherTF = [self getTextField:cell];
//        _otherTF.placeholder = @"请选择";
//        __weak typeof(self) weakSelf = self;
//        _otherTF.tapAcitonBlock = ^{
//            NSArray *dataSources = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
//            [BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSources defaultSelValue:@[@"第3周", @"第3天"] isAutoSelect:YES resultBlock:^(id selectValue) {
//                weakSelf.otherTF.text = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
//            }];
//        };
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"* 姓名", @"* 性别", @"* 出生年月"];
    }
    return _titleArr;
}

@end
