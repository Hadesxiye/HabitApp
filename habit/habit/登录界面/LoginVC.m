//
//  LoginVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/20.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "LoginVC.h"
#import "BaseTabBarViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RegistVC.h"

@interface LoginVC ()<UITextFieldDelegate>
{
    UITextField* _userNameField;
    UITextField* _passwordField;
    UIButton* _loginBtn;
    UIButton* _registBtn;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = myBackgroundColorWhite;
    [self setNavRightButton];
    [self createUI];
    // Do any additional setup after loading the view.
}
#pragma mark - ❀==============❂ ui创建 ❂==============❀
-(void)createUI{
    _userNameField = [UITextField new];
    _passwordField = [UITextField new];
    _loginBtn = [UIButton new];
    _registBtn = [UIButton new];
    
    _userNameField.frame = CGRectMake(50, 100, SC_WIDTH - 100, 50);
    _passwordField.frame = CGRectMake(50, 180, SC_WIDTH - 100, 50);
    _loginBtn.frame = CGRectMake(50, 280, SC_WIDTH - 100, 50);
    _registBtn.frame = CGRectMake(50, 350, SC_WIDTH - 100, 50);
    
    _userNameField.placeholder = @"请输入用户名~";
    _passwordField.placeholder = @"请输入密码~";
    _userNameField.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    _passwordField.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    _registBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
    
    _passwordField.secureTextEntry = YES;
    
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_registBtn setTitle:@"注 册" forState:UIControlStateNormal];
    
    [_loginBtn addTarget:self action:@selector(loginRequest) forControlEvents:UIControlEventTouchUpInside];
    [_registBtn addTarget:self action:@selector(registRequest) forControlEvents:UIControlEventTouchUpInside];
    
    _userNameField.backgroundColor = myBackgroundColorWhite;
    _passwordField.backgroundColor = myBackgroundColorWhite;
    _loginBtn.backgroundColor = myBackgroundColorPurple;
    _registBtn.backgroundColor = myBackgroundColorPurple;
    
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _userNameField.textColor = myBackgroundColorBlue;
    _passwordField.textColor = myBackgroundColorBlue;
    
    [self.view addSubview:_userNameField];
    [self.view addSubview:_passwordField];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_registBtn];
    
    
}
#pragma mark - ❀==============❂ 登录网络请求 ❂==============❀
-(void)loginRequest{
    if ([_userNameField.text isEqualToString:@""]||_userNameField==nil) {
        [self textWaiting:@"请输入用户名！"];
        return;
    }
    if ([_passwordField.text isEqualToString:@""]||_passwordField==nil) {
        [self textWaiting:@"请输入密码！"];
        return;
    }
    NSString *urlString = @"http://111.231.69.134:8080/Hades/user/login.action";
    
    AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
    
    //post数据
    NSDictionary *dict= @{
                          @"name":_userNameField.text,
                          @"password":_passwordField.text
                          };
    WHZLog(@"dic==%@",dict);
    [manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        //解析数据
        if (responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSString* messageStr = [NSString stringWithFormat:@"%@",dict[@"message"]];
            NSString* statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
            
            WHZLog(@"msg==%@   status==%@",messageStr,statusStr);
            
            if (statusStr.integerValue==0) {
                [self textWaiting:@"用户名或密码错误！"];
            }
            if (statusStr.integerValue==1) {
                [self textWaiting:@"登录成功~"];
                //standardUserDefaults：获取全局唯一的实例对象
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                //登录设置为1
                [ud setObject:@"1" forKey:@"isLogin"];
                [ud setObject:[NSString stringWithFormat:@"%@",_userNameField.text] forKey:@"userName"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - ❀==============❂ 点击转跳注册页面 ❂==============❀
-(void)registRequest{
    RegistVC* registVC = [RegistVC new];
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    /*种类
     oglFlip：页面翻转（单页状态）
     cube:矩形翻转
     moveIn:渐入,  第二页在上，渐变进入覆盖效果
     reveal：揭示效果， 转跳页在下，第一页渐变走
     fade:默认渐变
     pageCurl:翻页  第一页翻开
     suckEffect:吸走  第一页被吸走
     rippleEffect:水波渐变
     */
    amin.type = @"moveIn";
    amin.subtype = kCATransitionFromBottom;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    [self.navigationController pushViewController:registVC animated:YES];
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
    amin.type = @"oglFlip";
    amin.subtype = kCATransitionFromRight;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}
#pragma mark - ❀==============❂ 导航栏隐藏 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:YES animated:YES];
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
