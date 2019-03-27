//
//  ServerViewController.m
//  Phidgets
//
//  Created by Phidgets on 2016-01-21.
//  Copyright © 2016 Phidgets. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

@synthesize serverName = serverName;
@synthesize serverPassword = serverPassword;
@synthesize hostName = hostName;
@synthesize port = port;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [serverName setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerName"]];
    [serverPassword setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerPassword"]];
    [hostName setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerHostname"]];
    [port setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerPort"]];
    
     // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];

}
- (IBAction)enter:(id)sender {
    
    if( ([serverName.text  isEqualToString: @""]) || ([hostName.text  isEqualToString: @""]) || ([port.text  isEqualToString: @""])){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Please enter all neccessary information"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"serverEntered" sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    bottomConstraint.constant = keyboardSize.height + 10;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    bottomConstraint.constant = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
