//
//  MetricsCore.h
//  Lifemarks
//
//  Created by Vikram Rangnekar on 11/3/13.
//  Copyright (c) 2013 Lifemarks Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricsCore : NSObject

@property (nonatomic, readonly) NSInteger numberOfSteps;
@property (nonatomic, readonly) NSDate *totalTimeDriving;
@property (nonatomic, readonly) NSDate *totalTimeStationary;

- (void) startCollectingData;
- (void) stopCollectingData;
@end
