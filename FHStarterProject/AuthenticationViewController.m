//
//  AuthenticationViewController.m
//  Devicelab
//
//  Created by Willem Van Pelt on 23/11/15.
//  Copyright © 2015 FeedHenry. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <FH/FH.h>

@interface AuthenticationViewController ()
@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UILabel *authStatus;

@end

@implementation AuthenticationViewController
- (IBAction)performAuth:(id)sender {
    FHAuthRequest *request = [FH buildAuthRequest];
    request.policyId = @"feedhenry-policy";
    [request execAsyncWithSuccess:^(FHResponse *success) {
        NSLog(@"Response: %@", success.rawResponseAsString);
    } AndFailure:^(FHResponse *failed) {
        NSLog(@"Failed Response: %@", failed.rawResponseAsString);
    }];

    [FH performAuthRequest:@"feedhenry-policy" WithUserName:@"testuser" UserPassword:@"Abcd1234" AndSuccess:^(FHResponse *sucornil) {
        NSLog(@"Response: %@", sucornil.rawResponseAsString);
    } AndFailure:^(FHResponse *failed) {
        NSLog(@"Failed Response: %@", failed.rawResponseAsString);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _authStatus.text = [NSString stringWithFormat:@"Auth status: %@", @([FH hasAuthSession])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_username release];
    [_password release];
    [_authStatus release];
    [super dealloc];
}
@end
