//
//  SettingsAndPreferences.m
// Robonauts Scouting
//
//  Created by FRC on 12/8/13.
//  Copyright (c) 2013 FRC. All rights reserved.
//

#import "SettingsAndPreferences.h"

@implementation SettingsAndPreferences

-(void)initializeSettings {
    NSUserDefaults *prefs;
    NSString *appName = @"AerialAssist";
    NSString *game = @"Aerial Assist";
    NSString *prefName = [@"Robonauts" stringByAppendingFormat:@".%@", appName];
    NSString *fileName = [@"Robonauts" stringByAppendingFormat:@".%@.plist", appName];
    NSString *prefFile = [[self applicationLibraryDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"Preferences/%@", fileName]];

    //NSLog(@"Prefs file = %@", prefFile);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:prefFile]) {
        // Preferences doesn't already exist, so check for one in the main bundle
        NSLog(@"%@ does not exist", fileName);
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:prefName ofType:@"plist"];
        if (defaultStorePath) {
            // Copy preferences from the main bundle
            NSLog(@"Found a prefs file in the main bundle");
            [fileManager copyItemAtPath:defaultStorePath toPath:prefFile error:NULL];
            prefs = [NSUserDefaults standardUserDefaults];
        }
        else { // Nothing Found
            prefs = [NSUserDefaults standardUserDefaults];
            NSLog(@"No pre-existing preferences.");
            [prefs setObject:@"Red 1" forKey:@"alliance"];
            [prefs setObject:@"bluefish" forKey:@"adminCode"];
            [prefs setObject:@"118over" forKey:@"overrideCode"];
            [prefs setObject:@"Test" forKey:@"mode"];
        }
    }
    else {
        prefs = [NSUserDefaults standardUserDefaults];        
    }
    
    // delete this block!
    NSLog(@"SettingsAndPreferences Delete!");
    [prefs setObject:[NSNumber numberWithInt:2014] forKey:@"year"];
    
    NSNumber *teamDataSync = [prefs objectForKey:@"teamDataSync"];
    if (teamDataSync == nil) {
        [prefs setObject:[NSNumber numberWithInt:0] forKey:@"teamDataSync"];
    }

    NSString *matchScheduleSync = [prefs objectForKey:@"matchScheduleSync"];
    if (matchScheduleSync == nil) {
        [prefs setObject:[NSNumber numberWithInt:0] forKey:@"matchScheduleSync"];
    }

    NSString *matchResultsSync = [prefs objectForKey:@"matchResultsSync"];
    if (matchResultsSync == nil) {
        [prefs setObject:[NSNumber numberWithInt:0] forKey:@"matchResultsSync"];
    }

    // It is easier to just set these than check to see if they are set right and
    // set them if they are not.
    [prefs setObject:appName forKey:@"appName"];
    [prefs setObject:game forKey:@"gameName"];
    [prefs setObject:[[UIDevice currentDevice] name] forKey:@"deviceName"];
    [prefs synchronize];
}

#pragma mark - Application's Library directory

/**
 Returns the path to the application's Library directory.
 */
- (NSString *)applicationLibraryDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

@end
