//
//  Habits+CoreDataProperties.h
//  habit
//
//  Created by 王浩祯 on 2018/4/12.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "Habits+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Habits (CoreDataProperties)

+ (NSFetchRequest<Habits *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *habitDidAmount;
@property (nullable, nonatomic, copy) NSString *habitID;
@property (nullable, nonatomic, copy) NSString *habitName;
@property (nullable, nonatomic, copy) NSString *habitNotDoAmount;
@property (nullable, nonatomic, copy) NSString *habitPhotoURL;
@property (nullable, nonatomic, copy) NSString *habitReason;
@property (nullable, nonatomic, copy) NSString *habitReminderTime;
@property (nullable, nonatomic, copy) NSString *habitRepeatData;
@property (nullable, nonatomic, copy) NSString *habitNotificatonID;

@end

NS_ASSUME_NONNULL_END
