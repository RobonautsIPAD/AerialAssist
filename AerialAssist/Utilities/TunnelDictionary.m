//
//  TunnelDictionary.m
//  AerialAssist
//
//  Created by FRC on 4/3/14.
//  Copyright (c) 2014 FRC. All rights reserved.
//

#import "TunnelDictionary.h"

@implementation TunnelDictionary  {
    NSDictionary *dictionary;
    NSArray *objects;
}

- (id)init {
	if ((self = [super init])) {
        NSArray *keys = [NSArray arrayWithObjects:[NSNumber numberWithInt:TunnelUnknown],
                         [NSNumber numberWithInt:TunnelNone],
                         [NSNumber numberWithInt:TunnelMaybe],
                         [NSNumber numberWithInt:TunnelTurn],
                         [NSNumber numberWithInt:TunnelYes],
                         nil];
        objects = [NSArray arrayWithObjects:@"Unknown", @"No", @"Maybe", @"Convertable", @"Yes", nil];
        
        dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	}
	return self;
}

-(NSString *)getString:(id) key {
    if ([dictionary objectForKey:key]) {
        NSString *result = [dictionary objectForKey:key];
        if (!result) result = @"Unknown";
        return result;
    }
    else return nil;
}

-(id)getEnumValue:(NSString *) value {
    NSArray *temp = [dictionary allKeysForObject:value];
    if ([temp count]) return [temp objectAtIndex:0];
    else return [NSNumber numberWithInt:NumberUnknown];
}

-(NSArray *)getTunnelTypes {
    return objects;
}

- (void)dealloc
{
    dictionary = nil;
    objects = nil;
}


@end
