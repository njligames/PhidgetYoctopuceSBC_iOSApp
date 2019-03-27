//
//  ViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-13.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "ViewController.h"
#import <sys/utsname.h>

bool animationComplete = NO;
@interface ViewController ()

@end

@implementation ViewController

-(void) viewDidAppear:(BOOL)animated{
    BOOL iPhone4 = NO;
    [super viewDidAppear:animated];
    NSString *devName = getDeviceName();
    if([devName containsString:@"iPhone4"])
        iPhone4 = YES;
    if(animationComplete == NO){
        [UIView animateWithDuration:0.8
                              delay:0.8
                            options:0
                         animations:^{
                             CGRect frame = self.imageView.frame;
                             if(iPhone4){
                                 frame.origin.y = -100; // we aren't showing image on iPhone4 due to screen size so just put it off screen
                             }
                             else
                                 frame.origin.y = 16;
                             self.imageView.frame = frame;
                             
                         }
                         completion:^(BOOL completed){
                             if(iPhone4){
                                 [self performSegueWithIdentifier:@"transition_4" sender:self];
                             }
                             else
                                 [self performSegueWithIdentifier:@"transition" sender:self];
                             animationComplete = YES;
                         }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

NSString* getDeviceName(){
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
