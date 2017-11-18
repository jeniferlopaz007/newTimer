//
//  ViewController.m
//  newTimerDemo
//
//  Created by SOTSYS026 on 18/11/17.
//  Copyright © 2017 SOTSYS026. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define All @"All"
#define Weeks @"Weeks"
#define Sleeps @"Sleeps"
#define Hours @"Hours"
#define Minutes @"Minutes"
#define Seconds @"Seconds"
#define Heartbeats @"Heartbeats"

#define keyAppLock                  @"appLock"
#define keyNotification             @"notification"

#define AppDel ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface ViewController ()
{
    NSDate *chistmasDay;
    NSDate *currentLocalDateNew;
    NSString *strSelectedFlag;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strSelectedFlag = All;
    NSString *strChristmasDay = AppDel.strTimerDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    chistmasDay = [formatter dateFromString:strChristmasDay];
    NSMutableString *strString = [self timeLeftSinceDate:chistmasDay withFlag:All];
    
    NSLog(@"open timing - %@",strString);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"setNotification"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyNotification];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:keyAppLock];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self scheduleNotifications:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"setNotification"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableString*)timeLeftSinceDate:(NSDate *)dateT withFlag:(NSString *)flag {
    
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    
    NSDate* currentDateUTC = [NSDate date];
    
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDateUTC];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDateUTC];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    
    NSDate *currentDateLocal = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDateUTC];
    currentLocalDateNew = currentDateLocal;
    
    if (![self isEndDateIsSmallerThanCurrent:currentDateLocal endDate:chistmasDay]) {
        
        NSInteger seconds = [currentDateLocal timeIntervalSinceDate:dateT];
        
        NSInteger days = (int) (floor(seconds / (3600 * 24)));
        if(days) seconds -= days * 3600 * 24;
        
        NSInteger hours = (int) (floor(seconds / 3600));
        if(hours) seconds -= hours * 3600;
        
        NSInteger minutes = (int) (floor(seconds / 60));
        if(minutes) seconds -= minutes * 60;
        
        if ([flag isEqualToString:All]) {
            if(days) {
                [timeLeft appendString:[NSString stringWithFormat:@"%ld Days\n", (long)days*-1]];
                [UIApplication sharedApplication].applicationIconBadgeNumber = days*-1;
            }else{
                [timeLeft appendString:[NSString stringWithFormat:@"%d Day\n", 0]];
            }
            if(hours) {
                [timeLeft appendString:[NSString stringWithFormat: @"%ld Hours\n", (long)hours*-1]];
            }else{
                [timeLeft appendString:[NSString stringWithFormat:@"%d Hour\n", 0]];
            }
            
            if(minutes) {
                [timeLeft appendString: [NSString stringWithFormat: @"%ld Minutes\n",(long)minutes*-1]];
            }else{
                [timeLeft appendString:[NSString stringWithFormat:@"%d Minute\n", 0]];
            }
            
            if(seconds) {
                [timeLeft appendString:[NSString stringWithFormat: @"%ld Seconds\n", (long)seconds*-1]];
            }else{
                [timeLeft appendString:[NSString stringWithFormat:@"%d Second\n", 0]];
            }
            
        }else if ([flag isEqualToString:Weeks]){
            if(days) {
                NSInteger noOfWeeks = (long)days*-1/7;
                NSInteger noOfDays = (long)days*-1%7;
                if (!noOfDays) {
                    noOfDays = 0;
                }
                if (!noOfWeeks) {
                    noOfWeeks = 0;
                }
                [timeLeft appendString:[NSString stringWithFormat:@"%ld Weeks\n %ld Days", (long)noOfWeeks,(long)noOfDays]];
            }
        }else if ([flag isEqualToString:Sleeps]){
            [timeLeft appendString:[NSString stringWithFormat:@"%ld \n Sleeps", (long)days*-1+1]];
        }else if ([flag isEqualToString:Hours]){
            if(days || hours) {
                hours = days*-1*24 + hours*-1;
                [timeLeft appendString:[NSString stringWithFormat: @"%ld \n Hours", (long)hours]];
            }else{
                [timeLeft appendString:[NSString stringWithFormat: @"%d \n Hour", 0]];
            }
        }else if ([flag isEqualToString:Minutes]){
            int newHours = (int)days*-1*24;
            minutes = hours*-1*60 + newHours * 60 + minutes*-1;
            if(minutes) {
                [timeLeft appendString: [NSString stringWithFormat: @"%ld \n Minutes",(long)minutes]];
            }else{
                [timeLeft appendString: [NSString stringWithFormat: @"%d \n Minute",0]];
            }
        }else if ([flag isEqualToString:Seconds]){
            int newHours = (int)days*-1*24;
            minutes = hours*-1*60 + newHours * 60 + minutes*-1;
            seconds = minutes*60 + seconds*-1;
            if(seconds) {
                [timeLeft appendString: [NSString stringWithFormat: @"%ld \n Seconds",(long)seconds]];
            }else{
                [timeLeft appendString: [NSString stringWithFormat: @"%d \n Second",0]];
            }
        }else if ([flag isEqualToString:Heartbeats]){
            int newHours = (int)days*-1*24;
            minutes = hours*-1*60 + newHours * 60 + minutes*-1;
            long heartBeats = minutes*80 + seconds*-1.3;
            
            if(heartBeats) {
                [timeLeft appendString: [NSString stringWithFormat: @"%ld \n Heartbeats",(long)heartBeats]];
            }else{
                [timeLeft appendString: [NSString stringWithFormat: @"%d \n Heartbeat",0]];
            }
        }
    }
    return timeLeft;
}
- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)currentLocalDate endDate:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentLocalDate];
    
    if (distanceBetweenDates == 0 || distanceBetweenDates < 0) {
       /* imgChristmas.hidden = NO;
        imgChristmas.userInteractionEnabled = YES;
        imgChristmas.image = [UIImage imageNamed:@"christmasday"];
        if (!IS_REMOVE_ADS) {
            bannerViewAd.frame = CGRectMake(0, viewNavigation.frame.origin.y+viewNavigation.frame.size.height, self.view.frame.size.width, bannerViewAd.frame.size.height);
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            btnPlay.frame = CGRectMake(self.view.frame.size.width - btnPlay.frame.size.width - 10, viewNavigation.frame.origin.y + viewNavigation.frame.size.height + ((IS_IPAD)?90:50) + 20, btnPlay.frame.size.width, btnPlay.frame.size.height);
            btnShare.frame = CGRectMake(self.view.frame.size.width- btnShare.frame.size.width - 10, btnPlay.frame.origin.y + btnPlay.frame.size.height + 10 , btnShare.frame.size.width, btnShare.frame.size.height);
            [self ribbinFall];
        });*/
        
        return YES;
    }else{
        /*imgChristmas.hidden = YES;
        imgChristmas.userInteractionEnabled = NO;*/
        return NO;
    }
}
#pragma mark - Notification On/OFF -
-(void)scheduleNotifications:(BOOL)isOn {
    if (isOn && ![self isEndDateIsSmallerThanCurrent:currentLocalDateNew endDate:chistmasDay]) {
        NSInteger seconds = [self getRemainingTimeinterval];
        NSInteger days = (int) (floor(seconds / (3600 * 24)));
        if(days) seconds -= days * 3600 * 24;
        days*-1;
        if (days > 0) {
            int day = (25 - days);
            for (NSInteger i = 0; i <= days ; i++) {
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDate *now = [NSDate date];
                NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
                
                [componentsForFireDate setYear:2016];
                [componentsForFireDate setMonth:12];
                [componentsForFireDate setDay: day];
                [componentsForFireDate setHour:0];
                [componentsForFireDate setMinute:0];
                [componentsForFireDate setSecond:0];
                [UIApplication sharedApplication].applicationIconBadgeNumber = (25 - day);
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(25 - day)];
                NSLog(@"componentsForFireDate: %@",componentsForFireDate);
                UILocalNotification *notification = [[UILocalNotification alloc]  init];
                notification.fireDate = [calendar dateFromComponents: componentsForFireDate];
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = @"default";
                if (i == days) {
                    notification.alertBody = [NSString stringWithFormat: @"🎄🎄Merry Christmas!🎄🎄"];
                } else {
                    notification.alertBody = [NSString stringWithFormat: @"%d Days until Christmas Day!",(25 - day)];
                }
                
                notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"christmas"] forKey:@"discription"];
                day++;
                NSLog(@"notification: %@",notification);
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setLocalNotification"];
            }
        }
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

-(NSInteger)getRemainingTimeinterval {
    NSDate* currentDateUTC = [NSDate date];
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDateUTC];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDateUTC];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    
    NSString *strChristmasDay = AppDel.strTimerDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    chistmasDay = [formatter dateFromString:strChristmasDay];
    
    NSDate *currentDateLocal = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDateUTC];
    NSInteger seconds;
    if (![self isEndDateIsSmallerThanCurrent:currentDateLocal endDate:chistmasDay]) {
        
        seconds = [currentDateLocal timeIntervalSinceDate:chistmasDay];
    }
    return seconds*-1;
}
-(void)timerTick{
    NSMutableString *strString = [self timeLeftSinceDate:chistmasDay withFlag:strSelectedFlag];
    NSLog(@"continue timing - %@",strString);
}
@end
