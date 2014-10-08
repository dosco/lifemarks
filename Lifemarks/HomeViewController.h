//
//  HomeViewController.h
//  Lifemarks
//
//  Created by Vikram Rangnekar on 11/3/13.
//  Copyright (c) 2013 Lifemarks Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricsCore.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *stepsDisplay;
@property (strong, nonatomic) IBOutlet UILabel *stationaryDisplay;

- (void) setMetricsCore:(MetricsCore *) metricsCore;
@end

