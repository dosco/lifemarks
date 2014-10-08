//
//  MetricsCore.m
//  Lifemarks
//
//  Created by Vikram Rangnekar on 11/3/13.
//  Copyright (c) 2013 Lifemarks Team. All rights reserved.
//
#import <CoreMotion/CMStepCounter.h>
#import <CoreMotion/CMMotionActivityManager.h>
#import <CoreMotion/CMMotionActivity.h>

#import "MetricsCore.h"

@implementation MetricsCore

CMMotionActivityManager *activityManager;
CMStepCounter *stepCounter;

long stepsTakenToday = 0;
NSDate *startDormant, *endDormant;

NSTimeInterval startDriving = -1, timeDriving = -1, totalTimeDriving = -1;
NSTimeInterval startStationary = -1, timeStationary = -1, totalTimeStationary = -1;


bool collectingData = false;

-(id) init
{
    if(self = [super init]) {
        if([CMMotionActivityManager isActivityAvailable]) {
            activityManager = [[CMMotionActivityManager alloc] init];
        }
        else {
            NSLog(@"No activity data available");
        }
    
        if([CMStepCounter isStepCountingAvailable]) {
            stepCounter = [[CMStepCounter alloc] init];
        }
        else {
            NSLog(@"No step counting available");
        }
        [self startCollectingData];
    }
    return self;
}

- (void) startCollectingData
{
    if(collectingData)
    {
        return;
    }
    
    collectingData = true;
    NSLog(@"startCollectingData!");
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    NSDate *todayStated = [cal dateFromComponents:comps];
    NSDate *now = [NSDate date];
    
    startDormant = endDormant = now;
    
    if([CMMotionActivityManager isActivityAvailable])
    {
        NSLog(@"Starting to collect activity");
        
        [activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
            NSLog(@"CMMotionActivity: %@", activity);
            
            if(startDriving == -1 && activity.automotive) {
                startDriving = [[NSDate date] timeIntervalSince1970];

            }
            else if(startDriving > -1 && activity.automotive) {
                timeDriving = [[NSDate date] timeIntervalSince1970] - startDriving;
            }
            else if(timeDriving > -1 && !activity.automotive) {
                totalTimeDriving += timeDriving;
                [self setValue:[NSDate dateWithTimeIntervalSince1970:totalTimeDriving] forKey:@"_totalTimeDriving"];
                NSLog(@"Total Time Driving: %@", [NSDate dateWithTimeIntervalSince1970:totalTimeDriving]);
                
                startDriving = timeDriving = -1;
            }
            
            
            if(startStationary == -1 && activity.stationary) {
                startStationary = [[NSDate date] timeIntervalSince1970];
            }
            else if(startStationary > -1 && activity.stationary) {
                timeStationary = [[NSDate date] timeIntervalSince1970] - startStationary;

                totalTimeStationary += timeStationary - totalTimeStationary;
                NSLog(@"Total Time Stationary >>> %@", [NSDate dateWithTimeIntervalSince1970:totalTimeStationary]);

                [self setValue:[NSDate dateWithTimeIntervalSince1970:totalTimeStationary] forKey:@"_totalTimeStationary"];
            }
            else if(timeStationary > -1 && !activity.stationary) {
                startStationary = timeStationary = -1;
            }

        }];
    }
    
    if([CMStepCounter isStepCountingAvailable])
    {
        NSLog(@"Started counting steps");
        
        [stepCounter queryStepCountStartingFrom:todayStated to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger stt, NSError *error) {
            
            stepsTakenToday = stt;
            NSLog(@"STT >> %ld", stt);
            [self setValue:[NSNumber numberWithLong:stt] forKey:@"_numberOfSteps"];
        }];
        
        [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:2 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            
            long totalSteps = stepsTakenToday + numberOfSteps;
            NSLog(@"NOS >> %ld", numberOfSteps);

            [self setValue:[NSNumber numberWithLong:totalSteps] forKey:@"_numberOfSteps"];
        }];
    }
}

- (void) stopCollectingData
{
    if(!collectingData)
    {
        return;
    }
    
    collectingData = false;
    NSLog(@"stopCollectingData!");
    
    if(activityManager)
    {
        [activityManager stopActivityUpdates];
        NSLog(@"Activity data collection stopped");
    }
    if(stepCounter)
    {
        [stepCounter stopStepCountingUpdates];
        NSLog(@"Step counting stopped");
    }
}
@end



