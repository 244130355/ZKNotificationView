//
//  ZKNotificationView.m
//  ZKNSNotificationView
//
//  Created by mosaic on 2017/4/29.
//  Copyright © 2017年 mosaic. All rights reserved.
//

#import "ZKNotificationView.h"
#import <AudioToolbox/AudioToolbox.h>

static NSString * _appName;
static NSString * _appIconName;
static NSMutableArray *_viewArray;


//背景图比例系数 1242*2208
CGFloat relativeW(CGFloat w){
    
    return w/1242*ZKSCREEN_W;
}
CGFloat relativeH(CGFloat h){
    return h/2208*ZKSCREEN_H;
}

#define LRMargin 10.0 //左右边距
#define TopMargin 10.0 //上下边距
#define ZKFontSize 17 //字体大小
#define ZKLabelFontMargin 10//文本内部边距
@interface ZKNotificationView ()

@property (nonatomic,copy)NSString *showName;
@property (nonatomic,copy)NSString *showIconName;
@property (nonatomic,copy)NSString *showMsg;

@property (nonatomic,weak)UIView *topView;
@property (nonatomic,weak)UIView *bottomView;

@property (nonatomic,weak)UIImageView *iconImgV;
@property (nonatomic,weak)UILabel *appNameLabel;
@property (nonatomic,weak)UILabel *msgLabel;

@property (nonatomic,assign)CGRect hiddenRect;
@property (nonatomic,assign)CGRect showRect;

@property (nonatomic,strong)NSTimer *timer;


@property (nonatomic,copy)NotificationViewFinished notifiViewBlock;

@end
@implementation ZKNotificationView
+(void)initialize{

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    _appIconName = [iconsArr lastObject];
    // app名称
    _appName = [infoDictionary objectForKey:@"CFBundleName"];
    
    _viewArray = [NSMutableArray array];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置圆角
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
        //上部view
        UIView *topView = [[UIView alloc]init];
        [topView setFrame:CGRectMake(0, 0, frame.size.width, relativeH(110))];
        topView.backgroundColor = [UIColor colorWithHexString:@"#FEFFFE" alpha:0.9];
        
        [self addSubview:topView];
        self.topView = topView;
        //下部view
        UIView *bottomView = [[UIView alloc]init];
         [bottomView setFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), frame.size.width, frame.size.height-relativeH(110))];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#FEFFFE" alpha:0.8];
        [self addSubview:bottomView];

        //icon
        UIImageView *imgV = [[UIImageView alloc]init];
        CGFloat iconW = relativeW(70);
        [imgV setFrame:CGRectMake(LRMargin, (topView.frame.size.height-iconW)/2, iconW, iconW)];
        [imgV setClipsToBounds:YES];
        imgV.layer.cornerRadius = 5;
        [self addSubview:imgV];
        self.iconImgV = imgV;
        
        //appname
        UILabel *nameLabel = [[UILabel alloc]init];
        [nameLabel setFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+LRMargin, imgV.frame.origin.y, topView.frame.size.width/2, iconW)];
        nameLabel.font = [UIFont systemFontOfSize:14 weight:0];
        [self addSubview:nameLabel];
        self.appNameLabel = nameLabel;
        
        //msgLabel
        UILabel *msgLabel = [[UILabel alloc]init];
        [msgLabel setFrame:CGRectMake(LRMargin, CGRectGetMaxY(topView.frame)+LRMargin, bottomView.frame.size.width-LRMargin*2, bottomView.frame.size.height-LRMargin*2)];
        [msgLabel setNumberOfLines:0];
        [msgLabel setLineBreakMode:NSLineBreakByClipping];
        [msgLabel setAdjustsFontSizeToFitWidth:YES];
        msgLabel.font = [UIFont  systemFontOfSize:ZKFontSize];
        [self addSubview:msgLabel];
        self.msgLabel = msgLabel;
        
        //添加点击事件
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notifiClick)];
        [self addGestureRecognizer:tapGesturRecognizer];
        
    }
    return self;
}
-(void)notifiClick{
    [ZKNotificationView hidden];
    self.notifiViewBlock();
}

+(void)show:(NSString*)msg block:(NotificationViewFinished)finishBlock{
    [self showViewName:_appName icon:_appIconName msg:msg delay:0 block:finishBlock];
}
+(void)show:(NSString *)msg delay:(NSTimeInterval)time block:(NotificationViewFinished)finishBlock{
    [self showViewName:_appName icon:_appIconName msg:msg delay:time block:finishBlock];
}
+(void)showViewName:(NSString*)showName icon:(NSString*)imageName msg:(NSString*)msg block:(NotificationViewFinished)finishBlock{
    [self showViewName:showName icon:imageName msg:msg delay:0 block:finishBlock];
}
+(void)showViewName:(NSString*)showName icon:(NSString*)imageName msg:(NSString*)msg delay:(NSTimeInterval)time block:(NotificationViewFinished)finishBlock{
    
    AudioServicesPlaySystemSound(1007);
    //大小
    CGFloat viewW  = ZKSCREEN_W -LRMargin*2;
    //根据文字计算高度
    CGFloat msgH;
    if (msg&&msg.length>0) {
        CGSize labelSize = [self fontViewSizeMsg:msg font:ZKFontSize width:viewW-LRMargin*2];
         msgH = labelSize.height ;
    }else{
        msgH = 0;
    }
    
    
    
    CGFloat viewH = relativeH(110)+ msgH+ ZKLabelFontMargin*2;
    //未显示时的位置
    CGFloat hiddenX = LRMargin;
    CGFloat hiddenY = -viewH;
    CGRect hiddenRect = CGRectMake(hiddenX, hiddenY, viewW, viewH);
    
    //显示后的位置
    CGFloat showX = LRMargin;
    CGFloat showY = TopMargin;
    CGRect showRect = CGRectMake(showX, showY, viewW, viewH);

    ZKNotificationView*notiView =  [[self alloc]initWithFrame:hiddenRect];
    notiView.notifiViewBlock = finishBlock;
    
    notiView.hiddenRect = hiddenRect;
    notiView.showRect = showRect;
    notiView.backgroundColor = [UIColor clearColor];
    //设置视图显示信息
    [notiView setViewInfo:showName icon:imageName msg:msg];
    
    
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:notiView];
    
    

    [UIView animateWithDuration:0.2 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        [notiView setFrame:showRect];

    } completion:^(BOOL finished) {
        [_viewArray addObject:notiView];//将视图添加至数组
        if (_viewArray.count>=2) {//如果显示视图大于2,移除前面的视图
            for (int i=0; i<_viewArray.count-1; i++) {
                ZKNotificationView *view = _viewArray[i];
                [NSObject cancelPreviousPerformRequestsWithTarget:view selector:@selector(removeSelf) object:nil];
                [view removeFromSuperview];
                [_viewArray removeObject:view];
            }
        }
        if (time>0) {
            [notiView performSelector:@selector(removeSelf) withObject:nil afterDelay:time];
        }
    }];
}

+(void)hidden{
    if (_viewArray.count>0) {
        ZKNotificationView *notiView = [_viewArray lastObject];
        [NSObject cancelPreviousPerformRequestsWithTarget:notiView selector:@selector(removeSelf) object:nil];
        [notiView removeSelf];
    }
}



//设置数据信息
-(void)setViewInfo:(NSString*)showName icon:(NSString*)icon msg:(NSString*)msg{
    if (icon==nil||icon.length==0) {
        [self.iconImgV setImage:[UIImage imageNamed:_appIconName]];
    }else{
        [self.iconImgV setImage:[UIImage imageNamed:icon]];
    }
    if (showName==nil||showName.length==0) {
        self.appNameLabel.text = _appName;
    }else{
        self.appNameLabel.text = showName;
    }
    self.msgLabel.text = msg;

};


-(void)removeSelf{//移除视图
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:self.hiddenRect];
        [_viewArray removeObject:self];
        if (_viewArray.count==0) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

+(CGSize)fontViewSizeMsg:(NSString*)str font:(CGFloat)fontSize width:(CGFloat)width{
    //根据label文字获取CGRect
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //set the line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:fontSize],
                              NSFontAttributeName,
                              paragraphStyle,
                              NSParagraphStyleAttributeName,
                              nil];
    
    
    //assume your maximumSize contains {250, MAXFLOAT}
    CGRect lblRect = [str boundingRectWithSize:(CGSize){width, MAXFLOAT}
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attrDict
                                              context:nil];
    
    return lblRect.size;
}


@end
