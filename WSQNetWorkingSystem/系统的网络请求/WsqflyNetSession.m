//
//  WsqflyNetWorking.m
//  WSQNetWorkingSystem
//
//  Created by webapps on 16/12/28.
//  Copyright © 2016年 webapps. All rights reserved.
//

#import "WsqflyNetSession.h"
//#import "RealReachability.h"

#define CONTECTTIME  30   // 联网时间

@interface WsqflyNetSession ()

@property (nonatomic,strong) UIActivityIndicatorView * wsqAView;
@property (nonatomic,assign) int maskCount;

@end



@implementation WsqflyNetSession


static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)wsqflyNetWorkingShare
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _wsqAView = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _wsqAView.color = [UIColor blackColor];
    }
    return self;
}


#pragma mrak 判断是否联网
//+ (NSString *)connectedToNetwork
//{
//    NSString *netString;
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
//    
//    switch (status) {
//        case -1:
//            netString = @"网络异常!";
//            break;
//        case 0:
//            netString = @"连接不到网络!";
//            break;
//        case 1:
//            netString = @"正在使用流量上网!";
//            break;
//        case 2:
//            netString = @"正在使用wifi上网!";
//            break;
//            
//        default:
//            break;
//    }
//    return netString;
//}


#pragma MARK-- GET

- (void)get1:(NSString *)urlString param:(NSDictionary *)param maskState:(WsqflyNetSessionMaskState)state backData:(WsqflyNetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock{
    
    NSURL *url;
    
 
    NSString *string = [NSString string];
    if (param) {//带字典参数
        string = [self nsdictionaryToNSStting:param];
        
            //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
         url = [NSURL URLWithString:[self urlConversionFromOriginalURL:[NSString stringWithFormat:@"%@&%@",urlString,string]]];
    }else{
            //1. GET 请求，直接把请求参数跟在URL的后面以？(问号前是域名与/接口名)隔开，多个参数之间以&符号拼接
        url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    }

    //2. 创建 请求对象内部默认了已经包含了请求头和请求方法(GET）的对象
      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];
    
    /*   设置请求头  */
//    [request setValue:@"92b5787ecd17417b718a2aaedc7e6ce8" forHTTPHeaderField:@"apix-key"];
    
    //4. 根据会话对象创建一个task任务(发送请求）
    
    [self startNSURLSessionDataTask:request maskState:state responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
    
}




#pragma MARK-- POST

-(void)post:(NSString *)urlString bodyparam:(NSDictionary *)param maskState:(WsqflyNetSessionMaskState)state backData:(WsqflyNetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock{
    
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
  
    
    //1.url
    NSURL *url = [NSURL URLWithString:[self urlConversionFromOriginalURL:urlString]];
    
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:CONTECTTIME];

    /*   设置请求头  */
    //    [request setValue:@"92b5787ecd17417b718a2aaedc7e6ce8" forHTTPHeaderField:@"apix-key"];
    
    
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    
    //有参数请求题
    if (param) {
        
        //5.设置请求体
        NSString *string = [self nsdictionaryToNSStting:param];
        request.HTTPBody = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    //6.根据会话对象创建一个Task(发送请求）
    [self startNSURLSessionDataTask:request maskState:state responType:backData success:successBlock headfiles:requestHeadBlock fail:faileBlock];
}




#pragma MARK-- 根据会话对象创建一个Task(发送请求）

- (void)startNSURLSessionDataTask:(NSMutableURLRequest *)request  maskState:(WsqflyNetSessionMaskState)state responType:(WsqflyNetSessionResponseType)responType success:(SuccessBlock)respone headfiles:(RequestHeadBlock)headfiles fail:(FaileBlock)fail{
    
    
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self stopAnimation:state];
        
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSLog(@"result:%@",result);
        
        // 解析服务器返回的数据(返回的数据为JSON格式，因此使用NSJNOSerialization 进行反序列化)
        id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"response%@",response);
        NSHTTPURLResponse * da =(NSHTTPURLResponse *)response;
        NSDictionary *allheadsFiles = da.allHeaderFields;
        NSLog(@"allheadsFiles:%@",allheadsFiles[@"Content-Type"]);
        
        //8.解析数据
        if (!error) {
            if (responType == WsqflyNetSessionResponseTypeJSON) {//返回JSON
                respone(dict);
            }else{
                   respone(data);//返回二进制
            }
            
            
        }else{
            fail(error);
            NSLog(@"网络请求失败");
        }
        
        if (response) {
            headfiles(allheadsFiles);
        }
        
    }];
    
    //7.执行任务
    [self showAnimation:state];
    [dataTask resume];
}




#pragma MARK -- 菊花
// 添加菊花
- (void)showAnimation:(WsqflyNetSessionMaskState)maskType {
    if (maskType != WsqflyNetSessionMaskStateNone) {   // 有菊花动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
            [[UIApplication sharedApplication].keyWindow addSubview:_wsqAView];
            _wsqAView.hidden = NO;
            [_wsqAView startAnimating];
            _wsqAView.userInteractionEnabled = (maskType == WsqflyNetSessionMaskStateNotTouch ? YES : NO);
            _maskCount++;
        });
    }
}
// 移除菊花
- (void)stopAnimation:(WsqflyNetSessionMaskState)maskType {
    if (maskType != WsqflyNetSessionMaskStateNone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _maskCount--;
            if (_maskCount <= 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                [_wsqAView stopAnimating];
                _wsqAView.hidden = YES;
                [_wsqAView removeFromSuperview];
            }
        });
    }
}



#pragma MARK -- 把字典拼成字符串

- (NSString *) nsdictionaryToNSStting:(NSDictionary *)param{
    
    NSMutableString *string = [NSMutableString string];
    
    //便利字典把键值平起来
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@",obj];
        [string appendFormat:@"%@",@"&"];
    }];
    // 去掉最后一个&
    NSRange rangeLast = [string rangeOfString:@"&" options:NSBackwardsSearch];
    if (rangeLast.length != 0) {
        [string deleteCharactersInRange:rangeLast];
    }
    NSLog(@"string:%@",string);
    NSRange range = NSMakeRange(0, [string length]);
    [string replaceOccurrencesOfString:@":" withString:@"=" options:NSCaseInsensitiveSearch range:range];
    NSLog(@"string:%@",string);
    
    return string;
}


// 中文转yi
- (NSString *)urlConversionFromOriginalURL:(NSString *)originalURL {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        return [originalURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];// iOS 9.0 以下
    }
    return [originalURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}



#pragma mark NSURLSession Delegate
/* 收到身份验证 ssl */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSLog(@"didReceiveChallenge %@", challenge.protectionSpace);
    NSLog(@"调用了最外层");
    // 1.判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {        NSLog(@"调用了里面这一层是服务器信任的证书");
        /*  NSURLSessionAuthChallengeUseCredential = 0,                     使用证书         NSURLSessionAuthChallengePerformDefaultHandling = 1,            忽略证书(默认的处理方式)         NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,     忽略书证, 并取消这次请求         NSURLSessionAuthChallengeRejectProtectionSpace = 3,            拒绝当前这一次, 下一次再询问   
         */
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential , card);
        
    }
   
}




@end
