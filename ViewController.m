//
//  ViewController.m
//  JPV
//
//  Created by FreshWater on 16/9/8.
//  Copyright © 2016年 FreshWater. All rights reserved.
//

#import "ViewController.h"
#import "HttpRequestHelper.h"
#import "JVCPlayer.h"
#import "JVCNetSDK.h"
#import "JVCYSTPlayer.h"
#import "YSTViewController.h"
#import "MBProgressHUD.h"
@interface ViewController (){
    NSString *streamToken;
    NSString *mp4File;
    
    NSString *playUrlStr;// 直播地址
    
}

@end

#define MBALERT(alertMsg)         UIWindow *window=[[UIApplication sharedApplication].windows lastObject]; \
MBProgressHUD *ahud=[MBProgressHUD showHUDAddedTo:window animated:YES];\
ahud.userInteractionEnabled = NO;\
ahud.mode = MBProgressHUDModeText;\
ahud.labelText = alertMsg;\
[ahud hide:YES afterDelay:1];

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self rtmpTest];
    
}


- (void)rtmpTest
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    [[JVCNetSDK shareJVCNetSDK] initNetSdk:9200 logPath:docDir];
    
    
    //rtmp://119.188.172.4:1935/live/b175907696_1 车店
    //rtmp://119.188.172.3:1935/live/b82952331_1  超市
    //rtmp://119.188.172.3:1935/live/s322306536_1  大街
    
    UIButton *stop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [stop setFrame:CGRectMake(0, 100, 100, 50)];
    
    [stop setTitle:@"停止" forState:UIControlStateNormal];
    
    [stop addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: stop];
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [start setFrame:CGRectMake(self.view.frame.size.width - 100, 100, 100, 50)];
    
    [start setTitle:@"视频直播" forState:UIControlStateNormal];
    
    [start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: start];
    
   
    
    UIButton *playback = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [playback setFrame:CGRectMake(130, 150, 80, 40)];
    
    [playback setTitle:@"回放" forState:UIControlStateNormal];
    
    [playback addTarget:self action:@selector(playback) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: playback];

    
    
    
    
    
    UIButton *file = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    
    
    [file setFrame:CGRectMake(130, 100, 100, 40)];
    
    [file setTitle:@"文件列表" forState:UIControlStateNormal];
    
    [file addTarget:self action:@selector(fileList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: file];
    

    
    
    
    
    
    
    
    
    
    UIButton *devic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [devic setFrame:CGRectMake(130, 50, 100, 40)];
    
    [devic setTitle:@"设备列表" forState:UIControlStateNormal];
    
    [devic addTarget:self action:@selector(devicList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: devic];
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [backBtn setFrame:CGRectMake(0, 22, 80, 50)];
    
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: backBtn];

    
    
    
    UIButton *getUrlBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [getUrlBtn setFrame:CGRectMake(self.view.frame.size.width - 100, 50, 100, 40)];
    
    [getUrlBtn setTitle:@"直播地址" forState:UIControlStateNormal];
    
    [getUrlBtn addTarget:self action:@selector(getPlayerUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: getUrlBtn];

    
    
    
}

// 获取设备列表
-(void)devicList{
    
    NSString *myString = [[NSUserDefaults standardUserDefaults] stringForKey:@"session"];
    
    
    NSDictionary *loginDict = [[NSDictionary alloc]initWithObjectsAndKeys:myString,@"session",nil];
    
    NSNumber *mid = [NSNumber numberWithInt:1];
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:mid,@"mid",@"get_points",@"method",loginDict,@"param",nil];
    
    NSLog(@"%@",postDict);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    
    
    [[HttpRequestHelper sharedInstance]requestWithURL:@"http://alarm-gw.jovision.com/netalarm-rs/storedata/get_points" parameters:jsonData success:^(id responseData) {
        
        
        
        NSDictionary *reDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"=====%@",reDict);
        
        
        if([[reDict objectForKey:@"rt"]integerValue] == 0) {
           
          
            MBALERT(@"获取设备成功");
            
        }else{
            
            MBALERT(@"获取设备失败");
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        MBALERT(@"获取设备失败");

    }];
    

    
}




-(void)getPlayerUrl{
    
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:@"SP55623757",@"devId",@"0" , @"channelid",@"nvr",@"devType",@"video",@"type",[NSNumber numberWithInt:0],@"streamid",@"live",@"videoType",@"",@"file",[[NSUserDefaults standardUserDefaults]objectForKey:@"session"],@"session",nil];
    
    NSNumber *mid = [NSNumber numberWithInt:1];
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:mid,@"mid",@"palyvideo",@"method",param,@"param",nil];
    
    NSLog(@"%@",postDict);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    
  
    [[HttpRequestHelper sharedInstance] requestWithURL:@"http://alarm-gw.jovision.com/netalarm-rs/videoplay/playvideo" parameters:jsonData success:^(id responseData) {
        
        NSDictionary *reDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",reDict);
        if ([[reDict objectForKey:@"rt"]integerValue] == 0){
            
          
            playUrlStr = reDict[@"param"][@"url"];
            
            
            MBALERT(@"获取直播地址成功");
            
        }else{
            MBALERT(@"获取失败");
        }
        
        
        
        
        
        
        
        NSLog(@"成功");
        
    } failure:^(NSError *error) {
        
        NSLog(@"失败");
        
    }];
    

    
}





-(IBAction)start:(id)sender
{
    
    if (playUrlStr.length == 0) {
        MBALERT(@"请先获取直播地址");
        return;
    }
    
    MBALERT(@"开始直播");
    
  UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.width / 4 * 3)];
    [self.view addSubview:playView];
    
    [JVCPlayer shareJVCPlayer].jvcPlayerStatusDelegate = (id)self;
    [[JVCPlayer shareJVCPlayer] JVCPlayerStart:0 showView:playView withRTMPUrl:playUrlStr];
    
    // 测试用到的直播地址 @"rtmp://58.56.111.12:1935/live/B311119585_0_0?token=G5XZ2Y18dOqMdGc17IuGLIkYpojFlDFBTqYlgvbuxuhsZ3"
    
}


-(IBAction)stop:(id)sender
{
    [[JVCPlayer shareJVCPlayer] JVCPlayerStop];
    
    MBALERT(@"停止");
    
}


/**
 *  连接状态回调
 *
 *  @param status <#status description#>
 */
-(void)JVCPlayerStatusCallBack:(int)status
{
    NSLog(@"status ======= %d", status);
}

/**
 *  deviceReady回调
 *
 *  @param deviceReady <#deviceReady description#>
 */
-(void)JVCPlayerRecordReadyCallBack:(NSString *)deviceReady
{
    NSLog(@"deviceReady ======= %@", deviceReady);
    //收到后通过命令通道发送开始命令
    
}



// 文件列表
-(void)fileList{
    
    static int MID = 1;
    
    NSDictionary *param1 = @{@"channelid":[NSNumber numberWithInt:0],@"starttime":[NSString stringWithFormat:@"%@000000",@"20160908"],@"endtime":[NSString stringWithFormat:@"%@235959",@"20160908"]};
    
    NSDictionary *param2 = @{@"method":@"get_record_list",@"param":param1};
    
    NSNumber *mid = [NSNumber numberWithInt:MID];
    
    MID ++;
    
    NSDictionary *param = @{@"session":[[NSUserDefaults standardUserDefaults] objectForKey:@"session"],@"devId":@"SP55623757",@"req":[self dictionaryToJson:param2]};
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:mid,@"mid",@"push_to_device",@"method",param,@"param",nil];
    
    NSLog(@"%@",postDict);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [[HttpRequestHelper sharedInstance]requestWithURL:@"http://alarm-gw.jovision.com/netalarm-rs/push/push_to_device" parameters:jsonData success:^(id responseData) {
        
        
        
        NSDictionary *reDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"=====%@",reDict);
        
        
        if([[reDict objectForKey:@"rt"]integerValue] == 0) {
           
            MBALERT(@"获取文件成功");

            
            // json格式的字符串转字典
            NSData *jsonData = [reDict[@"param"][@"res"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"%@",dic);

            // demo演示只获取列表的首个元素
            
            NSLog(@"%@",dic[@"result"][@"recordlist"][0][@"filename"]);
            
            NSMutableString *muString =[NSMutableString stringWithString:dic[@"result"][@"recordlist"][0][@"filename"]];
            
            [muString insertString:@"20160908/" atIndex:3];
            
            NSLog(@"%@",muString);
            
            mp4File = [NSString stringWithFormat:@"%@%@",muString,@".mp4"];
            
            NSLog(@"%@",mp4File);
        }else{
            MBALERT(@"获取文件失败");

        }
        
        
        
    }
   failure:^(NSError *error) {
       
       MBALERT(@"获取文件失败");

    }];
    
        
        
    

}

// 回放
-(void)playback{
    
    // ******参数file传mp4File，这里只是做测试，MP4文件写了死值
    NSDictionary *param = [[NSDictionary alloc]initWithObjectsAndKeys:@"SP55623757",@"devId",@"0" , @"channelid",@"nvr",@"devType",@"video",@"type",[NSNumber numberWithInt:0],@"streamid",@"record",@"videoType",@"00/20160908/N01120446.mp4",@"file",[[NSUserDefaults standardUserDefaults]objectForKey:@"session"],@"session",nil];
    
    NSNumber *mid = [NSNumber numberWithInt:1];
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:mid,@"mid",@"palyvideo",@"method",param,@"param",nil];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    [[HttpRequestHelper sharedInstance]requestWithURL:@"http://alarm-gw.jovision.com/netalarm-rs/videoplay/playvideo" parameters:jsonData success:^(id responseData) {
        
        
        
        NSDictionary *reDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"=====%@",reDict);
        
        
        if([[reDict objectForKey:@"rt"]integerValue] == 0) {
            
         streamToken =  reDict[@"param"][@"streamToken"];
            
            // play_record
            [self playrecord];
            
            UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.width / 4 * 3)];
            [self.view addSubview:playView];

            [JVCPlayer shareJVCPlayer].jvcPlayerStatusDelegate = (id)self;
            [[JVCPlayer shareJVCPlayer] JVCPlayerStart:0 showView:playView withRTMPUrl:reDict[@"param"][@"url"]];
            
        }
        
    }
    failure:^(NSError *error) {
                                                  
            }];
    

    
}


// 命令通道（回放的时候先要走一下命令通道才能播放）
-(void)playrecord{
    
    static int MID = 1;


    NSDictionary *param1 = [[NSDictionary alloc] initWithObjectsAndKeys:streamToken,@"session",[NSNumber numberWithInt:0],@"status",[NSNumber numberWithInt:0],@"speed",[NSNumber numberWithInt:-1],@"frame", nil];
    
    NSDictionary *param2 = @{@"method":@"play_record",@"param":param1};
    
    NSNumber *mid = [NSNumber numberWithInt:MID];
    
    MID ++;
    
    NSDictionary *param = @{@"session":[[NSUserDefaults standardUserDefaults] objectForKey:@"session"],@"devId":@"SP55623757",@"req":[self dictionaryToJson:param2]};
    
    NSDictionary *postDict = [[NSDictionary alloc]initWithObjectsAndKeys:mid,@"mid",@"push_to_device",@"method",param,@"param",nil];
    
    NSLog(@"%@",postDict);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];
    
  ;
    
    
   
    [[HttpRequestHelper sharedInstance] requestWithURL:@"http://alarm-gw.jovision.com/netalarm-rs/push/push_to_device" parameters:jsonData success:^(id responseData) {
        
        NSDictionary *reDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",reDict);
        
        
        if([[reDict objectForKey:@"rt"]integerValue] == 0) {

            MBALERT(@"开始回放");
        }
        
        
        if([[reDict objectForKey:@"rt"]integerValue] == -500011) {
            
            MBALERT(@"设备响应异常");
        }

        
    } failure:^(NSError *error) {
        
        NSLog(@"失败");
    }];

}

// 返回

-(void)backclick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
