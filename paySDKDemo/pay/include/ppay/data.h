//
//  data.h
//  paySDKDemo
//
//  Created by qingshasu on 17/9/8.
//  Copyright © 2017年 Alipay.com. All rights reserved.
//

#ifndef data_h
#define data_h
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


#endif /* data_h */
