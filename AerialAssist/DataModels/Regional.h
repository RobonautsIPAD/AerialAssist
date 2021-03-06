//
//  Regional.h
// Robonauts Scouting
//
//  Created by FRC on 12/7/13.
//  Copyright (c) 2013 FRC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TeamData;

@interface Regional : NSManagedObject

@property (nonatomic, retain) NSString * awards;
@property (nonatomic, retain) NSNumber * ccwm;
@property (nonatomic, retain) NSNumber * dpr;
@property (nonatomic, retain) NSString * eliminated;
@property (nonatomic, retain) NSString * eliminationRecord;
@property (nonatomic, retain) NSString * finishPosition;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * opr;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * reg1;
@property (nonatomic, retain) NSNumber * reg2;
@property (nonatomic, retain) NSNumber * reg3;
@property (nonatomic, retain) NSNumber * reg4;
@property (nonatomic, retain) NSString * reg5;
@property (nonatomic, retain) NSString * reg6;
@property (nonatomic, retain) NSString * seedingRecord;
@property (nonatomic, retain) NSNumber * week;
@property (nonatomic, retain) TeamData *team;

@end
