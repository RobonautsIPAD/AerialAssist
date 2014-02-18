//
//  MatchDataInterfaces.m
//  AerialAssist
//
//  Created by FRC on 2/12/14.
//  Copyright (c) 2014 FRC. All rights reserved.
//

#import "MatchDataInterfaces.h"
#import "DataManager.h"
#import "MatchData.h"
#import "TeamData.h"
#import "TeamScore.h"
#import "TeamDataInterfaces.h"
#import "TeamScoreInterfaces.h"

@implementation MatchDataInterfaces
@synthesize dataManager = _dataManager;

- (id)initWithDataManager:(DataManager *)initManager {
	if ((self = [super init]))
	{
        _dataManager = initManager;
	}
	return self;
}

-(NSData *)packageMatchForXFer:(MatchData *)match {
    if (!_dataManager) {
        _dataManager = [DataManager new];
    }
    NSMutableArray *keyList = [NSMutableArray array];
    NSMutableArray *valueList = [NSMutableArray array];
    if (!_matchDataAttributes) _matchDataAttributes = [[match entity] attributesByName];
    for (NSString *item in _matchDataAttributes) {
        if ([match valueForKey:item]) {
            [keyList addObject:item];
            [valueList addObject:[match valueForKey:item]];
        }
    }

    NSMutableArray *allianceList = [NSMutableArray array];
    NSMutableArray *teamList = [NSMutableArray array];
    NSArray *allTeams = [match.score allObjects];
    for (TeamScore *score in allTeams) {
        if (score.team) {
          //  NSLog(@"score team = %@", score.team);
            [allianceList addObject:score.alliance];
            [teamList addObject:score.team.number];
        }
    }
    NSDictionary *teams = [NSDictionary dictionaryWithObjects:teamList forKeys:allianceList];
    [keyList addObject:@"teams"];
    [valueList addObject:teams];

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:valueList forKeys:keyList];
    NSLog(@"sending %@", dictionary);
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    
    return myData;

}

-(MatchData *)unpackageMatchForXFer:(NSData *)xferData {
    if (!_dataManager) {
        _dataManager = [DataManager new];
    }
    NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:xferData];
    NSNumber *matchNumber = [myDictionary objectForKey:@"number"];
    NSString *matchType = [myDictionary objectForKey:@"matchType"];
    NSString *tournamentName = [myDictionary objectForKey:@"tournamentName"];
    if (!matchNumber || !matchType || !tournamentName) return nil;
    NSLog(@"receiving %@", myDictionary);
    
    MatchData *matchRecord = [self getMatch:matchNumber forMatchType:matchType forTournament:tournamentName];
    if (!matchRecord) {
        matchRecord = [NSEntityDescription insertNewObjectForEntityForName:@"MatchData"
                                                    inManagedObjectContext:_dataManager.managedObjectContext];
    }
    for (NSString *key in myDictionary) {
        if ([key isEqualToString:@"teams"]) continue; // Skip the team list for the moment
        [matchRecord setValue:[myDictionary objectForKey:key] forKey:key];
    }
    NSDictionary *teams = [myDictionary objectForKey:@"teams"];
    for (NSString *key in teams) {
        [[[TeamScoreInterfaces alloc] initWithDataManager:_dataManager] addTeamToMatch:matchRecord forTeam:[teams objectForKey:key] forAlliance:key];
    }
    NSLog(@"Teams = %@", teams);
    matchRecord.received = [NSNumber numberWithFloat:CFAbsoluteTimeGetCurrent()];
    NSError *error;
    if (![_dataManager.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    return matchRecord;
}

-(MatchData *)getMatch:(NSNumber *)matchNumber forMatchType:(NSString *) type forTournament:(NSString *) tournament {
    MatchData *match;
    
    //    NSLog(@"Searching for match = %@", matchNumber);
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"MatchData" inManagedObjectContext:_dataManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"number == %@ AND matchType == %@ and tournamentName = %@", matchNumber, type, tournament];
    [fetchRequest setPredicate:predicate];
    
    NSArray *matchData = [_dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(!matchData) {
        NSLog(@"Karma disruption error");
        return Nil;
    }
    else {
        if([matchData count] > 0) {  // Match Exists
            match = [matchData objectAtIndex:0];
            //    NSLog(@"Match %@ exists", match.number);
            return match;
        }
        else {
            return Nil;
        }
    }
}


@end
