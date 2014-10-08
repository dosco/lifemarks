//
//  HomeViewController.m
//  Lifemarks
//
//  Created by Vikram Rangnekar on 11/3/13.
//  Copyright (c) 2013 Lifemarks Team. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

NSDateFormatter *timeFormatter;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm:ss"];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

        // Custom initialization
    }
    return self;
}

- (void) setMetricsCore:(MetricsCore *) metricsCore
{
    [metricsCore addObserver:self forKeyPath:@"_numberOfSteps" options:NSKeyValueObservingOptionNew context:nil];
    [metricsCore addObserver:self forKeyPath:@"_totalTimeStationary" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"_numberOfSteps"]) {
        long nos = (long) [[change valueForKey:NSKeyValueChangeNewKey] longValue];
        [self.stepsDisplay setText:[NSString stringWithFormat:@"%ld", nos]];
    }
    
    if ([keyPath isEqual:@"_totalTimeStationary"]) {
        NSDate *tts = (NSDate *) [change objectForKey:NSKeyValueChangeNewKey];

        NSLog(@"-----> %@", [timeFormatter stringFromDate:tts]);

        [self.stationaryDisplay setText:[NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:tts]]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
