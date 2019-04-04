//
//  ViewController.m
//  Socket通信
//
//  Created by kys-5 on 16/11/25.
//  Copyright © 2016年 kys-5. All rights reserved.
//

#define ScreeenWidth [UIScreen mainScreen].bounds.size.width
#define ScreeenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"

#import "DVSwitch.h"

@interface ViewController ()<NSStreamDelegate,UITextFieldDelegate>{
    NSInputStream* _inputStream; //对应输入流
    NSOutputStream* _outputStream; //对应输出流
}

@property(nonatomic,strong)NSMutableArray* nodeDataArray;

@property(nonatomic,strong)NSMutableArray* buttonStatusArray;

//定义节点1的变量
//温度
@property(nonatomic,strong)NSString* nodeOneTemperature;
//环境湿度
@property(nonatomic,assign)NSString* nodeOneenvironmentHumidity;
//光照强度
@property(nonatomic,assign)NSString* nodeOneIntensity;
//土壤湿度
@property(nonatomic,assign)NSString* nodeOneSoilHumidity;

//定义节点2的变量
//温度
@property(nonatomic,strong)NSString* nodeTwoTemperature;
//环境湿度
@property(nonatomic,assign)NSString* nodeTwoenvironmentHumidity;
//光照强度
@property(nonatomic,assign)NSString* nodeTwoIntensity;
//土壤湿度
@property(nonatomic,assign)NSString* nodeTwoSoilHumidity;

//定义节点3的变量
//温度
@property(nonatomic,strong)NSString* nodeThreeTemperature;
//环境湿度
@property(nonatomic,assign)NSString* nodeThreeenvironmentHumidity;
//光照强度
@property(nonatomic,assign)NSString* nodeThreeIntensity;
//土壤湿度
@property(nonatomic,assign)NSString* nodeThreeSoilHumidity;
//命令指令字符串
@property(nonatomic,strong)NSString* sendInstructionString;
//总的字符串的长度
@property(nonatomic,strong)NSString* receiveString;

@property(nonatomic,strong)UIView* oneView;

@property(nonatomic,strong)UIView* twoView;

//计时器的数字
@property(nonatomic,assign)int timeString;

@property(nonatomic,strong)NSTimer* timer;

@property(nonatomic,assign)int onlyOne;

@end


@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //[self readData];
    self.title = @"等待连接";
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc]initWithTitle:@"连接设备" style:UIBarButtonItemStylePlain target:self action:@selector(connectToHost:)];
    
    
    self.navigationItem.rightBarButtonItem=barBtn1;
    
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:0.773 green:0.173 blue:0.153 alpha:1];
    
    self.oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreeenWidth, 305)];
    self.oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.oneView];
    
    self.twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 317, ScreeenWidth, 180)];
    self.twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.twoView];
    
    [self initTemperatureTheView];
    
    [self initWithEquipmentView];
    
    self.onlyOne = 0;
    
//   NSString* str = @"CON_a1_b1_c1_d1_e1_f1_g1_h1_CON_END_A12B12C12D12A22B22C22D22A32B32C32D32_DATA_END\r\n";
//    NSString* str1;
//    str1 = [str substringWithRange:NSMakeRange(36, 2)];
//    NSLog(@"%@",str1);
    
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 搭建温度视图
 */
-(void)initTemperatureTheView{
    
    UILabel* temperatureMonitor = [[UILabel alloc]initWithFrame:CGRectMake(60, 70, ScreeenWidth-120, 40)];
    temperatureMonitor.text = @"温室大棚监视区";
    temperatureMonitor.textAlignment = NSTextAlignmentCenter;
    [self.oneView addSubview:temperatureMonitor];
    //横线
    for (int i = 0; i < 6; i++) {
        
        
        UIView* lineiew = [[UIView alloc]initWithFrame:CGRectMake(2, 115 + 40*i, ScreeenWidth -4, 1)];
        lineiew.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [self.oneView addSubview:lineiew];
        
    }
    //竖线
    for (int i = 0; i < 5; i++) {
        UIView* lineiew = [[UIView alloc]initWithFrame:CGRectMake(2+(ScreeenWidth-4)*i/4, 115 , 1, 200)];
        lineiew.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [self.oneView addSubview:lineiew];
        
    }
    
    NSArray* nameArray = [[NSArray alloc]initWithObjects:@"环境温度",@"环境湿度",@"光照强度",@"土壤湿度",nil];
    NSArray* nodeArray = [[NSArray alloc]initWithObjects:@"节点一",@"节点二",@"节点三" ,nil];
    int k = 0;
    for (int i = 0; i < 4; i++) {
         //第一行null
        if (i != 0) {
            UILabel* nodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(2+(ScreeenWidth-4)*i/4, 115 ,(ScreeenWidth-4)/4, 40)];
            nodeLabel.text = nodeArray[i-1];
            nodeLabel.textAlignment = NSTextAlignmentCenter;
            nodeLabel.font = [UIFont systemFontOfSize:14];
            [self.oneView addSubview:nodeLabel];
            
            for (int j = 0; j < 4; j++){
                UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(2+(ScreeenWidth-4)*i/4, 155 + 40*(j), (ScreeenWidth-4)/4, 40)];
                dataLabel.textAlignment = NSTextAlignmentCenter;
                NSArray *symbolArray = [[NSArray alloc]initWithObjects:@"℃",@"%",@"lx",@"%",nil];
                if (_nodeDataArray[0] == NULL) {
                    
                }
                else{
                   NSString *dataString = [NSString stringWithFormat:@"%@ %@",_nodeDataArray[k++],symbolArray[j]];
                    dataLabel.text = dataString;
                    dataLabel.font = [UIFont systemFontOfSize:14];
                    [self.oneView addSubview:dataLabel];
                }
               
               
               
            }
        }
       
        
        for (int j = 0; j < 5; j++) {
            
            if (i == 0) {
               
                
                if (j==0) {
                    
                }
                //第一列
                else{
                UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 115 + 40*j,70, 40)];
                nameLabel.text = nameArray[j-1];
                nameLabel.textAlignment = NSTextAlignmentCenter;
                    nameLabel.font = [UIFont systemFontOfSize:14];
                [self.oneView addSubview:nameLabel];
                }
            
            }
            else{
            
            }
        
        
        
        }
    }

    
    
}


-(void)initWithEquipmentView{
    UILabel* equipmentControl = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, ScreeenWidth-200, 40)];
    equipmentControl.text = @"设备控制区";
    equipmentControl.textAlignment = NSTextAlignmentCenter;
    [self.twoView addSubview:equipmentControl];
    
//    UILabel* manualMode = [[UILabel alloc]initWithFrame:CGRectMake(ScreeenWidth-100, 340, 50, 20)];
//    manualMode.text = @"手动模式";
//    manualMode.textAlignment = NSTextAlignmentCenter;
//    manualMode.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:manualMode];
//    
//    UIImageView* radioImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreeenWidth-40, 340, 15, 15)];
//    radioImage.image = [UIImage imageNamed:@"radio_button_on_32px_555416_easyicon.net.png"];
//    [self.view addSubview:radioImage];
    
        //开关
    NSLog(@"%@",self.buttonStatusArray);
    
    NSArray* switchNameArray = [[NSArray alloc]initWithObjects:@"取暖",@"天窗",@"通风",@"侧窗",@"加湿",@"补光",@"抽水",@"遮阳",nil];
    for (int i = 0; i < 4; i++) {
        UILabel* oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + (ScreeenWidth - 20)*i/4, 60, (ScreeenWidth - 20)/4, 30)];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:14];
        oneLabel.text = switchNameArray[i];
        [self.twoView addSubview:oneLabel];
        
        DVSwitch *equipmentSwitch = [DVSwitch switchWithStringsArray:@[@"关", @"开"]];
        equipmentSwitch.frame = CGRectMake(5+80*i, 90, 70, 20);
        equipmentSwitch.sliderOffset = 2.0;
        equipmentSwitch.cornerRadius = 10;
        equipmentSwitch.font = [UIFont fontWithName:@"Baskerville-Italic" size:14];
        equipmentSwitch.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
        
        equipmentSwitch.sliderColor = [UIColor colorWithRed:55/255.0 green:87/255.0 blue:36/255.0 alpha:1.0];
        equipmentSwitch.tag = 100+i;
        NSInteger abcd = [self.buttonStatusArray[i] integerValue];
        if (abcd  == 0) {
            abcd = 1;
        }
        else{
            abcd = 0;
        }
        [equipmentSwitch forceSelectedIndex:abcd animated:NO];
        [self.twoView addSubview:equipmentSwitch];
        
        [equipmentSwitch setPressedHandler:^(NSUInteger index){
            switch (equipmentSwitch.tag) {
                case 100:
                    if (index==1) {
                        self.sendInstructionString= @"CON_1_0";
                    }
                    else{
                     self.sendInstructionString= @"CON_1_1";
                    }
                    break;
                case 101:
                    if (index==1) {
                        self.sendInstructionString= @"CON_2_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_2_1";
                    }
                    break;
                case 102:
                    if (index==1) {
                        self.sendInstructionString= @"CON_3_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_3_1";
                    }
                    break;
                case 103:
                    if (index==1) {
                        self.sendInstructionString= @"CON_4_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_4_1";
                    }
                    
                default:
                    break;
            }
            //聊天信息
            NSString* msgStr = [NSString stringWithFormat:@"%@",self.sendInstructionString];
            NSLog(@"%@",msgStr);
            
            //把str转换成NSData
            NSData* data = [msgStr dataUsingEncoding:NSUTF8StringEncoding];
            
            //刷新表格
            // [self reloadDataWithText:msgStr];
            
            [_outputStream write:data.bytes maxLength:data.length];
            
        }];

    }
    
    for (int i = 0; i < 4; i++) {
        UILabel* oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + (ScreeenWidth - 20)*i/4, 120, (ScreeenWidth - 20)/4, 30)];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:14];
        oneLabel.text = switchNameArray[i+4];
        [self.twoView addSubview:oneLabel];
        
        DVSwitch *equipmentSwitch = [DVSwitch switchWithStringsArray:@[@"关", @"开"]];
        equipmentSwitch.frame = CGRectMake(5+80*i, 150, 70, 20);
        equipmentSwitch.sliderOffset = 2.0;
        equipmentSwitch.cornerRadius = 10;
        equipmentSwitch.font = [UIFont fontWithName:@"Baskerville-Italic" size:14];
        equipmentSwitch.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1.0];
        equipmentSwitch.tag = 104+i;
        NSInteger abcd = [self.buttonStatusArray[i+4] integerValue];
        if (abcd  == 0) {
            abcd = 1;
        }
        else{
            abcd = 0;
        }
        [equipmentSwitch forceSelectedIndex:abcd animated:NO];
        equipmentSwitch.sliderColor = [UIColor colorWithRed:55/255.0 green:87/255.0 blue:36/255.0 alpha:1.0];
        [self.twoView addSubview:equipmentSwitch];
        
        [equipmentSwitch setPressedHandler:^(NSUInteger index){
            switch (equipmentSwitch.tag) {
                case 104:
                    if (index==1) {
                        self.sendInstructionString= @"CON_5_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_5_1";
                    }
                    break;
                case 105:
                    if (index==1) {
                        self.sendInstructionString= @"CON_6_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_6_1";
                    }
                    break;
                case 106:
                    if (index==1) {
                        self.sendInstructionString= @"CON_7_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_7_1";
                    }
                    break;
                case 107:
                    if (index==1) {
                        self.sendInstructionString= @"CON_8_0";
                    }
                    else{
                        self.sendInstructionString= @"CON_8_1";
                    }
                default:
                    break;
            }
        //聊天信息
        NSString* msgStr = [NSString stringWithFormat:@"%@",self.sendInstructionString];
        NSLog(@"%@",msgStr);
    
        //把str转换成NSData
        NSData* data = [msgStr dataUsingEncoding:NSUTF8StringEncoding];
    
        //刷新表格
       // [self reloadDataWithText:msgStr];
        
        [_outputStream write:data.bytes maxLength:data.length];
            //NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        }];
        
    }

    

}
-(NSString*)decimalToBinary:(uint16_t)tempId backLength:(int)length{
    NSString* binaryString = @"";
    while (tempId) {
        binaryString = [[NSString stringWithFormat:@"%d",tempId%2] stringByAppendingString:binaryString];
        if (tempId/2 < 1) {
            break;
        }
        tempId = tempId/2;
    }
    if (binaryString.length <= length) {
        NSMutableString* fillZero = [[NSMutableString alloc]init];
        for (int i = 0; i<length-binaryString.length; i++) {
            [fillZero appendString:@"0"];
        }
        binaryString = [fillZero stringByAppendingString:binaryString];
    }
    return binaryString;
}



-(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        NSLog(@"%hu",uc);
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 实现输入输出流的监听
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    
   
    
    NSLog(@"%@",[NSThread currentThread]);
    
//        NSStreamEventOpenCompleted = 1UL << 0,//输入输出流打开完成
//        NSStreamEventHasBytesAvailable = 1UL << 1,//有字节可读
//        NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发放字节
//        NSStreamEventErrorOccurred = 1UL << 3,// 连接出现错误
//        NSStreamEventEndEncountered = 1UL << 4// 连接结束
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");
            [self readData];
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");
            self.title = @"连接成功";
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"连接出现错误");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"连接结束");
            //关闭输入输出流
            [_inputStream close];
            [_outputStream close];
            
            //从主运行循环移除
            [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            
            [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            
            
            break;
            
        default:
            break;
    }
}

-(void)startTimer{
    
    self.timeString = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdDownTime) userInfo:nil repeats:YES];
}

-(void)countdDownTime{
    self.timeString--;
    if (self.timeString==0) {
        [self.timer invalidate];
        
        //请求表格的数据
        
        //self.sendInstructionString = @"READ_ALL_DATA";
        NSString* msgAllDataStr = [NSString stringWithFormat:@"%@",@"READ_ALL_DATA"];
        NSData* data = [msgAllDataStr dataUsingEncoding:NSUTF8StringEncoding];
        [_outputStream write:data.bytes maxLength:data.length];
       //开始计时
        [self startTimer];
    }
    
}


#pragma mark - 连接服务器

-(void)connectToHost:(id)sender {
    
    //建立连接
    NSString* host = @"192.168.4.1";
    int port = 8086;
    
    
//    NSString* host = @"172.18.74.5";
//    int port = 8086;
////

 
    //定义C语言输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    
    //把C语言的输入输出流转换成OC对象
    _inputStream = (__bridge NSInputStream*)(readStream);
    _outputStream = (__bridge NSOutputStream*)(writeStream);
    
    //设置代理
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
    // 把输入输入流添加到主运行循环
    // 不添加主运行循环 代理有可能不工作
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //打开输入输出流
    [_inputStream open];
    [_outputStream open];
    
    //请求表格的数据
  
    if (self.onlyOne == 0) {
        //self.sendInstructionString = @"READ_ALL_DATA";
        NSString* msgAllDataStr = [NSString stringWithFormat:@"%@",@"READ_ALL_DATA"];
        NSData* data = [msgAllDataStr dataUsingEncoding:NSUTF8StringEncoding];
        [_outputStream write:data.bytes maxLength:data.length];
        self.onlyOne = 1;
        
        //开始计时
        [self startTimer];
    }
    

}




#pragma mark - 读取了服务器返回的数据
-(void)readData{
   //建立一个缓冲区,可以放1024个字节
    uint8_t buf[1024];
    
    //返回实际装的字节数
    NSInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    
    //把字节数组转换成字符串
    NSData* data = [NSData dataWithBytes:buf length:len];
    
    //从服务器中接收的数据
    NSString* readStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",readStr);
    self.receiveString = readStr;
    
    if ([[self.receiveString substringWithRange:NSMakeRange(0,3)]isEqual:@"Wel"])
    {
        //NSLog(@"dddddd");
    }
    else{
       
        //self.receiveString = @"A11B12C13D14A25B26C27D28A39B310C311D312";
        if ([[self.receiveString substringWithRange:NSMakeRange(0,3)]isEqual:@"CON"]) {
            
            self.buttonStatusArray = [[NSMutableArray alloc]init];
            char status = 'a';
            for (int i = 0; i < 8; i++) {
                NSString* string1 = [NSString stringWithFormat:@"%c",status+i];
                
                if ([string1 isEqual:@"h"]) {
                    
                    NSRange range = NSMakeRange(26,1);
                    [self.buttonStatusArray addObject:[self.receiveString substringWithRange:range]];
                }
                else{
                    NSString* string1 = [NSString stringWithFormat:@"%c",status+i];
                    NSRange startRange  = [self.receiveString rangeOfString:string1];
                    NSString* string2 = [NSString stringWithFormat:@"_%c",status+1+i];
                    NSRange endRange = [self.receiveString rangeOfString:string2];
                    NSRange range = NSMakeRange(startRange.location+startRange.length, endRange.location-startRange.location-startRange.length);
                    [self.buttonStatusArray addObject:[self.receiveString substringWithRange:range]];
                }
                
            }
        }
        
        
        //zz
        if ([[self.receiveString substringWithRange:NSMakeRange(39, 2)] isEqual:@"A1"]) {
            
            self.nodeDataArray = [[NSMutableArray alloc]init];
            char alpha = 'A';
            for (int j = 0; j < 3; j++) {
                for (int i = 0; i < 4; i++) {
                    
                    NSString *string1 = [NSString stringWithFormat:@"%c%d",alpha+i,j+1];
                    NSRange startRange = [ self.receiveString rangeOfString:string1];
                    if (i==3) {
                        if (j==2) {
                            
                            NSRange startRange = [self.receiveString rangeOfString:@"D3"];
                            NSRange endRange = [self.receiveString rangeOfString:@"_DATA_END"];
                            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                            NSString *result = [self.receiveString substringWithRange:range];
                            NSLog(@"%@",result);
                            [self.nodeDataArray addObject:result];
                            break;
                        }
                        NSString *string2 = [NSString stringWithFormat:@"%c%d",alpha,j+2];
                        NSRange endRange = [ self.receiveString rangeOfString:string2];
                        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                        //NSLog(@"%@",[self.receiveString substringWithRange:range]);
                        [self.nodeDataArray addObject:[self.receiveString substringWithRange:range]];
                        break;
                    }
                    NSString *string2 = [NSString stringWithFormat:@"%c%d",alpha+i+1,j+1];
                    NSRange endRange = [self.receiveString rangeOfString:string2];
                    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                    //NSLog(@"%@",[self.receiveString substringWithRange:range]);
                    [self.nodeDataArray addObject:[self.receiveString substringWithRange:range]];
                    
                }
            }
        }
        //CON_a0_b1_c1_d1_e1_f1_g1_h1_CON_END_A12B12C12D12A22B22C22D22A32B32C3888D32_DATA_END\r\n
        NSLog(@"%@",_nodeDataArray);
        
        [self.oneView removeFromSuperview];
        [self.twoView removeFromSuperview];
        
        self.oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreeenWidth, 305)];
        self.oneView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.oneView];
        
        self.twoView = [[UIView alloc]initWithFrame:CGRectMake(0, 317, ScreeenWidth, 180)];
        self.twoView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.twoView];
        
        [self initTemperatureTheView];
        [self initWithEquipmentView];
        //    self.nodeOneTemperature = [ self.receiveString substringWithRange:range];
        //    NSLog(@"%@",self.nodeOneTemperature);
    }
   
}

//测试改变代码

@end
