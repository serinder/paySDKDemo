//
//  PPay.h
//  GloryProject
//
//  Created by zhong on 16/9/8.
//
//

#ifndef ppay_h
#define ppay_h

#import <Foundation/Foundation.h>




/////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(NSUInteger,PlatformType)
{
    PPAY_WECHAT = 0,// WX
    PPAY_ALIPAY = 1,// ZFB

};


//WX配置
@interface WXOrder : NSObject

    /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
    @property (nonatomic, copy) NSString* openID;
    /** 商家向财付通申请的商家id */
    @property (nonatomic, copy) NSString *partnerId;
    /** 预支付订单 */
    @property (nonatomic, copy) NSString *prepayId;
    /** 随机串，防重发 */
    @property (nonatomic, copy) NSString *nonceStr;
    /** 时间戳，防重发 */
    @property (nonatomic, copy) NSString *timeStamp;
    /** 商家根据财付通文档填写的数据和签名 */
    @property (nonatomic, copy) NSString *package;
    /** 商家根据微信开放平台文档对数据做的签名 */
    @property (nonatomic, copy) NSString *sign;
@end


//ZFB配置
@interface ZFBOrder : NSObject
    //合作者身份id
    @property (nonatomic, copy) NSString* AlipayPartnerID;
    //收款ZFB账号
    @property (nonatomic, copy) NSString* AlipaySeller;
    //商户私钥
    @property (nonatomic, copy) NSString* AlipayPrivate;
    //验证地址
    @property (nonatomic, copy) NSString* AlipayNotifyUrl;
    //订单ID（由商家自行制定）
    @property (nonatomic, copy) NSString *sOrderId;
    //订单名称（由商家自行制定）
    @property (nonatomic, copy) NSString *sProductName;
    //订单价格（由商家自行制定）
    @property (nonatomic, assign) float fPrice;
@end


//ZF回调
@protocol PPayDelegate <NSObject>

- (void) onPPaySuccess:(PlatformType)plat backMsg:(NSString *)msg;
- (void) onPPayFail:(PlatformType)plat backMsg:(NSString *)msg;
- (void) onPPayNotify:(PlatformType)plat backMsg:(NSString *)msg;

@end

@interface PPay: NSObject


/**
 *  创建ZF单例服务
 *
 *  @return 返回单例对象
 */

+ (PPay*) getInstance;



/**
 
 Deprecated API
 
 处理app的URL方法
 
 @param url 传入的url
 
 */

- (BOOL) handleOpenURL:(NSURL *)url;


/**
 
 WXZF API
 
 
 @param delegate 传入的delegate
 @param payparam 传入的结构体
 
 */
- (void) wxPay:(PlatformType)plat delegate:(id<PPayDelegate>)delegate payparam:(WXOrder*) payparam;

/**
 
 ZFB ZF API
 
 
 @param delegate 传入的delegate
 @param payparam 传入的结构体
 
 */
- (void) zfbPay:(PlatformType)plat delegate:(id<PPayDelegate>)delegate payparam:(ZFBOrder*) payparam;

@end
#endif /* PPay.h */
