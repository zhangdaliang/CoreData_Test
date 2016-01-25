//
//  Student+CoreDataProperties.h
//  CoreData_Test
//
//  Created by 张大亮 on 16/1/25.
//  Copyright © 2016年 张大亮. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;

@end

NS_ASSUME_NONNULL_END
