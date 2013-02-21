//
//  RossPageViewController.h
//  UltimateAscent
//
//  Created by FRC on 2/15/13.
//  Copyright (c) 2013 FRC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchTypePickerController.h"

@class MatchData;
@class TeamScore;
@class SettingsData;

@interface RossPageViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, MatchTypePickerDelegate>
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SettingsData *settings;
@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, assign) NSUInteger rowIndex;
@property (nonatomic, assign) NSUInteger teamIndex;
@property (nonatomic, retain) MatchData *currentMatch;
- (void)retrieveSettings;

// Match Control
@property (nonatomic, retain) IBOutlet UIButton *prevMatch;
@property (nonatomic, retain) IBOutlet UIButton *nextMatch;
@property (nonatomic, retain) IBOutlet UIButton *ourPrevMatch;
@property (nonatomic, retain) IBOutlet UIButton *ourNextMatch;
-(IBAction)PrevButton;
-(IBAction)OurNextButton;
-(IBAction)OurPrevButton;
-(IBAction)NextButton;-(NSUInteger)GetNextSection:(NSUInteger) currentSection;
-(NSUInteger)GetPreviousSection:(NSUInteger) currentSection;

// Match Number
@property (nonatomic, retain) IBOutlet UITextField *matchNumber;
-(IBAction)MatchNumberChanged;

// Match Type
@property (nonatomic, retain) IBOutlet UIButton *matchType;
@property (nonatomic, retain) NSMutableArray *matchTypeList;
@property (nonatomic, retain) MatchTypePickerController *matchTypePicker;
@property (nonatomic, retain) UIPopoverController *matchTypePickerPopover;
-(IBAction)MatchTypeSelectionChanged:(id)sender;

// Overall Match Scores
@property (nonatomic, retain) IBOutlet UITextField *redScore;
@property (nonatomic, retain) IBOutlet UITextField *blueScore;

// Data Handling
-(void)ShowMatch:(NSIndexPath *)currentMatchIndex;
-(TeamScore *)GetTeam:(NSUInteger)currentTeamIndex;
-(void)setTeamList;

// Make It Look Good
-(void)SetTextBoxDefaults:(UITextField *)textField;
-(void)SetBigButtonDefaults:(UIButton *)currentButton;
-(void)SetSmallButtonDefaults:(UIButton *)currentButton;


@end