//
//  ServerViewController.h
//  Phidgets
//
//  Created by Phidgets on 2016-01-21.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerViewController : UIViewController{
    
    IBOutlet NSLayoutConstraint *bottomConstraint;
}
@property (strong, nonatomic) IBOutlet UITextField *serverName;
@property (strong, nonatomic) IBOutlet UITextField *serverPassword;
@property (strong, nonatomic) IBOutlet UITextField *hostName;
@property (strong, nonatomic) IBOutlet UITextField *port;


@end
