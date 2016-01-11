//
//  AddDeviceViewController.m
//  Devicelab
//
//  Created by Willem Van Pelt on 16/11/15.
//  Copyright © 2015 FeedHenry. All rights reserved.
//

#import "AddDeviceViewController.h"
#import <FH/FH.h>
#import <FH/FHSyncClient.h>

@interface AddDeviceViewController ()
@property(retain, nonatomic) IBOutlet UITextField *typeField;
@property(retain, nonatomic) IBOutlet UITextField *platformField;
@property(retain, nonatomic) IBOutlet UITextField *brandField;
@property(retain, nonatomic) IBOutlet UITextField *modelField;
@property(retain, nonatomic) IBOutlet UITextField *osVersionField;

@end

@implementation AddDeviceViewController

- (IBAction)addDeviceButtonClicked:(id)sender {
[FH initWithSuccess:^(FHResponse *response) {
                NSDictionary *data = @{
                        @"type" : _typeField.text,
                        @"platform" : _platformField.text,
                        @"brand" : _brandField.text,
                        @"model" : _modelField.text,
                        @"osVersion" : _osVersionField.text};

                FHCloudRequest *req = [FH buildCloudRequest:@"/device" WithMethod:@"POST" AndHeaders:nil AndArgs:data];

                [req execAsyncWithSuccess:^(FHResponse *res) {
                            if (res.responseStatusCode == 200) {
                                NSLog(@"Device create");
                            }

                        }
                               AndFailure:^(FHResponse *res) {
                                   NSLog(@"Failed to call. Response = %@", res.rawResponseAsString);
                               }];

            }
             AndFailure:^(FHResponse *response) {
                 NSLog(@"initialize fail, %@", response.rawResponseAsString);
             }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_typeField release];
    [_platformField release];
    [_brandField release];
    [_modelField release];
    [_osVersionField release];
    [super dealloc];
}
@end
