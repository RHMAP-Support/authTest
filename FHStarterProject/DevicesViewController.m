//
//  ViewController.m
//  Devicelab
//
//  Created by Willem Van Pelt on 13/11/15.
//  Copyright © 2015 AppFoundry. All rights reserved.
//

#import "DevicesViewController.h"
#import <FH/FH.h>

static NSString *const CELL_IDENTIFIER = @"DEVICE_CELL";

@interface DevicesViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DevicesViewController {
    NSArray *data;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];

    [FH initWithSuccess:^(FHResponse *response) {
        FHCloudRequest *req = [FH buildCloudRequest:@"/device" WithMethod:@"GET" AndHeaders:nil AndArgs:nil];
        req.cacheTimeout = 10000;
        [req execAsyncWithSuccess:^(FHResponse *res) {
                    NSLog(@"Response: %@ %@", @(res.responseStatusCode), res.rawResponseAsString);
                    data = [res.parsedResponse[@"list"] copy];
                    [self.tableView reloadData];

                }
                       AndFailure:^(FHResponse *res) {
                           NSLog(@"Failed to call. Response = %@ %@", @(res.responseStatusCode), res.rawResponseAsString);
                       }];

    }        AndFailure:^(FHResponse *response) {
        if (response.responseStatusCode == 304) {
            NSLog(@"Received 304 from server, nothing to reload");
        } else {
            NSLog(@"initialize fail, %@", response.rawResponseAsString);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSUInteger integer = (NSUInteger) indexPath.row;
    cell.textLabel.text = data[integer][@"fields"][@"model"];
    return cell;
}


@end


