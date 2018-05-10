//
//  AddHabitVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/20.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
/*
 头视图 自定义图片
 cell  独特背景 habit name 只有textfield
 cell   告诉我原因鞭挞你自己   点击view上升动画
           label 原因
 cell   重复时间             点击view上升动画
           lable 周日到周六
 
 cell   提醒时间段           点击view上升动画
            label   早  中  晚
 
 
 
 
 
 
 
 */
#import "AddHabitVC.h"
#import "BaseTabBarViewController.h"
#import "Habits+CoreDataClass.h"
#import "HabitNameCell.h"
#import "AddHabitCell.h"
#import "CGXPickerView.h"
#import "MBProgressHUD.h"
#import <UserNotifications/UserNotifications.h>

@interface AddHabitVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UNUserNotificationCenterDelegate>
{
    UITableView* _tableView;
    UIButton* _habitPhotoBtn;
    UIButton* _habitDoneBtn;
    
    //addhabit页面参数
    NSMutableArray* _addHabitQuestionArr;
    NSMutableArray* _addHabitAnswerArr;
    
    //reasonview控件
    UILabel* _reasonTitleLab;
    UITextView* _reasonTextView;

    
    //repeatDateView控件循环创建btn  tag:200 - 206 周日 - 周六
    NSInteger getStrInt;
    NSString* tempStrAmi;

    
    //reminderView控件
    UIButton* _reminderMorningBtn;
    UIButton* _reminderNoonBtn;
    UIButton* _reminderAfternoonBtn;
    UIButton* _reminderEveingBtn;

    
    //数据容器
    //id = _habitNewIDStr
    
    NSMutableArray* _reasonArr;
    NSMutableArray* _repeaterDateArr;
    NSMutableArray* _reminderTimeArr;
    NSMutableArray* _habitExistIDArr;
    NSMutableArray* _habitExistURLArr;
    BOOL isError;
    
    NSString* _repeatDataStr;
    NSString* _reminderTimeStr;
    NSString* _reasonPhotoUrlStr;
    NSString* _habitNameStr;
    
    //细节视图
    UIView* _reasonView;
    UIView* _repeatDataView;
    UIView* _reminderView;
    
    NSManagedObjectContext *context;
    
}
@property (nonatomic, strong) UNMutableNotificationContent *notiContent;
@end

@implementation AddHabitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = myBackgroundColorWhite;
    // Do any additional setup after loading the view.
    
    self.notiContent = [[UNMutableNotificationContent alloc] init];
    //引入代理
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    
    self.title = @"新的习惯";
    [self getCoreData];
    
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"Font FamilyName = %@",familyName); //*输出字体族科名字
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"\t%@",fontName);         //*输出字体族科下字样名字
        }
    }
    
    
    //数据数组初始化
    _addHabitQuestionArr = [NSMutableArray arrayWithObjects:@"说吧卖屁股还是吃口屎",@"重复尝试的时间",@"发起提示的时间段", nil];
    _addHabitAnswerArr = [NSMutableArray arrayWithObjects:@"点击填写reason",@"周: 日 一 二 三 四 五 六",@"点击选择时间段", nil];
    _reasonArr = [NSMutableArray new];
    _repeaterDateArr = [NSMutableArray new];
    
    //最多支持三个 时间推送 初始为空
    _reminderTimeArr = [NSMutableArray new];
    
    
    
    
    [self setNavRightButton];
    [self createTableView];
    [self createHabitDoneBtn];
  
    
}
#pragma mark - ❀==============❂ 通知添加 ❂==============❀
- (void)regiterLocalNotification:(UNMutableNotificationContent *)content withHour:(NSInteger )timeHour withMinute:(NSInteger )timeMinute withTitle:(NSString *)titleStr subtitle:(NSString *)subtitleStr contentBody:(NSString *)bodyStr WithId:(NSString *)idStr{
    
    content.title = titleStr;
    content.subtitle = subtitleStr;
    content.body = bodyStr;
    content.badge = @1;
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
    content.sound = sound;
    
    NSArray* weekdayTempArr = [NSArray new];
    for (int i = 0; i < _repeaterDateArr.count; i++) {
        if ([_repeaterDateArr[i] isEqualToString:@"1"]) {
            <#statements#>
        }
    }
    
    //重复周期需要循环创建通知
    for (int i = 0; i < weekdayTempArr.count; i++) {
        WHZLog(@"weekday===%@",weekdayTempArr[i]);
        
        //重复提醒，时间间隔要大于60s
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.weekday = (NSInteger)weekdayTempArr[i];
        components.hour = timeHour;
        components.minute = timeMinute; // components 日期
        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        
    //    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        //设置通知id
        NSString *requertIdentifier = idStr;
        //根据id，内容和时间 设置通知请求
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:calendarTrigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error:%@",error);
        }];
    }
}
//只有当前处于前台才会走，加上返回方法，使在前台显示信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"执行willPresentNotificaiton");
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

#pragma mark - ❀==============❂ 创建tableview ❂==============❀
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = SC_WIDTH * 0.618;
    //颜色设置
    _tableView.backgroundColor = myBackgroundColorWhite;
    [self.view addSubview:_tableView];
    //移除多余cell
    [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    //移除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}
//创建头视图
#pragma mark - ❀==============❂ 头视图设置 ❂==============❀
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* HeadView = [[UIView alloc]init];
    //    _tableView.tableHeaderView = HeadView;
    HeadView.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    HeadView.backgroundColor = myBackgroundColorWhite;
    UIImageView* background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunshine.jpg"]];
    background.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    background.userInteractionEnabled = YES;
    
    
    // 拿到沙盒路径图片
    NSString *originalPath;
    UIImage *originalImgFromUrl;
    //判断是否存在id，存在则获取数据库的图片地址，不存在则显示默认图片
    [self inquireOperation];
    if (_habitExistIDArr.count == 0) {
        //显示默认图片
        originalImgFromUrl=[UIImage imageNamed:@"jungle.jpg"];
    }
    //存在则遍历
    else{
        NSInteger haveID = 0;
        for (int i = 0; i < _habitExistIDArr.count; i++) {
            //如果已存在id，选取对应path
            if ([_habitExistIDArr[i] isEqualToString:_habitNewIDStr]) {
                haveID = haveID + 1;
                originalPath = [NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),_habitNewIDStr];
                originalImgFromUrl=[[UIImage alloc]initWithContentsOfFile:originalPath];
            }
        }
        //遍历结束如果没有，显示默认图片
        if (haveID == 0) {
            originalImgFromUrl=[UIImage imageNamed:@"jungle.jpg"];
        }
    }
    
    
    
    _habitPhotoBtn = [UIButton new];
    _habitPhotoBtn.frame = CGRectMake(20, 20 * 0.618 , SC_WIDTH - 40 , SC_WIDTH * 0.618 - 40 * 0.618);
    _habitPhotoBtn.layer.cornerRadius = 10;
    _habitPhotoBtn.layer.borderWidth = 1;
    _habitPhotoBtn.layer.borderColor = myBackgroundColorGray.CGColor;
    _habitPhotoBtn.layer.masksToBounds = YES;
    
    _habitPhotoBtn.backgroundColor = myBackgroundColorPurple;
    
    [_habitPhotoBtn setBackgroundImage:originalImgFromUrl forState:UIControlStateNormal];
    [_habitPhotoBtn addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:_habitPhotoBtn];
    [HeadView addSubview:background];

    return HeadView;
}
#pragma mark - ❀==============❂ 更换头像功能 ❂==============❀
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
    [_habitPhotoBtn setBackgroundImage:newPhoto forState:UIControlStateNormal];
    //关闭当前界面，即回到主界面去
    
    NSString *path_sandox = NSHomeDirectory();
    
    //根据habit的id设置一个图片的存储路径
    NSString* tempPath = [NSString stringWithFormat:@"/Documents/%@.png",_habitNewIDStr];
    NSString *imagePath = [path_sandox stringByAppendingString:tempPath];
    
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(newPhoto) writeToFile:imagePath atomically:YES];
    
    //将path暂存，在全部完成时存入数据库
    _reasonPhotoUrlStr = [NSString stringWithFormat:@"%@",tempPath];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ❀==============❂ tableview代理协议 ❂==============❀
//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //habit name 60
    if (indexPath.row==0) {
        NSString* cellStr =[NSString stringWithFormat:@"cellID1"];
        HabitNameCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//        __weak typeof(self) weakSelf = self;
        if(cell==nil)
        {
            cell = [[HabitNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            
        }
        cell.block = ^(NSString * text) {
            // 更新数据源
            _habitNameStr = text;
        };
        cell.habitNameField.delegate = self;
        cell.habitNameField.textAlignment = NSTextAlignmentCenter;
        cell.habitNameField.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:35];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //80
    else if(indexPath.row < 4){
        
        NSString* cellStr =[NSString stringWithFormat:@"cellID2"];
        AddHabitCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell==nil)
        {
            cell = [[AddHabitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.questionLab.text = _addHabitQuestionArr[indexPath.row - 1];
            cell.questionLab.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:20];
            cell.questionLab.textColor = myBackgroundColorGray;
            cell.questionLab.textAlignment = NSTextAlignmentCenter;
            
            cell.answerLab.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:25];
            cell.answerLab.textAlignment = NSTextAlignmentCenter;
        }
        cell.answerLab.text = _addHabitAnswerArr[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString* cellStr =[NSString stringWithFormat:@"cellID3"];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            
        }
        cell.backgroundColor = myBackgroundColorWhite;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    HabitNameCell *customCell = (HabitNameCell *)cell;
//    customCell.habitNameField.placeholder = self.placeHolders[indexPath.row];
//    if (indexPath.section == 0) {
//        customCell.contentTextField.text = [self.contents objectAtIndex:indexPath.row];
//        // 必须有else!
//    } else {
//        // 切记：对于cell的重用，有if，就必须有else。因为之前屏幕上出现的cell离开屏幕被缓存起来时候，cell上的内容并没有清空，当cell被重用时，系统并不会给我们把cell上之前配置的内容清空掉，所以我们在else中对contentTextField内容进行重新配置或者清空（根据自己的业务场景而定）
//        customCell.contentTextField.text = [NSString stringWithFormat:@"第%ld组,第%ld行",indexPath.section,indexPath.row];
//    }
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60;
    }
    else if(indexPath.row < 4){
        return 100;
    }
    else{
        return 90;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //显示reasonView
    if (indexPath.row==1) {
        [self createReasonView];
        
    }
    //显示repeatView
    else if(indexPath.row==2){
        [self createRepeatDateView];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    //显示remindtimeview
    else if(indexPath.row==3){
        [self createReminderView];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        
    }
}
#pragma mark - ❀==============❂ 完成按钮 ❂==============❀
-(void)createHabitDoneBtn{
    _habitDoneBtn = [UIButton new];
    _habitDoneBtn.frame = CGRectMake(20, SC_HEIGHT - 70, SC_WIDTH - 40 , 50);
    _habitDoneBtn.layer.cornerRadius = 10;
    _habitDoneBtn.layer.borderWidth = 0.5;
    _habitDoneBtn.layer.borderColor = myBackgroundColorGray.CGColor;
    _habitDoneBtn.layer.masksToBounds = YES;
    [_habitDoneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    _habitDoneBtn.titleLabel.font =  [UIFont fontWithName:@"HYMiaoHunTiW" size:30];
    [_habitDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_habitDoneBtn setTitleColor:myBackgroundColorPurple forState:UIControlStateHighlighted];
    _habitDoneBtn.backgroundColor = [UIColor whiteColor];
    [_habitDoneBtn addTarget:self action:@selector(saveHabitInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_habitDoneBtn];

}
#pragma mark - ❀==============❂ 完成点击事件 ❂==============❀
-(void)saveHabitInformation{
    isError = NO;
    [self checkInformation];
    if (isError==YES) {
        return;
    }
    else{
        [self inquireOperation];
        NSString* reasonStr = [NSString stringWithFormat:@"%@",_reasonArr[0]];
        if (_habitExistIDArr.count == 0) {
            //插入操作
            
            [self insertOperationWithID:_habitNewIDStr name:_habitNameStr photoURL:_reasonPhotoUrlStr reason:reasonStr reminderTime:_repeatDataStr repeatData:_reminderTimeStr];
        }
        else{
            NSInteger haveID = 0;
            for (int i = 0; i < _habitExistIDArr.count; i++) {
                //如果已存在id，进行数据修改
                if ([_habitExistIDArr[i] isEqualToString:_habitNewIDStr]) {
                    haveID = haveID + 1;
                    [self modifyOperationWithID:_habitNewIDStr habitName:_habitNameStr reason:reasonStr photourl:_reasonPhotoUrlStr repeatData:_repeatDataStr reminderTime:_reminderTimeStr];
                }
            }
            //遍历结束如果没有，进行插入
            if (haveID == 0) {
                //插入操作
                NSString* reasonStr = [NSString stringWithFormat:@"%@",_reasonArr[0]];
                [self insertOperationWithID:_habitNewIDStr name:_habitNameStr photoURL:_reasonPhotoUrlStr reason:reasonStr reminderTime:_repeatDataStr repeatData:_reminderTimeStr];
            }
        }
        //创建通知
        [self createNotification];
        
        //执行完毕，进行转跳
        [self backHome];
    }
}
#pragma mark - ❀==============❂ 创建通知 ❂==============❀
-(void)createNotification{
    //获取 时间 habit名字 内容
    //存储时间数组 _reminderTimeArr
    //在每周一的14点3分提醒
 
    [self regiterLocalNotification:self.notiContent withHour:<#(NSInteger)#> withMinute:<#(NSInteger)#> withTitle:<#(NSString *)#> subtitle:<#(NSString *)#> contentBody:<#(NSString *)#> WithId:<#(NSString *)#>]
}
#pragma mark - ❀==============❂ 判读数据是否为空 ❂==============❀
-(void)checkInformation{
    if (_reasonArr.count==0) {
        [self textWaiting:[NSString stringWithFormat:@"原因都不写你能坚持么？？"]];
        isError = YES;
        return;
    }
    NSString* reasonStr = [NSString stringWithFormat:@"%@",_reasonArr[0]];
//    [self insertOperationWithID:_habitNewIDStr name:_habitNameStr photoURL:_reasonPhotoUrlStr reason:reasonStr reminderTime:_repeatDataStr repeatData:_reminderTimeStr];
    if (_habitNameStr==nil||[_habitNameStr isEqualToString:@""]) {
        [self textWaiting:[NSString stringWithFormat:@"名字都没有？你想做啥"]];
        isError = YES;
        return;
    }
    else if (_reasonPhotoUrlStr==nil){
        [self textWaiting:[NSString stringWithFormat:@"照片路径为空"]];
        isError = YES;
        return;
    }
    else if (reasonStr==nil||[reasonStr isEqualToString:@""]){
        [self textWaiting:[NSString stringWithFormat:@"原因都不写你能坚持么？？"]];
        isError = YES;
        return;
    }
    else if ([_repeatDataStr isEqualToString:@"请选择重复时间"]){
        [self textWaiting:[NSString stringWithFormat:@"一天都不选？？"]];
        isError = YES;
        return;
    }
    else if ([_reminderTimeStr isEqualToString:@"点击选择时间段"]){
        [self textWaiting:[NSString stringWithFormat:@"提醒时间呢？？"]];
        isError = YES;
        return;
    }
    else{
        WHZLog(@"信息核对无误！通过！");
    }
    

}
#pragma mark ❀==============❂ coredata数据存储 ❂==============❀
-(void)getCoreData{
    // 创建上下文对象，并发队列设置为主队列
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 创建托管对象模型，并使用.xcdatamodeled前缀路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"HabitCoredata" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"HabitCoredata"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
}
#pragma mark ❀==============❂ 插入操作 ❂==============❀
-(void)insertOperationWithID:(NSString *)habitID name:(NSString *)name photoURL:(NSString *)url reason:(NSString *)reason reminderTime:(NSString *)reminder repeatData:(NSString *)repeat{
    // 创建托管对象，并指明创建的托管对象所属实体名
    
    Habits *habits = [NSEntityDescription insertNewObjectForEntityForName:@"Habits" inManagedObjectContext:context];
    
    habits.habitID = habitID;
    habits.habitDidAmount = [NSString stringWithFormat:@"0"];
    habits.habitNotDoAmount = [NSString stringWithFormat:@"0"];
    habits.habitName = name;
    habits.habitPhotoURL = url;
    habits.habitReason = reason;
    habits.habitReminderTime = reminder;
    habits.habitRepeatData = repeat;

    
    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}
#pragma mark ❀==============❂ 删除操作 ❂==============❀
-(void)deleteOperationWithIDArr:(NSString *)IDstr{
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
   
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitID = %@",IDstr];
        request.predicate = predicate;
        // 执行获取操作，找到要删除的对象
        NSError* error = nil;
        NSArray *employees = [context executeFetchRequest:request error:&error];
        // 遍历符合删除要求的对象数组，执行删除操作
        [employees enumerateObjectsUsingBlock:^(Habits * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [context deleteObject:obj];
        }];
        // 保存上下文
        if (context.hasChanges) {
            [context save:nil];
        }
        // 错误处理
        if (error) {
            NSLog(@"CoreData Delete Data Error : %@", error);
        }
    
}
#pragma mark ❀==============❂ 修改操作 ❂==============❀
-(void)modifyOperationWithID:(NSString *)habitID habitName:(NSString *)name reason:(NSString *)reason photourl:(NSString *)picURL repeatData:(NSString *)repeatData reminderTime:(NSString *)reminderTime{
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitID = %@", _habitNewIDStr];
    request.predicate = predicate;
    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Habits * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //次数不修改
        obj.habitName = name;
        obj.habitReason = reason;
        obj.habitPhotoURL = picURL;
        obj.habitRepeatData = repeatData;
        obj.habitReminderTime = reminderTime;
        
    }];
    // 将上面的修改进行存储
    if (context.hasChanges) {
        [context save:nil];
    }
    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
}
#pragma mark ❀==============❂ 查询操作并给数组赋值 ❂==============❀
-(void)inquireOperation{
    //先判断id是否存在，再进行修改或者插入
    _habitExistIDArr = [NSMutableArray new];
    _habitExistURLArr = [NSMutableArray new];
    [_habitExistIDArr removeAllObjects];
    [_habitExistURLArr removeAllObjects];
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Habits * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        
        [_habitExistIDArr addObject:obj.habitID];
        [_habitExistURLArr addObject:obj.habitPhotoURL];

        NSLog(@"id : %@", obj.habitID);
        
    }];
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
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
-(void)backHome{
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    /*种类
     oglFlip：页面翻转（单页状态）
     cube:矩形翻转
     moveIn:渐入,  第二页在上，渐变进入覆盖效果
     reveal：揭示效果， 转跳页在下，第一页渐变走
     fade:默认渐变
     pageCurl:翻书页  第一页翻开
     suckEffect:吸走  第一页被吸走
     rippleEffect:水波渐变
     */
    amin.type = @"oglFlip";
    amin.subtype = kCATransitionFromBottom;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
#pragma mark - ❀==============❂ 导航栏隐藏 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:YES animated:YES];
}

#pragma mark - ❀==============❂ 填写原因的view ❂==============❀
-(void)createReasonView{
    NSLog(@"显示reasonview，填写reason");
    _reasonView = [UIView new];
    _reasonView.frame = CGRectMake( 0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT);
    
    //毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _reasonView.bounds.size.width,_reasonView.bounds.size.height );
    [_reasonView addSubview:effectView];
    
    _reasonTitleLab = [UILabel new];
    _reasonTitleLab.text = @"写点什么 my friend";
    _reasonTitleLab.textColor = myBackgroundColorWhite;
    _reasonTitleLab.numberOfLines = 0;
    _reasonTitleLab.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:30];
    _reasonTitleLab.textAlignment = NSTextAlignmentCenter;
    _reasonTitleLab.frame = CGRectMake(0, SC_HEIGHT/2 - 200, SC_WIDTH, 50);
//    _reasonTitleLab.backgroundColor = myBackgroundColorPurple;
    [_reasonView addSubview:_reasonTitleLab];
    
    _reasonTextView = [UITextView new];
    _reasonTextView.frame = CGRectMake(20, SC_HEIGHT/2 - 100, SC_WIDTH - 40, 300);
    
    _reasonTextView.delegate = self;
    _reasonTextView.backgroundColor = [UIColor clearColor];
    _reasonTextView.returnKeyType = UIReturnKeyDone;
    _reasonTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _reasonTextView.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:30];
    
    if (_reasonArr.count!=0) {
        _reasonTextView.text = [NSString stringWithFormat:@"%@",_reasonArr[0]];
    }
    else{
        
    }
    [_reasonView addSubview:_reasonTextView];
    
    UIButton* closeBtn = [UIButton new];
    closeBtn.frame = CGRectMake(20, SC_HEIGHT - 70, SC_WIDTH/2 -40, 50);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
//    closeBtn.backgroundColor = myBackgroundColorBlue;
    [closeBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeReasonView:) forControlEvents:UIControlEventTouchUpInside];
    [_reasonView addSubview:closeBtn];
    
    UIButton* _doneBtn = [UIButton new];
    _doneBtn.frame = CGRectMake(SC_WIDTH/2 + 20, SC_HEIGHT - 70, SC_WIDTH/2 - 40, 50);
    _doneBtn.tag = 100;
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
//    _doneBtn.backgroundColor = myBackgroundColorBlue;
    [_doneBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(closeReasonView:) forControlEvents:UIControlEventTouchUpInside];
    [_reasonView addSubview:_doneBtn];
    
    [self.view addSubview:_reasonView];
    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _reasonView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
  
}
-(void)closeReasonView:(UIButton *)btn{
    if (btn.tag==100) {
        //将数据暂存数组
        [_reasonArr removeAllObjects];
        [_reasonArr addObject:_reasonTextView.text];
        NSLog(@"%@",_reasonTextView.text);
        //对tableview进行刷新修改
        [_addHabitAnswerArr replaceObjectAtIndex:0 withObject:@"已保存，点击再吃一口=。="];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    }
    else{
        NSLog(@"取消输入");
    }
    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        _reasonView.frame = CGRectMake( 0 , SC_HEIGHT, 0, 0);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
        [_reasonView removeFromSuperview];
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - ❀==============❂ 选择重复日期view ❂==============❀
-(void)createRepeatDateView{
    NSLog(@"选择重复时间");
    //周日到周丽 1 为开启左边 0 为关闭右边
    _repeaterDateArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    
    _repeatDataView = [UIView new];
    _repeatDataView.frame = CGRectMake( 0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT);
    
    //毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _repeatDataView.bounds.size.width,_repeatDataView.bounds.size.height );
    [_repeatDataView addSubview:effectView];
    
    //完成和关闭按钮
    UIButton* closeBtn = [UIButton new];
    closeBtn.frame = CGRectMake(20, SC_HEIGHT - 70, SC_WIDTH/2 -40, 50);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    //    closeBtn.backgroundColor = myBackgroundColorBlue;
    [closeBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeRepeatView:) forControlEvents:UIControlEventTouchUpInside];
    [_repeatDataView addSubview:closeBtn];
    
    UIButton* _doneBtn = [UIButton new];
    _doneBtn.frame = CGRectMake(SC_WIDTH/2 + 20, SC_HEIGHT - 70, SC_WIDTH/2 - 40, 50);
    _doneBtn.tag = 101;
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    //    _doneBtn.backgroundColor = myBackgroundColorBlue;
    [_doneBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(closeRepeatView:) forControlEvents:UIControlEventTouchUpInside];
    [_repeatDataView addSubview:_doneBtn];
    
    //日期选择btn 200开始
    NSArray* _repeatWeekBtnTitleArr0 = [NSArray arrayWithObjects:@"周日开启",@"周一开启",@"周二开启",@"周三开启",@"周四开启",@"周五开启",@"周六开启", nil];
    NSArray* _repeatWeekBtnTitleArr1 = [NSArray arrayWithObjects:@"周日关闭",@"周一关闭",@"周二关闭",@"周三关闭",@"周四关闭",@"周五关闭",@"周六关闭", nil];
    for (int i = 0; i < 7 ; i ++) {
        UIButton* _repeatWeekBtn = [UIButton new];
        _repeatWeekBtn.tag = 200 + i;
        _repeatWeekBtn.frame = CGRectMake(20, 20 + (_repeatWeekBtn.tag - 200) * 70, 100, 50);
        //选中为关闭，未选中为开启
        [_repeatWeekBtn setTitle:[NSString stringWithFormat:@"%@",_repeatWeekBtnTitleArr0[i]] forState:UIControlStateNormal];
        [_repeatWeekBtn setTitle:[NSString stringWithFormat:@"%@",_repeatWeekBtnTitleArr1[i]] forState:UIControlStateSelected];
        [_repeatWeekBtn addTarget:self action:@selector(weekBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatDataView addSubview:_repeatWeekBtn];
    }
   
    [self.view addSubview:_repeatDataView];
    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{

        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _repeatDataView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
    }];
    
}
-(void)weekBtn:(UIButton *)btn{
    WHZLog(@"%ld",btn.tag);
    //获取tag值，改变存储btn位置状态的数组中的元素
    NSInteger tempBtnTag = btn.tag - 200;
    //取出数组中表示btn位置状态的元素 0在左边 1在右边
    tempStrAmi = [NSString stringWithFormat:@"%@",_repeaterDateArr[tempBtnTag]];
    WHZLog(@"%@",tempStrAmi);
    getStrInt = tempStrAmi.integerValue;
    
    //根据取到的元素，判断btn向左还是向右移动 1向右 0向左
    if (getStrInt==0) {
        UIButton *find_btn = (UIButton *)[self.view viewWithTag:btn.tag];

        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
            //控件操作
            find_btn.selected = NO;
            find_btn.frame = CGRectMake(20, 20 + tempBtnTag * 70, 100, 50);
       
        } completion:^(BOOL finished) {
    
            if (finished) {
                getStrInt = 1;
                tempStrAmi = [NSString stringWithFormat:@"%ld",getStrInt];
                //替换数据
                [_repeaterDateArr replaceObjectAtIndex:tempBtnTag withObject:tempStrAmi];
                WHZLog(@"%@",_repeaterDateArr);
            }
            
        }];
    }
    else{
        
        UIButton *find_btn = (UIButton *)[self.view viewWithTag:btn.tag];

        [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
            //控件操作
            find_btn.selected = YES;
            find_btn.frame = CGRectMake(200 , 20 + tempBtnTag * 70, 100, 50);
            
        } completion:^(BOOL finished) {
  
            if (finished) {
                getStrInt = 0;
                tempStrAmi = [NSString stringWithFormat:@"%ld",getStrInt];
                //替换数据
                [_repeaterDateArr replaceObjectAtIndex:tempBtnTag withObject:tempStrAmi];
                WHZLog(@"%@",_repeaterDateArr);
            }
        }];
    }
}
-(void)closeRepeatView:(UIButton *)btn{
    //选择日期的btn
    if (btn.tag==101) {
        //对数组内数据做判断，拼接字符串
        NSMutableString* tempStr = [NSMutableString stringWithFormat:@"周: "];
        NSArray* dataStrArr = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        NSInteger weekTimes = 0;
        for (int i = 0; i < _repeaterDateArr.count; i ++) {
            NSString* temp1 = [NSString stringWithFormat:@"%@",_repeaterDateArr[i]];
            if ([temp1 isEqualToString:@"1"]) {
                [tempStr appendString:[NSString stringWithFormat:@"%@ ",dataStrArr[i]]];
                WHZLog(@"tempstr==%@",tempStr);
                weekTimes = weekTimes + 1;
            }
        }
        if (weekTimes==0) {
            tempStr = [NSMutableString stringWithFormat:@"请选择重复时间"];
        }
        //数据处理完毕刷新tableview
        _repeatDataStr = tempStr;
        [_addHabitAnswerArr replaceObjectAtIndex:1 withObject:tempStr];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    }
    else{
        NSLog(@"取消选择");
    }

    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{

        _repeatDataView.frame = CGRectMake( 0 , SC_HEIGHT, 0, 0);

    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
        [_repeatDataView removeFromSuperview];
    }];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - ❀==============❂ 选择提醒时段view ❂==============❀
-(void)createReminderView{
    NSLog(@"选择提醒时段");
    _reminderView = [UIView new];
    _reminderView.frame = CGRectMake( 0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT);
    //毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _reminderView.bounds.size.width,_reminderView.bounds.size.height );
    [_reminderView addSubview:effectView];
    
    //完成和关闭按钮
    UIButton* closeBtn = [UIButton new];
    closeBtn.frame = CGRectMake(20, SC_HEIGHT - 70, SC_WIDTH/2 -40, 50);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    //    closeBtn.backgroundColor = myBackgroundColorBlue;
    [closeBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeReminderView:) forControlEvents:UIControlEventTouchUpInside];
    [_reminderView addSubview:closeBtn];
    
    UIButton* _doneBtn = [UIButton new];
    _doneBtn.frame = CGRectMake(SC_WIDTH/2 + 20, SC_HEIGHT - 70, SC_WIDTH/2 - 40, 50);
    _doneBtn.tag = 102;
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    //    _doneBtn.backgroundColor = myBackgroundColorBlue;
    [_doneBtn setTitleColor:myBackgroundColorWhite forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(closeReminderView:) forControlEvents:UIControlEventTouchUpInside];
    [_reminderView addSubview:_doneBtn];
    
    //三个时间选择
    UIButton* _reminderTimeOne = [UIButton new];
    UIButton* _reminderTimeTwo = [UIButton new];
    UIButton* _reminderTimeThree = [UIButton new];
    
    _reminderTimeOne.frame = CGRectMake(20, 100, SC_WIDTH - 40, 30);
    _reminderTimeTwo.frame = CGRectMake(20, 150, SC_WIDTH - 40, 30);
    _reminderTimeThree.frame = CGRectMake(20, 200, SC_WIDTH - 40, 30);
    
    _reminderTimeOne.tag = 300;
    _reminderTimeTwo.tag = 301;
    _reminderTimeThree.tag = 302;
    
    [_reminderTimeOne setTitle:@"点击选择时间一" forState:UIControlStateNormal];
    [_reminderTimeTwo setTitle:@"点击选择时间二" forState:UIControlStateNormal];
    [_reminderTimeThree setTitle:@"点击选择时间三" forState:UIControlStateNormal];
    
    _reminderTimeOne.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:20];
    _reminderTimeTwo.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:20];
    _reminderTimeThree.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:20];
    
    
    [_reminderTimeOne addTarget:self action:@selector(chooseRemiderTime:) forControlEvents:UIControlEventTouchUpInside];
    [_reminderTimeTwo addTarget:self action:@selector(chooseRemiderTime:) forControlEvents:UIControlEventTouchUpInside];
    [_reminderTimeThree addTarget:self action:@selector(chooseRemiderTime:) forControlEvents:UIControlEventTouchUpInside];
    
    [_reminderView addSubview:_reminderTimeOne];
    [_reminderView addSubview:_reminderTimeTwo];
    [_reminderView addSubview:_reminderTimeThree];
    
    _reminderTimeArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    [self.view addSubview:_reminderView];
    
    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        _reminderView.frame = CGRectMake( 0 , 0, SC_WIDTH, SC_HEIGHT);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
        
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
-(void)chooseRemiderTime:(UIButton *)btn{
    [CGXPickerView showDatePickerWithTitle:@"提醒时刻" DateType:UIDatePickerModeTime DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        
        [btn setTitle:selectValue forState:UIControlStateNormal];
        if (btn.tag==300) {
            [_reminderTimeArr replaceObjectAtIndex:0 withObject:selectValue];
        }
        else if (btn.tag==301){
            [_reminderTimeArr replaceObjectAtIndex:1 withObject:selectValue];
        }
        else{
            [_reminderTimeArr replaceObjectAtIndex:2 withObject:selectValue];
        }
        WHZLog(@"remindtimearr===%@",_reminderTimeArr);
    }];
}
-(void)closeReminderView:(UIButton *)btn{
    if (btn.tag==102) {
        //对数组内数据做判断，拼接字符串
        NSMutableString* tempStr = [NSMutableString stringWithFormat:@"选择了："];
        NSInteger noTime = 0;
        for (int i = 0; i < _reminderTimeArr.count; i++) {
            NSString* tempTimeStr = [NSString stringWithFormat:@"%@",_reminderTimeArr[i]];
            if ([tempTimeStr isEqualToString:@""]) {
                noTime = noTime + 1;
            }
            else{
                //字符串拼接
                [tempStr appendString:[NSString stringWithFormat:@"%@ ",tempTimeStr]];
            }
        }
        
        WHZLog(@"tempstr==%@",tempStr);
        //如果三个都是空
        if (noTime==3) {
            tempStr = [NSMutableString stringWithFormat:@"点击选择时间段"];
        }
        //数据处理完毕刷新tableview
        _reminderTimeStr = tempStr;
        [_addHabitAnswerArr replaceObjectAtIndex:2 withObject:tempStr];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else{
        //选择取消则将数组制空
        _reminderTimeArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
        NSLog(@"取消选择");
    }
    
    [UIView animateWithDuration:0.618 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{
        
        _reminderView.frame = CGRectMake( 0 , SC_HEIGHT, 0, 0);
        
    } completion:^(BOOL finished) {
        NSLog(@"动画结束");
        [_reminderView removeFromSuperview];
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_reasonTextView resignFirstResponder];
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
