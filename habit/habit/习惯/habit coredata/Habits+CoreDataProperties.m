//
//  Habits+CoreDataProperties.m
//  habit
//
//  Created by 王浩祯 on 2018/4/12.
//  Copyright © 2018年 王浩祯. All rights reserved.
//
//

#import "Habits+CoreDataProperties.h"

@implementation Habits (CoreDataProperties)

+ (NSFetchRequest<Habits *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Habits"];
}

@dynamic habitDidAmount;
@dynamic habitID;
@dynamic habitName;
@dynamic habitNotDoAmount;
@dynamic habitPhotoURL;
@dynamic habitReason;
@dynamic habitReminderTime;
@dynamic habitRepeatData;
@dynamic habitNotificatonID;

@end
