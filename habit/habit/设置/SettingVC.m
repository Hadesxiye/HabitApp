//
//  SettingVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/19.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "SettingVC.h"
#import "BaseTabBarViewController.h"
#import "LoginVC.h"
#import "DevelopingData.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _cellTitleArr;
    NSInteger loginState;
    UIButton* _avatarBtn;
    UILabel* _userName;
}
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBtn];
    _cellTitleArr = [NSMutableArray new];
    [self checkLogin];
    [self createTableView];
    
    
    // Do any additional setup after loading the view.
    
}
#pragma mark - ❀==============❂ 登录检查 ❂==============❀
-(void)checkLogin{
    [_cellTitleArr removeAllObjects];
    //定义一个用户默认数据对象
    //不需要alloc创建，用户默认数据对象单例模式
    //standardUserDefaults：获取全局唯一的实例对象
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    loginState =  [ud integerForKey:@"isLogin"];
    //先判断是否进行过初始化
    if (loginState==0) {
        WHZLog(@"未登录");
        _userName.text = @"当前未登录";
        _cellTitleArr = [NSMutableArray arrayWithObjects:@"登录",@"开发日志", nil];
    }
    //否则对isclick判断，
    else
    {
        NSString* temp = [ud objectForKey:@"userName"];
        _userName.text = temp;
        _cellTitleArr = [NSMutableArray arrayWithObjects:@"更改密码",@"更改昵称",@"意见反馈",@"开发日志",@"退出登录", nil];
        WHZLog(@"已登录");
    }
}
#pragma mark ヾ(=･ω･=)o============== 创建圆形button ==============Σ(((つ•̀ω•́)つ
-(void)createBtn
{
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"touXiang"];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    
    _avatarBtn = [[UIButton alloc]init];
    _avatarBtn.frame = CGRectMake( SC_WIDTH/2 - SC_WIDTH * 0.618/10 * 2.5, SC_WIDTH * 0.618/10 , SC_WIDTH * 0.618/5 * 2.5,SC_WIDTH * 0.618/5 * 2.5);  //把按钮设置成正方形
    _avatarBtn.layer.cornerRadius = SC_WIDTH * 0.618/10 * 2.5;  //设置按钮的拐角为宽的一半
    _avatarBtn.layer.borderWidth = 3;  // 边框的宽
    _avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;//边框的颜色
    _avatarBtn.layer.masksToBounds = YES;// 这个属性很重要，把超出边框的部分去除
    _avatarBtn.backgroundColor = myBackgroundColorBlue;
    [_avatarBtn setBackgroundImage:imgFromUrl3 forState:UIControlStateNormal];
    [_avatarBtn addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ❀==============❂ 更换头像功能 ❂==============❀
-(void)changePic{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    [_avatarBtn setBackgroundImage:newPhoto forState:UIControlStateNormal];
    //关闭当前界面，即回到主界面去
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/touXiang.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(newPhoto) writeToFile:imagePath atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ❀==============❂ 点击事件 ❂==============❀
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    //先判断是否进行过初始化
    loginState = [ud integerForKey:@"isLogin"];
    //未登录点击事件
    if (loginState==0) {
        //登录
        if (indexPath.row==0) {
            LoginVC* loginVC = [LoginVC new];
            
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
            amin.type = @"oglFlip";
            amin.subtype = kCATransitionFromLeft;
            amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.navigationController.view.layer addAnimation:amin forKey:nil];
            
            [self.navigationController pushViewController:loginVC animated:YES];

        }
        //开发日志
        else{
            DevelopingData* developVC = [DevelopingData new];
            [self.navigationController pushViewController:developVC animated:YES];
        }
    }
    
    
    //登录的点击事件
    else{
        if (indexPath.row==0) {
            //更改密码
            
        }
        else if (indexPath.row==1){
            //更改昵称
        }
        else if (indexPath.row==2){
            //意见反馈
            
        }
        else if (indexPath.row==3){
            //开发日志
            DevelopingData* developVC = [DevelopingData new];
            [self.navigationController pushViewController:developVC animated:YES];
        }
        else{
            //退出登录
            _userName.text = @"当前未登录";
            [ud setObject:0 forKey:@"isLogin"];
            [self checkLogin];
            [_tableView reloadData];
        }
        
    }
}
#pragma mark - ❀==============❂ tableview创建 ❂==============❀
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT - 20) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = SC_WIDTH * 0.618;
    _tableView.backgroundColor = myBackgroundColorWhite;
    
    //创建头视图
    UIView* HeadView = [[UIView alloc]init];
    _tableView.tableHeaderView = HeadView;
    HeadView.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    HeadView.backgroundColor = [UIColor whiteColor];
    UIImageView* background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundsBlue.jpg"]];
    background.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    
    //创建头视图的子控件
    _userName = [UILabel new];
    _userName.frame = CGRectMake( 0 , SC_WIDTH * 0.618/9 * 6.5, SC_WIDTH,SC_WIDTH * 0.618/9 * 2);
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont boldSystemFontOfSize:15];
    if (loginState==0) {
        _userName.text = @"当前未登录";
    }
    else{
        //standardUserDefaults：获取全局唯一的实例对象
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        NSString* temp = [ud objectForKey:@"userName"];
        _userName.text = temp;
    }
    _userName.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:35];
    _userName.textColor = [UIColor whiteColor];
    
    background.userInteractionEnabled = YES;

    [background addSubview:_userName];
    [background addSubview:_avatarBtn];
    [HeadView addSubview:background];
    
    [self.view addSubview:_tableView];
    //移除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}
//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_cellTitleArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:20];
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (loginState==0) {
        return 2;
    }
    else{
       return 5;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark ❀==============❂ tabbar动画 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [self checkLogin];
    [_tableView reloadData];
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:NO animated:YES];
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
