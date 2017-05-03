//
//  ViewController.m
//  ZKNSNotificationView
//
//  Created by mosaic on 2017/4/29.
//  Copyright © 2017年 mosaic. All rights reserved.
//

#import "ViewController.h"
#import "ZKNotificationDefine.h"
#import "ZKViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}
- (IBAction)sendMsg:(id)sender {
    [ZKNotificationView show:self.textField.text delay:1.5 block:^{
        NSLog(@"被点击回调了");
        ZKViewController * vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (IBAction)showMsg:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZKNotificationView show:self.textField.text block:^{
        weakSelf.textField.text = @"我被点击回调了";
    }];
}
- (IBAction)hiddenMsg:(id)sender {
    [ZKNotificationView hidden];
}

@end
