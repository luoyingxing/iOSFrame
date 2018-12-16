//
//  ViewController.m
//  iOSFrame
//
//  Created by 罗映星 on 2018/10/30.
//  Copyright © 2018 罗映星. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    label.text = @"post request";
    [self.view addSubview:label];
    
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [label addGestureRecognizer:labelTapGestureRecognizer];
    
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
//    [self post];
    [self postClick];
}

-(void)post{
    //对请求路径的说明
    //http://download.jingyun.cn/api/get-last-version?model=cn0903&level=alpha
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://download.jingyun.cn/api/get-last-version"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"model=cn0903&level=alpha" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@", dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}

/* POST 请求 */
-(void)postClick{
    // http://116.204.67.11:17001/stream/read
    // tid=COWN-3B1-UY-4WS&chid=1&from=2018-12-07 16:31:15&to=2018-12-07 16:31:35
    NSString *urlStr = [NSString stringWithFormat:@"http://116.204.67.11:17001/stream/read"];
    //转码
    // stringByAddingPercentEscapesUsingEncoding 只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号), ios9将淘汰
    // ios9 以后要换成 stringByAddingPercentEncodingWithAllowedCharacters 这个方法进行转码
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //创建请求对象
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString* body = [@"tid=COWN-3B1-UY-4WS&chid=1&from=2018-12-07 16:31:15&to=2018-12-07 16:31:35" stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //根据会话对象创建一个 Task（发送请求）
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            //8.解析数据
            // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            // NSLog(@"%@",dict);
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"POST 加载的内容是：%@", str);
        }else{
            NSLog(@"请求发生错误：%@", [error description]);
        }
    }];
    [dataTask resume]; //执行任务
}

@end
