//
//  HabitVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/19.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "HabitVC.h"
#import "AddHabitVC.h"
#import "HabitCell.h"
#import "BaseTabBarViewController.h"
#import "Habits+CoreDataClass.h"

@interface HabitVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    
    //存储coredata数据数组
    //使用查询，删除操作
    NSManagedObjectContext* context;
    NSMutableArray* _habitIDArr;
    NSMutableArray* _habitNameArr;
    NSMutableArray* _habitDidAmountArr;
    NSMutableArray* _habitNotDoAmountArr;
    NSMutableArray* _habitPhotoUrlArr;
    NSMutableArray* _habitReasonArr;
    NSMutableArray* _habitRepeatDataArr;
    NSMutableArray* _habitReminderTimeArr;
    NSString* _habitMaxIDStr;
    
    UIView* _habitDetailView;
    
    
}

@end

@implementation HabitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - ❀==============❂ 检测数据 判断是否提示添加habit界面 ❂==============❀
-(void)reminderAddHabit{
    if (_habitIDArr.count==0) {
        NSLog(@"当前无habit，添加pls");
    }
    else{
        WHZLog(@"有数据");
    }
}
#pragma mark - ❀==============❂ 设置导航栏右侧及返回按钮按钮 ❂==============❀
-(void)setNavRightButton
{
    UIBarButtonItem* rigthBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHabit)];
    
    self.navigationItem.rightBarButtonItem  = rigthBtn;
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}
#pragma mark - ❀==============❂ tableview创建 ❂==============❀
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT - 20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = SC_WIDTH * 0.618;
    _tableView.backgroundColor = myBackgroundColorWhite;
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}
// 必须写的方法（否则iOS 8无法删除，iOS 9及其以上不写没问题），和editActionsForRowAtIndexPath配对使用，里面什么不写也行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - ❀==============❂ cell点击事件 ❂==============❀
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - ❀==============❂ 点击显示habitdetail 300❂==============❀
-(void)showHabitDetail:(UIButton *)btn{
    NSInteger rowNum = btn.tag - 300;
    [self createHabitDetailWithRow:rowNum];
}
#pragma mark - ❀==============❂ habit详情页面 ❂==============❀
-(void)createHabitDetailWithRow:(NSInteger )row{
  
    
    _habitDetailView = [UIView new];
    _habitDetailView.frame = CGRectMake(0, 0, SC_WIDTH , SC_HEIGHT);
    _habitDetailView.backgroundColor = myBackgroundColorBlue;
    
    //标题
    UILabel* _habitDetailName = [UILabel new];
    _habitDetailName.frame = CGRectMake(0, 100, SC_WIDTH, 50);
    _habitDetailName.text = [NSString stringWithFormat:@"%@",_habitNameArr[row]];
    _habitDetailName.textAlignment = NSTextAlignmentCenter;
    _habitDetailName.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    _habitDetailView.alpha = 0;
    
    //照片
    NSString *originalPath;
    UIImage *originalImgFromUrl;
    originalPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),_habitPhotoUrlArr[row]];
    originalImgFromUrl=[[UIImage alloc]initWithContentsOfFile:originalPath];
    UIImageView* _habitDetailPhoto = [[UIImageView alloc]initWithImage:originalImgFromUrl];
    _habitDetailPhoto.frame = CGRectMake(20, SC_HEIGHT, SC_WIDTH - 40, (SC_WIDTH - 40) * 0.618 );
    
    
    //原因
    UILabel* _habitDetailReason = [UILabel new];
    _habitDetailReason.frame = CGRectMake(30, SC_HEIGHT - 300, SC_WIDTH - 60, 200);
    _habitDetailReason.textAlignment = NSTextAlignmentCenter;
    _habitDetailReason.numberOfLines = 0;
    _habitDetailReason.text = [NSString stringWithFormat:@"%@",_habitReasonArr[row]];
    _habitDetailReason.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:30];
    _habitDetailReason.textColor = [UIColor whiteColor];
    [_habitDetailView addSubview:_habitDetailReason];
    
    //提醒周期和时间
    UILabel* _repeatDateLabel = [UILabel new];
    _repeatDateLabel.frame = CGRectMake(20, SC_HEIGHT - 150, SC_WIDTH/2 - 20, 30);
    _repeatDateLabel.text = [NSString stringWithFormat:@"提醒时间 %@",_habitRepeatDataArr[0]];
    _repeatDateLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:15];
    
    UILabel* _reminderTimeLabel = [UILabel new];
    _reminderTimeLabel.frame = CGRectMake(SC_WIDTH/2 , SC_HEIGHT - 150, SC_WIDTH/2 - 20, 30);
    _reminderTimeLabel.text = [NSString stringWithFormat:@"重复于 %@",_habitReminderTimeArr[0]];
    _reminderTimeLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:15];
    _reminderTimeLabel.textAlignment = NSTextAlignmentRight;
    
    [_habitDetailView addSubview:_repeatDateLabel];
    [_habitDetailView addSubview:_reminderTimeLabel];
    
    UIButton* _habitDetailCloseBtn = [UIButton new];
    _habitDetailCloseBtn.frame = CGRectMake(20, SC_HEIGHT, SC_WIDTH - 40, 50);
    _habitDetailCloseBtn.backgroundColor = myBackgroundColorPurple;
    [_habitDetailCloseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_habitDetailCloseBtn addTarget:self action:@selector(closeHabitDetailView) forControlEvents:UIControlEventTouchUpInside];
    _habitDetailCloseBtn.titleLabel.font = [UIFont fontWithName:@"HYMiaoHunTiW" size:40];
    [_habitDetailView addSubview:_habitDetailName];

        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:(UIViewAnimationOptionCurveLinear) animations:^{

            _habitDetailPhoto.frame = CGRectMake(20, 150, SC_WIDTH - 40, (SC_WIDTH - 40) * 0.618 );
            [_habitDetailView addSubview:_habitDetailPhoto];
            _habitDetailCloseBtn.frame = CGRectMake(20, SC_HEIGHT - 100, SC_WIDTH - 40, 50);
            [_habitDetailView addSubview:_habitDetailCloseBtn];

        } completion:^(BOOL finished) {
            NSLog(@"动画结束");
        }];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown  animations:^{
        //tabbar隐藏
        _habitDetailView.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
        _habitDetailView.alpha = 1;
        [[BaseTabBarViewController sharedController] hidesTabBar:YES animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view addSubview:_habitDetailView];
    } completion:^(BOOL finished) {
        
    }];

}
-(void)closeHabitDetailView{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown  animations:^{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[BaseTabBarViewController sharedController] hidesTabBar:NO animated:YES];
        _habitDetailView.frame = CGRectMake(0, SC_HEIGHT, SC_WIDTH, SC_HEIGHT);
        _habitDetailView.alpha = 0;
        [self.view addSubview:_habitDetailView];
    } completion:^(BOOL finished) {
        [_habitDetailView removeFromSuperview];
    }];
    
}
#pragma mark - ❀==============❂ 自定义侧滑 ❂==============❀
// 添加自定义的侧滑功能
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //先获取id，删除数据库数据
        NSString* habitDeleteID = [NSString stringWithFormat:@"%@",_habitIDArr[indexPath.row]];
        [self deleteOperationWith:habitDeleteID];
        
        // 再移除数据源数据
        [_habitIDArr removeObjectAtIndex:indexPath.row];
        [_habitNameArr removeObjectAtIndex:indexPath.row];
        [_habitDidAmountArr removeObjectAtIndex:indexPath.row];
        [_habitNotDoAmountArr removeObjectAtIndex:indexPath.row];
        [_habitPhotoUrlArr removeObjectAtIndex:indexPath.row];
        [_habitReasonArr removeObjectAtIndex:indexPath.row];
        [_habitRepeatDataArr removeObjectAtIndex:indexPath.row];
        [_habitReminderTimeArr removeObjectAtIndex:indexPath.row];
        
        // 再动态刷新UITableView
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"删除数据");
    }];
    //修改按钮
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //获取这行的id，传递给下一页,转跳
        NSLog(@"编辑");
        AddHabitVC* habit = [AddHabitVC new];
        
        NSString* habitIDInRow = [NSString stringWithFormat:@"%@",_habitIDArr[indexPath.row]];
        habit.habitNewIDStr = habitIDInRow;
        
        CATransition* amin = [CATransition animation];
        amin.duration = 0.5;
        amin.type = @"oglFlip";
        amin.subtype = kCATransitionFromRight;
        amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.navigationController.view.layer addAnimation:amin forKey:nil];
        
        [self.navigationController pushViewController:habit animated:YES];
        
    }];
    /// 设置按钮颜色，Normal默认是灰色的，Default默认是红色的
    editRowAction.backgroundColor = myBackgroundColorBlue;
    
    return @[deleteRowAction,editRowAction];
}
//创建头视图
#pragma mark - ❀==============❂ 头视图设置 ❂==============❀
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* HeadView = [[UIView alloc]init];
//    _tableView.tableHeaderView = HeadView;
    HeadView.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    HeadView.backgroundColor = myBackgroundColorGray;
    UIImageView* background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunshine.jpg"]];
    background.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    
    background.userInteractionEnabled = YES;
    
    UILabel* habitNum = [UILabel new];
    habitNum.frame = CGRectMake(20, 20, SC_WIDTH, 20);
    
    
 
    return HeadView;
}

#pragma mark - ❀==============❂ tableview代理协议 ❂==============❀
//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    HabitCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[HabitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
    }
#pragma mark - ❀==============❂ 加按钮tag200起 减按钮tag100起 detaiBtn300起❂==============❀
    cell.addBtn.tag = 200 + indexPath.row;
    cell.minBtn.tag = 100 + indexPath.row;
    cell.habitDetailBtn.tag = 300 + indexPath.row;
    
    [cell.habitDetailBtn addTarget:self action:@selector(showHabitDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minBtn addTarget:self action:@selector(habitAmountMin:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(habitAmountAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    //cell数据设置
    cell.habitNameLab.text = [NSString stringWithFormat:@"%@",_habitNameArr[indexPath.row]];
    cell.didAmountLab.text = [NSString stringWithFormat:@"+%@",_habitDidAmountArr[indexPath.row]];
    cell.notDoAmountLab.text = [NSString stringWithFormat:@"-%@",_habitNotDoAmountArr[indexPath.row]];
    
    //cell背景颜色设置 根据did和not的结果做判断 点击按钮时刷新 点击cell显示habit详情
//    [cell.backgroundImageView setImage:[UIImage imageNamed:@""]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//btn点击事件，先刷新数据库，在刷新数据源，在刷新列表 add100起 min200起
-(void)habitAmountMin:(UIButton *)btn{
    NSInteger numOfRow = btn.tag - 100;
    WHZLog(@"numberofrow min===%ld",numOfRow);
    
    //修改数据库
    //先获取habitID
    NSString* habitIDStr = [NSString stringWithFormat:@"%@",_habitIDArr[numOfRow]];
    WHZLog(@"habitID min==%@",habitIDStr);
    
    NSString* tempMinAmount = [NSString stringWithFormat:@"%@",_habitNotDoAmountArr[numOfRow]];
    NSInteger temp = tempMinAmount.integerValue + 1;
    tempMinAmount = [NSString stringWithFormat:@"%ld",temp];
    //修改数据库
    [self modifyOperationWithHabitID:habitIDStr minAmount:tempMinAmount addAmount:[NSString stringWithFormat:@""]];
    //修改数据源
    [_habitNotDoAmountArr replaceObjectAtIndex:numOfRow withObject:tempMinAmount];
    //刷新对应cell
    NSUInteger section = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfRow inSection:section];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)habitAmountAdd:(UIButton *)btn{
    NSInteger numOfRow = btn.tag - 200;
    WHZLog(@"numberofrow add===%ld",numOfRow);
    
    //修改数据库
    //先获取habitID
    NSString* habitIDStr = [NSString stringWithFormat:@"%@",_habitIDArr[numOfRow]];
    WHZLog(@"habitID add==%@",habitIDStr);
    
    NSString* tempAddAmount = [NSString stringWithFormat:@"%@",_habitDidAmountArr[numOfRow]];
    NSInteger temp = tempAddAmount.integerValue + 1;
    tempAddAmount = [NSString stringWithFormat:@"%ld",temp];
    //修改数据库
    [self modifyOperationWithHabitID:habitIDStr minAmount:[NSString stringWithFormat:@""] addAmount:tempAddAmount];
    //修改数据源
    [_habitDidAmountArr replaceObjectAtIndex:numOfRow withObject:tempAddAmount];
    //刷新对应cell
    NSUInteger section = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numOfRow inSection:section];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _habitIDArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - ❀==============❂ 导航栏动画 ❂==============❀
-(void)addHabit{
    AddHabitVC* habit = [AddHabitVC new];
    
    //查询最大habitid ，传递修改或者添加
    [self inquireOperation];
    NSInteger maxID = 0;
    for (int i = 0; i < _habitIDArr.count; i++) {
        NSString* tempStr = [NSString stringWithFormat:@"%@",_habitIDArr[i]];
        NSInteger tempID = tempStr.integerValue;
        if (maxID < tempID) {
            maxID = tempID;
        }
    }
    WHZLog(@"mxid===%ld",maxID);
    
    habit.habitNewIDStr = [NSString stringWithFormat:@"%ld",maxID + 1];
    
    WHZLog(@"createNewid = %@",habit.habitNewIDStr);

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
    amin.subtype = kCATransitionFromTop;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    [self.navigationController pushViewController:habit animated:YES];

}
#pragma mark - ❀==============❂ 初始化userdefault的habitID  添加和修改前调用 获取最大ID给_habitMaxIDStr ❂==============❀
-(void)initHabitID{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if (_habitIDArr.count==0) {
        [ud setObject:@"0" forKey:@"habitID"];
        [ud synchronize];
    }
    else{
        NSInteger tempNum = 0;
        for (int i = 0; i < _habitIDArr.count; i ++) {
            NSString* tempStr = [NSString stringWithFormat:@"%@",_habitIDArr[i]];
            //获取最大habitID
            if (tempNum < tempStr.integerValue) {
                tempNum = tempStr.integerValue;
            }
            else{
                tempNum = tempNum;
            }
        }
        _habitMaxIDStr = [NSString stringWithFormat:@"%ld",tempNum];
        
        NSLog(@"maxHabitID = %ld   max= %@",tempNum,_habitMaxIDStr);
    }
    
}
#pragma mark - ❀==============❂ coreData ❂==============❀
-(void)getData{
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
#pragma mark ❀==============❂ 插入操作在addhabit实现 参数 photoURL name reason ❂==============❀
-(void)insertOperationWithURL:(NSString* )urlStr Name:(NSString *)nameStr Reason:(NSString* )reasonStr{
    // 创建托管对象，并指明创建的托管对象所属实体名
    Habits *habitsEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Habits" inManagedObjectContext:context];
    
    habitsEntity.habitPhotoURL = urlStr;
    habitsEntity.habitName = nameStr;
    habitsEntity.habitReason = reasonStr;
    //初始化did和not do都为0；
    habitsEntity.habitDidAmount = @"0";
    habitsEntity.habitNotDoAmount = @"0";
    
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
-(void)deleteOperationWith:(NSString *)idStr{
    // 建立获取数据的请求对象，指明对Employee实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitID = %@", idStr];
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
#pragma mark ❀==============❂ 修改操作 加则减传@“” 减则加传@“” ❂==============❀
-(void)modifyOperationWithHabitID:(NSString *)habitID minAmount:(NSString *)minAmount addAmount:(NSString *)addAmount{
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"habitID = %@", habitID];
    request.predicate = predicate;
    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Habits * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果min没传值，说明是加
        if ([minAmount isEqualToString:@""]) {
            obj.habitDidAmount = addAmount;
        }
        //否则是减
        else{
            obj.habitNotDoAmount = minAmount;
        }
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
    
    [_habitIDArr removeAllObjects];
    [_habitPhotoUrlArr removeAllObjects];
    [_habitNameArr removeAllObjects];
    [_habitDidAmountArr removeAllObjects];
    [_habitNotDoAmountArr removeAllObjects];
    [_habitReasonArr removeAllObjects];
    [_habitRepeatDataArr removeAllObjects];
    [_habitReminderTimeArr removeAllObjects];
    
    
    // 建立获取数据的请求对象，指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
    // 执行获取操作，获取所有Employee托管对象
    NSError *error = nil;
    NSArray *addresses = [context executeFetchRequest:request error:&error];
    [addresses enumerateObjectsUsingBlock:^(Habits * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [_habitIDArr addObject:obj.habitID];
        [_habitPhotoUrlArr addObject:obj.habitPhotoURL];
        [_habitNameArr addObject:obj.habitName];
        [_habitDidAmountArr addObject:obj.habitDidAmount];
        [_habitNotDoAmountArr addObject:obj.habitNotDoAmount];
        [_habitReasonArr addObject:obj.habitReason];
        [_habitRepeatDataArr addObject:obj.habitRepeatData];
        [_habitReminderTimeArr addObject:obj.habitReminderTime];
      
        
        NSLog(@"id %@ name : %@, url : %@, did : %@ ,not  %@  reason %@  repeat %@ reminder %@", obj.habitID, obj.habitName, obj.habitPhotoURL,obj.habitDidAmount,obj.habitNotDoAmount,obj.habitReason,obj.habitRepeatData,obj.habitReminderTime);
        
    }];
    // 错误处理
    if (error) {
        NSLog(@"CoreData Ergodic Data Error : %@", error);
    }
}

#pragma mark - ❀==============❂ tabbar动画 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    
    //初始化数组
    _habitNameArr = [NSMutableArray new];
    _habitDidAmountArr = [NSMutableArray new];
    _habitNotDoAmountArr = [NSMutableArray new];
    _habitPhotoUrlArr = [NSMutableArray new];
    _habitReasonArr = [NSMutableArray new];
    _habitIDArr = [NSMutableArray new];
    _habitRepeatDataArr = [NSMutableArray new];
    _habitReminderTimeArr = [NSMutableArray new];
    
    [self getData];
    [self inquireOperation];
    //判断是否有数据
    [self reminderAddHabit];
    
    
    
    [self setNavRightButton];
    [self createTableView];
    
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
