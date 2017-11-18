//
//  AppDelegate.m
//  newTimerDemo
//
//  Created by SOTSYS026 on 18/11/17.
//  Copyright © 2017 SOTSYS026. All rights reserved.
//

#import "AppDelegate.h"

#define APPLOCK                     ([[NSUserDefaults standardUserDefaults] boolForKey:keyAppLock])
#define NOTIFICATION                ([[NSUserDefaults standardUserDefaults] boolForKey:keyNotification])
#define keyAppLock                  @"appLock"
#define keyNotification             @"notification"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"is_first_time"]) {
        [application cancelAllLocalNotifications]; // Restart the Local Notifications list
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyAppLock];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"is_first_time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (APPLOCK) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }else{
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
    
    NSDate* currentDateUTC = [NSDate date];
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDateUTC];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDateUTC];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    
    NSString *strLastDateOfYear = @"2016-12-31 23:59:59 +0000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *lastDate = [formatter dateFromString:strLastDateOfYear];
    
    NSDate *currentDateLocal = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDateUTC];
    if (![self isEndDateIsSmallerThanCurrent:currentDateLocal endDate:lastDate]) {
        _strTimerDate = @"2016-12-25 00:00:00 +0000";
    }else{
        _strTimerDate = @"2017-12-25 00:00:00 +0000";
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
    NSLog(@"Register Local Notification %lu",(unsigned long)[notificationSettings types]);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Noti detail %@",[notification.userInfo valueForKey:@"discription"]);
}
- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)currentLocalDate endDate:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentLocalDate];
    
    if (distanceBetweenDates == 0 || distanceBetweenDates < 0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
