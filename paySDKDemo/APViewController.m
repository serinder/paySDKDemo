//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import "APViewController.h"



#define ALI_DEMO_BUTTON_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 40.0f)
#define ALI_DEMO_BUTTON_HEIGHT (60.0f)
#define ALI_DEMO_BUTTON_GAP    (30.0f)


#define ALI_DEMO_INFO_HEIGHT (200.0f)



@implementation APViewController
{
    PPay *_ppay ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _ppay = [PPay getInstance];
    [self generateButtons];
}


#pragma mark -
#pragma mark   ==============产生随机订单号==============

- (void)generateButtons
{
    // NOTE: 支付按钮，模拟支付流程
    CGFloat originalPosX = 20.0f;
    CGFloat originalPosY = 100.0f;
    UIButton* payButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    payButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    payButton.layer.masksToBounds = YES;
    payButton.layer.cornerRadius = 4.0f;
    [payButton setTitle:@"微信支付Demo" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(getwx) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    // NOTE: 授权按钮，模拟授权流程
    originalPosY += (ALI_DEMO_BUTTON_HEIGHT + ALI_DEMO_BUTTON_GAP);
    UIButton* authButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    authButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    authButton.layer.masksToBounds = YES;
    authButton.layer.cornerRadius = 4.0f;
    [authButton setTitle:@"支付宝支付Demo" forState:UIControlStateNormal];
    [authButton addTarget:self action:@selector(getzfb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];
    

    
}

-(void)getwx{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://game123.2ww.com/WS/MobileInterface.ashx?action=CreatPayOrderID&gameid=102199&amount=30&paytype=wx&appid=5"];
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //5.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        NSDictionary *da = [dict objectForKey:@"data"];
        NSString *OrderID = [da objectForKey:@"OrderID"];
        NSString *PayPackage = [da objectForKey:@"PayPackage"];
        NSData *nsdata = [PayPackage dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:nsdata
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
        NSDictionary *info = (NSDictionary*)jsonObject;
        BOOL bRes = FALSE;
        NSString *appid = [info objectForKey:@"appid"];
        bRes = (appid != nil);
        NSString *partnerId = [info objectForKey:@"partnerid"];
        bRes = (partnerId != nil);
        NSString *prepayId = [info objectForKey:@"prepayid"];
        bRes = (prepayId != nil);
        NSString *packageValue = [info objectForKey:@"package"];
        bRes = (packageValue != nil);
        NSString *nonceStr = [info objectForKey:@"noncestr"];
        bRes = (nonceStr != nil);
        NSString *timeStamp = [info objectForKey:@"timestamp"];
        bRes = (timeStamp != nil);
        NSString *sign = [info objectForKey:@"sign"];
        bRes = (sign != nil);
        if (FALSE == bRes)
        {
             NSLog(@"%@",@"订单数据解析失败");
            return;
        }
        WXOrder *wecatconfig = [WXOrder new];
        wecatconfig.openID = appid;
        wecatconfig.partnerId = partnerId;
        wecatconfig.prepayId = prepayId;
        wecatconfig.nonceStr = nonceStr;
        wecatconfig.timeStamp = timeStamp;
        wecatconfig.package = packageValue;
        wecatconfig.sign = sign;
        [_ppay wxPay:PPAY_WECHAT delegate:self payparam:wecatconfig];
    }];
    //4.执行任务
    [dataTask resume];
}

-(void)getzfb{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://game123.2ww.com/WS/MobileInterface.ashx?action=CreatPayOrderID&gameid=102199&amount=30&paytype=zfb&appid=5"];
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //5.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@",dict);
        NSDictionary *da = [dict objectForKey:@"data"];
        NSString *OrderID = [da objectForKey:@"OrderID"];
        ZFBOrder *alpay = [ZFBOrder new];
        alpay.AlipayPartnerID = @"2017080708079550";
//        alpay.AlipaySeller = _alipay.AlipaySeller;
    alpay.AlipayPrivate=@"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCHncMtWXq17nnT4k6Q8pdr5TMTZqMZ3VuL3ifVQ6nSNTu++ADAogmvkHfST1XmpHeHaUWMKJHAhD5hZJwS7G8tIeSA2vbgDA3UEzWzcJjS1KrVd5RmdcJbJqSZTpeuJyGbXtx2lLdV5ajt77y0uDntdgvm1KaswP7AaxTGEp8A630dqMKp0XcrUgiy6sAVB/wOQz3lruuRSZlCCDJLXOAMgfjB+sEFw/YzSfH9SBMSfBmhSuWTg/BpxGvXBfFx4ABnUQsg7GeYeMI//poPE2Cs7HC+CfRkdHSGKWb1dj3dS2PnYBZJi2bp52JlGLAq7kFYmSOsmaPZZsyWrMQvBXxDAgMBAAECggEARGUQNiLWfEKVNoL/1KJEM6oYJESzJSw6K0QTGr9ROi6Wvy0cVApkkCJwC6TvUa7IiYZSCOm8+Da5ryyqefC78SsSrtm/gCcUIky93I2AxXNz5My2DyZ8qrPGd3rnjHE3xcAFt9gwziVRGQ67QPlYXaYXQockuCNtV2WpyGtDvZZKCf2dBj6QEwhUBCIcy74rj28M2Kqw6UhetyPSp4DaA3RI1emn6qoTTo6nx+QpvmyTlZo1R7fzrBZtpOE9L35X/Qp20Oj95FKPaBrw1upq7T4jcMeAEVEvMUHU34pZFExlnVznKQyYIcGCg8Vlw2n12COm17DMYmhd558EHxwA4QKBgQDD4qcvcu8pcNqP/Nx3GeR5EGSMGApnCUxzMGxSAeiC7iB9x49ESJNBFqHC8v+75Z86wjRv8cZQKZXNaaIWKhSZQgf1ZyoRopYK2JL774Mu+C5kGst0KhL1ofe3kgw/5KTwd1I8YZfHmQaKMZSZqHPZyezgRt2M8Vy2cgv8Lq78vwKBgQCxPC+m82DoMJCix8qtITkUh7+OVOlQuvl2QK5bsP+dH8HUnyEOOcBadIlG8CpmVgzYaRC8kIFnFu3ydFasZliO/hscBQutoL630SxIwULpfaYoSBLnRCFcLFePGFIpmoxJqTn2+4iqQ+JkOkVGzbQNIxf2ebh2zNzh0MEI8/mtfQKBgHDoILOBzQaW7PPXrP/dZcq+PyZc6QoQ2wb+H0F5phppxUKalyKlrnLy55Rl2i/kn84PiIgJ1OP5xEXdIDckVDEuVUYHC8GUdGWWBcq/eF7HYH4Ez8aKRdldXVprDTJ6yPNt43G4UvMSaimXgG69IOGkuStgzWzi5iynOe9GvUgjAoGBAIKlsSLKSWcfVZ8I09hnoyIFJymOYibGjVmkOGMSyHpUjJdlbgKEg8yqFv+Zzkd9qx5j5Jh7lUge2Oxe4f1XvHQ70FQJTCCDW9M4eAJxpBdmLfOHnZeo20aM0UaEURyl9j/eZQIxTP7l556mbabRv6XndqST+Wxpe3FiZslov2YpAoGAQl7xE6DyBBQ/WLFAx90FwcV+twOMqTEGb1eX6afczN2XHhotXXMZgrePbvlP9/2V2M4ATQyg7IWjGcndasOHKNxBhRWKskRSn6nAIcF6BZtyq2Vpwjq8SjkO9KsDrI3hYl6z7YfdMkpF3zU1p0bPXYeAr7vZeaahkZr6lb/VfcQ=";
        alpay.AlipayNotifyUrl = @"http://game123.2ww.com/Pay/ZFB/notify_url.aspx";
        alpay.sOrderId = OrderID;
        alpay.sProductName = @"31钻石";
        alpay.fPrice = 3.0;
        [_ppay zfbPay:PPAY_ALIPAY delegate:self payparam:alpay];
    }];
    //4.执行任务
    [dataTask resume];
}

#pragma mark - 回调
-(void) onPPaySuccess:(PlatformType)plat backMsg:(NSString *)msg{
   NSLog(@"支付成功回调--%@",msg);
}
-(void) onPPayFail:(PlatformType)plat backMsg:(NSString *)msg{
    NSLog(@"支付失败回调--%@",msg);
}

@end
