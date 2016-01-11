//
//  AppDelegate.m
//  iOS-Template-App
//
//

#import "AppDelegate.h"
#import "NSUserDefaults+AppData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FH initWithSuccess:^(FHResponse *response) {

        [FH performAuthRequest:@"feedhenry-policy" WithUserName:@"testuser" UserPassword:@"Abcd1234" AndSuccess:^(FHResponse *sucornil) {
            NSLog(@"Response: %@", sucornil.rawResponseAsString);
        } AndFailure:^(FHResponse *failed) {
            NSLog(@"error: %@", failed.rawResponseAsString);
        }];

        if ([NSUserDefaults deviceIsRegistered]) {
            [self _checkForAndRegisterOsVersionUpdate];
            [self _checkForAndRegisterAppVersionUpdate];
        } else {
            [self _performDeviceRegistration];
        }
    }        AndFailure:^(FHResponse *response) {
        NSLog(@"initialize fail, %@", response.rawResponseAsString);
    }];

    return YES;
}

- (void)_checkForAndRegisterAppVersionUpdate {
    if ([NSUserDefaults appVersionDidUpdate]) {
        NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        NSString *path = [NSString stringWithFormat:@"/device/%@/registerAppVersionUpdate/%@", [NSUserDefaults uid], appVersion];

        FHCloudRequest *req = [FH buildCloudRequest:path WithMethod:@"PUT" AndHeaders:nil AndArgs:nil];

        [req execAsyncWithSuccess:^(FHResponse *res) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

            [userDefaults setObject:appVersion forKey:@"lastKnownOsVersion"];
        }              AndFailure:^(FHResponse *res) {
            // Errors
            NSLog(@"Failed to call. Response = %@", res.rawResponseAsString);
        }];

    }
}

- (void)_checkForAndRegisterOsVersionUpdate {
    if ([NSUserDefaults osVersionDidUpdate]) {

        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        NSString *path = [NSString stringWithFormat:@"/device/%@/registerOsVersionUpdate/%@", [NSUserDefaults uid], osVersion];

        FHCloudRequest *req = [FH buildCloudRequest:path WithMethod:@"PUT" AndHeaders:nil AndArgs:nil];

        [req execAsyncWithSuccess:^(FHResponse *res) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

            [userDefaults setObject:osVersion forKey:@"lastKnownOsVersion"];
        }              AndFailure:^(FHResponse *res) {
            // Errors
            NSLog(@"Failed to call. Response = %@", res.rawResponseAsString);
        }];
    }
}

- (void)_performDeviceRegistration {
    NSDictionary *deviceData = [self _deviceData];
    FHCloudRequest *req = [FH buildCloudRequest:@"/device" WithMethod:@"POST" AndHeaders:nil AndArgs:deviceData];

    [req execAsyncWithSuccess:^(FHResponse *res) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        [userDefaults setObject:res.parsedResponse[@"fields"][@"uid"] forKey:@"uid"];
    }              AndFailure:^(FHResponse *res) {
        // Errors
        NSLog(@"Failed to call. Response = %@", res.rawResponseAsString);
    }];
}

- (NSDictionary *)_deviceData {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(bounds.size.width * scale, bounds.size.height * scale);

    NSDictionary *deviceData = @{
            @"serialNumber" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
            @"model" : [UIDevice currentDevice].model,
            @"osVersion" : [[UIDevice currentDevice] systemVersion],
            @"screen" : @{
                    @"resolution" : @{@"horizontal" : @(screenSize.width), @"vertical" : @(screenSize.height)},
                    @"ppi" : @"TODO",
                    @"screenDensity" : @(scale)
            },
            @"appVersion" : [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]
    };
    return deviceData;
}

@end
