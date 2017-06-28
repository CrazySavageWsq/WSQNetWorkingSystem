//
//  WsqflyNetWorking.h
//  WSQNetWorkingSystem
//
//  Created by webapps on 16/12/28.
//  Copyright © 2016年 webapps. All rights reserved.
//

/**GET
 1 .确定请求路径（一般由公司的后台开发人员以接口文档的方式提供），GET请求参数直接跟在URL后面
 
 2 .创建请求对象（默认包含了请求头和请求方法【GET】）
 
 3 .创建会话对象（NSURLSession）
 
 4 .根据会话对象创建请求任务（NSURLSessionDataTask）
 
 5 .执行Task
 
 6 .当得到服务器返回的响应后，解析数据（XML|JSON）
 
 */



/**POST
 1 .确定请求路径（一般由公司的后台开发人员以接口文档的方式提供）
 
 2 . 创建可变的请求对象（因为需要修改），此步骤不可以省略
 
 3 . 修改请求方法为POST
 
 4 . 设置请求体，把参数转换为二进制数据并设置请求体
 
 5 . 创建会话对象（NSURLSession）
 
 6 . 根据会话对象创建请求任务（NSURLSessionDataTask）
 
 7 . 执行Task
 
 8 . 当得到服务器返回的响应后，解析数据（XML|JSON）
 
 */






#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^SuccessBlock)(id response);                                  // 成功返回的数据
typedef void(^RequestHeadBlock)(id response);                             // 请求头返回的数据
typedef void(^FaileBlock)(NSError * error);                              // 请求错误返回的数据



typedef NS_ENUM(NSUInteger,WsqflyNetSessionMaskState) {
    
    WsqflyNetSessionMaskStateNone       =  0,                       // 没有菊花
    WsqflyNetSessionMaskStateCanTouch   =  1,                      // 有菊花并点击屏幕有效
    WsqflyNetSessionMaskStateNotTouch   =  2                      // 有菊花单点击屏幕没有效果
  
};

typedef NS_ENUM(NSUInteger,WsqflyNetSessionResponseType){
    WsqflyNetSessionResponseTypeDATA    =  0,                 // 返回后台是什么就是什么DATA
    WsqflyNetSessionResponseTypeJSON    =  1                 // 返会序列化后的JSON数据
};

typedef NS_ENUM(NSUInteger,WsqflyNetSessionUploadImageType){
    WsqflyNetSessionUploadImageTypeJPG   =  0,            // 上传的图片为JPG格式
    WsqflyNetSessionUploadImageTypePNG   =  1            // 上传的图片为PNG格式
};


@interface WsqflyNetSession : NSObject

//单利
+ (instancetype) wsqflyNetWorkingShare;

//判断是否有网络
+ (NSString *)connectedToNetwork;


/**GET短数据请求
 * urlString          网址
 * param              参数
 * state              显示菊花的类型
 * backData           返回的数据是NSDATA还是JSON
 * successBlock       成功数据的block
 * faileBlock         失败的block
 * requestHeadBlock   请求头的数据的block
 */
- (void)get1:(NSString *)urlString param:(NSDictionary *)param maskState:(WsqflyNetSessionMaskState)state backData:(WsqflyNetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock;





/**POST短数据请求
 * urlString           网址
 * param               参数
 * state               显示菊花的类型
 * backData            返回的数据是NSDATA还是JSON
 * successBlock        成功数据的block
 * faileBlock          失败的block
 * requestHeadBlock    请求头的数据的block
 */

-(void)post:(NSString *)urlString bodyparam:(NSDictionary *)param maskState:(WsqflyNetSessionMaskState)state backData:(WsqflyNetSessionResponseType)backData success:(SuccessBlock)successBlock requestHead:(RequestHeadBlock)requestHeadBlock faile:(FaileBlock)faileBlock;




//- (void)postUploadImage:(NSArray<>)


@end
