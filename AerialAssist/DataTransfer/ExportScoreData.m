//
//  ExportScoreData.m
//  AerialAssist
//
//  Created by FRC on 2/15/14.
//  Copyright (c) 2014 FRC. All rights reserved.
//

#import "ExportScoreData.h"
#import "DataManager.h"
#import "TeamScore.h"
#import "TeamData.h"
#import "MatchData.h"
#import "MatchTypeDictionary.h"

@implementation ExportScoreData {
    NSUserDefaults *prefs;
    NSString *tournamentName;
    NSDictionary *properties;
    NSDictionary *attributes;
    MatchTypeDictionary *matchDictionary;
    NSArray *scoutingSpreadsheetList;
    BOOL firstPass;
}

- (id)initWithDataManager:(DataManager *)initManager {
	if ((self = [super init]))
	{
        _dataManager = initManager;
	}
    firstPass = TRUE;
	return self;
}

-(NSString *)teamScoreCSVExport {
    if (!_dataManager) {
        _dataManager = [[DataManager alloc] init];
    }
    prefs = [NSUserDefaults standardUserDefaults];
    tournamentName = [prefs objectForKey:@"tournament"];
    matchDictionary = [[MatchTypeDictionary alloc] init];
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TeamScore" inManagedObjectContext:_dataManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *typeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"match.matchTypeSection" ascending:YES];
    NSSortDescriptor *numberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"match.number" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:typeDescriptor, numberDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"tournamentName = %@ AND results = %@", tournamentName, [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:pred];
    NSArray *teamScores = [_dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(!teamScores) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minor Problem Encountered"
                                                        message:@"No Score results to email"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    TeamScore *score;
    NSString *csvString;
    score = [teamScores objectAtIndex:0];
    properties = [[score entity] propertiesByName];
    csvString = [self createHeader:score];
    
    for (int i=0; i<[teamScores count]; i++) {
        score = [teamScores objectAtIndex:i];
        csvString = [csvString stringByAppendingString:[self createScore:score]];
    }
    return csvString;
}

-(NSString *)createHeader:(TeamScore *)score {
    NSString *csvString;
    
    csvString = @"Team, Match, Type, Tournament";
    for (NSString *item in properties) {
        if ([item isEqualToString:@"team"]) continue; // We have already printed the team number
        if ([item isEqualToString:@"match"]) continue; // We have already printed the match number
        if ([item isEqualToString:@"matchType"]) continue; // We have already printed the match type
        if ([item isEqualToString:@"tournamentName"]) continue; // We have already printed the tournament name
        NSString *output = [[[properties objectForKey:item] userInfo] objectForKey:@"output"];
        if (output) {
            csvString = [csvString stringByAppendingFormat:@", %@", output];
        }
    }
    csvString = [csvString stringByAppendingString:@"\n"];
 
    return csvString;
}

-(NSString *)createScore:(TeamScore *)score {
    NSString *csvString;
    csvString = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", score.team.number, score.match.number, score.match.matchType, tournamentName];
    for (NSString *item in properties) {
        if ([item isEqualToString:@"team"]) continue; // We have already printed the team number
        if ([item isEqualToString:@"match"]) continue; // We have already printed the match number
        if ([item isEqualToString:@"matchType"]) continue; // We have already printed the match type
        if ([item isEqualToString:@"tournamentName"]) continue; // We have already printed the tournament name
        NSString *output = [[[properties objectForKey:item] userInfo] objectForKey:@"output"];
        if (output) {
            csvString = [csvString stringByAppendingFormat:@", %@",[self outputFormat:[[properties objectForKey:item] attributeType] forValue:[score valueForKey:item]]];
        }
    }
    csvString = [csvString stringByAppendingString:@"\n"];
    
    return csvString;
}

-(NSString *) outputFormat:(NSAttributeType)type forValue:data {
    if (type == NSStringAttributeType) {
        if (data) return [NSString stringWithFormat:@"\"%@\"", data];
        else return @"";
    }
    else return [NSString stringWithFormat:@"%@", data];
}

-(NSString *)spreadsheetCSVExport:(TeamData *)team forMatches:(NSString *)choice{
    if (!_dataManager) {
        _dataManager = [[DataManager alloc] init];
    }
    if (!scoutingSpreadsheetList) {
        // Load dictionary with list of parameters for the scouting spreadsheet
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MarcusOutput" ofType:@"plist"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
        scoutingSpreadsheetList = [[[NSArray alloc] initWithContentsOfFile:plistPath] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    prefs = [NSUserDefaults standardUserDefaults];
    tournamentName = [prefs objectForKey:@"tournament"];
    
    NSArray *allScores = [team.match allObjects];
 //   NSPredicate *pred = [NSPredicate predicateWithFormat:@"tournamentName = %@ AND results = %@ and match.matchType = %@", tournamentName, [NSNumber numberWithBool:YES], choice];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"tournamentName = %@ AND results = %@ and match.matchType = %@", tournamentName, [NSNumber numberWithBool:YES], @"Seeding"];
    NSSortDescriptor *typeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"match.matchTypeSection" ascending:YES];
    NSSortDescriptor *numberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"match.number" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:typeDescriptor, numberDescriptor, nil];
    NSArray *teamScores = [[allScores filteredArrayUsingPredicate:pred] sortedArrayUsingDescriptors:sortDescriptors];

    if(!teamScores) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minor Problem Encountered"
                                                        message:@"No Score results to email"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    TeamScore *score;
    NSString *csvString;
    int nmatches = [teamScores count];
    if (nmatches == 0) {
        csvString = [[NSString alloc] init];
        return csvString;
    }
    if (firstPass) {
        firstPass = FALSE;
        csvString = [self createSpreadsheetHeader:scoutingSpreadsheetList];
        csvString = [csvString stringByAppendingFormat:@"%@, %d", team.number, nmatches];
    }
    else {
        csvString = [[NSString alloc] initWithFormat:@"%@, %d", team.number, nmatches];
    }
    for (int i=0; i<nmatches; i++) {
        score = [teamScores objectAtIndex:i];
        csvString = [csvString stringByAppendingFormat:@", %@", score.match.number];
        for (int j=1; j<[scoutingSpreadsheetList count]; j++) {
            NSString *key = [[scoutingSpreadsheetList objectAtIndex:j] objectForKey:@"key"];
            csvString = [csvString stringByAppendingFormat:@", %@", [score valueForKey:key]];
        }
    }
    csvString = [csvString stringByAppendingString:@"\n"];
    return csvString;
}

-(NSString *)createSpreadsheetHeader:(NSArray *)scoreList {
    NSString *csvString;
    
    csvString = @"Team Number, Total Matches";
    for (int j=0; j<10; j++) {
        for (int i=0; i<[scoreList count]; i++) {
            csvString = [csvString stringByAppendingFormat:@", %@", [[scoutingSpreadsheetList objectAtIndex:i] objectForKey:@"header"]];
        }
    }
    csvString = [csvString stringByAppendingString:@"\n"];
    
    return csvString;
}


@end
