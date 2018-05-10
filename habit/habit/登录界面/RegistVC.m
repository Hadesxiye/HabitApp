//
//  RegistVC.m
//  habit
//
//  Created by 王浩祯 on 2018/4/5.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "RegistVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface RegistVC ()<UITextFieldDelegate>
{
    UITextField* _userNameField;
    UITextField* _passwordField;
    UIButton* _registBtn;
    UILabel* _haveBeenRegist;
}
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = myBackgroundColorWhite;
    [self setNavRightButton];
    [self createUI];
}
#pragma mark - ❀==============❂ ui创建 ❂==============❀
-(void)createUI{
    _userNameField = [UITextField new];
    _passwordField = [UITextField new];
    _registBtn = [UIButton new];
    _haveBeenRegist = [UILabel new];
    
    _userNameField.frame = CGRectMake(50, 100, SC_WIDTH - 200, 50);
    _haveBeenRegist.frame = CGRectMake(SC_WIDTH - 150, 100, 100, 50);
    _passwordField.frame = CGRectMake(50, 180, SC_WIDTH - 100, 50);
    _registBtn.frame = CGRectMake(50, 280, SC_WIDTH - 100, 50);
    
    _userNameField.placeholder = @"请输入用户名~";
    _passwordField.placeholder = @"请输入密码~";
    _haveBeenRegist.text = @"用户名不能为空";
    _haveBeenRegist.textColor = [UIColor redColor];
    
    _haveBeenRegist.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:15];
    _userNameField.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    _passwordField.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    _registBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    
    _passwordField.secureTextEntry = YES;
    
    [_registBtn setTitle:@"注 册" forState:UIControlStateNormal];
    
    [_registBtn addTarget:self action:@selector(registRequest) forControlEvents:UIControlEventTouchUpInside];
    
    _userNameField.backgroundColor = myBackgroundColorWhite;
    _passwordField.backgroundColor = myBackgroundColorWhite;
    _registBtn.backgroundColor = myBackgroundColorPurple;
    
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _userNameField.textColor = myBackgroundColorBlue;
    _passwordField.textColor = myBackgroundColorBlue;
    
    _userNameField.delegate = self;
    
    [self.view addSubview:_haveBeenRegist];
    [self.view addSubview:_userNameField];
    [self.view addSubview:_passwordField];
    [self.view addSubview:_registBtn];
    
}
#pragma mark - ❀==============❂ textfield内容变化代理 ❂==============❀
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField==_userNameField) {
        if ([_userNameField.text isEqualToString:@""]||_userNameField.text==nil) {
            _haveBeenRegist.text = @"用户名不能为空";
            _haveBeenRegist.textColor = [UIColor redColor];
        }
        else{
            [self checkUserNumberRequest];
        }
    }
    
}
#pragma mark - ❀==============❂ 注册网络请求 ❂==============❀
-(void)registRequest{
    NSString *urlString = @"http://111.231.69.134:8080/Hades/user/register.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    //post数据
    NSDictionary *dict= @{
                          @"name":_userNameField.text,
                          @"password":_passwordField.text
                          };
    
    [manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        if (responseObject) {
            
            NSDictionary* dict = (NSDictionary *)responseObject;
            NSString* messageStr = [NSString stringWithFormat:@"%@",dict[@"message"]];
            WHZLog(@"msg注册返回=%@",messageStr);
            NSString* statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
            
            if (statusStr.integerValue==1) {
                //standardUserDefaults：获取全局唯一的实例对象
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                //登录设置为1
                [ud setObject:@"1" forKey:@"isLogin"];
                [ud setObject:[NSString stringWithFormat:@"%@",_userNameField.text] forKey:@"userName"];
                [self textWaiting:@"注册成功~自动登录！"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                WHZLog(@"注册成功");
            }
            else{
                [self textWaiting:statusStr];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - ❀==============❂ 判断用户名是否可用网络请求 ❂==============❀
-(void)checkUserNumberRequest{
    NSString *urlString = @"http://111.231.69.134:8080/Hades/user/check.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    //post数据
    NSDictionary *dict= @{
                          @"name":_userNameField.text
                          };
    
    [manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        if (responseObject) {
            NSDictionary* dict = (NSDictionary *)responseObject;
            NSString* messageStr = [NSString stringWithFormat:@"%@",dict[@"message"]];
            WHZLog(@"msg用户名可用性=%@",messageStr);
            NSString* statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
            
            if (statusStr.integerValue==1) {
                _haveBeenRegist.textColor = [UIColor greenColor];
                _haveBeenRegist.text = @"用户名可注册";
            }
            else{
                _haveBeenRegist.textColor = [UIColor redColor];
                _haveBeenRegist.text = @"用户名已存在";
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - ❀==============❂ 文字提示框 ❂==============❀
- (void)textWaiting:(NSString *)str {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 1);
    
    [hud hideAnimated:YES afterDelay:3.f];
}
#pragma mark - ❀==============❂ 设置导航栏左右按钮 ❂==============❀
-(void)setNavRightButton
{
    
    
    //左侧按钮
    UIBarButtonItem* backBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAmin)];
    
    self.navigationItem.leftBarButtonItem  = backBtn;
}
#pragma mark ❀==============❂ 按钮转场动画 ❂==============❀
-(void)backAmin{
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    amin.type = @"reveal";
    amin.subtype = kCATransitionFromBottom;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
