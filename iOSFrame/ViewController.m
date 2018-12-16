//
//  ViewController.m
//  iOSFrame
//
//  Created by 罗映星 on 2018/10/30.
//  Copyright © 2018 罗映星. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ViewController

-(NSMutableData *)responseData{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

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
    NSString* body = [@"from=2018-12-07 16:31:15&to=2018-12-07 16:31:35" stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^%*+,:;'\"`<>()[]{}/\\| "] invertedSet]];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://116.204.67.11:17001/stream/read?tid=COWN-3B1-UY-4WS&chid=1&%@", body];
    NSLog(@"request url: %@", urlStr);
    //转码
    // stringByAddingPercentEscapesUsingEncoding 只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号), ios9将淘汰
    // ios9 以后要换成 stringByAddingPercentEncodingWithAllowedCharacters 这个方法进行转码
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    //http://download.jingyun.cn/api/get-last-version?model=cn0903&level=alpha
    
    //创建会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
    /*
     第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     第二个参数：谁成为代理，此处为控制器本身即self
     第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    //创建请求对象
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
//    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"keep-Alive" forHTTPHeaderField:@"Connection"];
    
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

//1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //在该方法中可以得到响应头信息，即response
    NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     NSURLSessionResponseBecomeStream        变成一个流
     */
    
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData--%@",[NSThread currentThread]);
    
    //拼接服务器返回的数据
    [self.responseData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"didCompleteWithError--%@",[NSThread currentThread]);
    
    if(error == nil)
    {
        //解析数据,JSON解析请参考http://www.cnblogs.com/wendingding/p/3815303.html
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
        NSLog(@"%@",dict);
    }
}

#pragma mark- NSURLSessionDownloadDelegate

// 1、 下载完成后被调用的方法 IOS7&IOS8都必须实现的方法
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成");
}

// 2、 下载进度变化的时候被调用的。 IOS8可以不实现，但IOS7必须实现
/**
 bytesWritten: 本次写入的字节数
 totalBytesWritten：已经写入的字节数（目前下载的字节数）
 totalBytesExpectedToWrite：总得下载字节数（文件的总大小）
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress =(float) totalBytesWritten/totalBytesExpectedToWrite;
    //    NSLog(@"%f", progress);
    NSLog(@"======%@", [NSThread currentThread]);
}

// 3、断点续传的时候，被调用的方法。一般什么都不写，IOS8可以不实现，但IOS7必须实现
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"====== %@", @"didReceiveChallenge");
}

@end
