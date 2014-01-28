//
//  MainScoutingPageViewController.h
// Robonauts Scouting
//
//  Created by Kris Pettinger on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlliancePickerController.h"
#import "MatchTypePickerController.h"
#import "TeamPickerController.h"
#import "RecordScorePickerController.h"
#import "DefensePickerController.h"
#import "AlertPromptViewController.h"
#import "ValuePromptViewController.h"
#import "PopUpPickerViewController.h"

@protocol MainScoutingPageDelegate
- (void)scoutingPageStatus:(NSUInteger)sectionIndex forRow:(NSUInteger)rowIndex forTeam:(NSUInteger)teamIndex;
@end

@class MatchData;
@class TeamScore;
@class DataManager;
@class SettingsData;

@interface MainScoutingPageViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, AlliancePickerDelegate, MatchTypePickerDelegate, TeamPickerDelegate, RecordScorePickerDelegate, DefensePickerDelegate, PopUpPickerDelegate, AlertPromptDelegate, ValuePromptDelegate> {
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) SettingsData *settings;
@property (nonatomic, assign) MatchType currentSectionType;
@property (nonatomic, assign) NSUInteger sectionIndex;
@property (nonatomic, assign) NSUInteger rowIndex;
@property (nonatomic, assign) NSUInteger teamIndex;
@property (nonatomic, strong) MatchData *currentMatch;
@property (nonatomic, strong) TeamScore *currentTeam;
@property (nonatomic, strong) NSArray *teamData;
@property (nonatomic, assign) BOOL dataChange;
@property (nonatomic, assign) NSString *storePath;
@property (nonatomic, strong) NSFileManager *fileManager;

// Match Control
@property (nonatomic, weak) IBOutlet UIButton *prevMatch;
@property (nonatomic, weak) IBOutlet UIButton *nextMatch;
-(NSUInteger)getMatchSectionInfo:(MatchType)matchSection;
-(int)getNumberOfMatches:(NSUInteger)section;
-(MatchData *)getCurrentMatch;

// User Access Control
typedef enum {
    NoOverride,
	OverrideDrawLock,
    OverrideMatchReset,
    OverrideAllianceSelection,
    OverrideTeamSelection,
} OverrideMode;

@property (nonatomic, strong) AlertPromptViewController *alertPrompt;
@property (nonatomic, strong) UIPopoverController *alertPromptPopover;
@property (nonatomic, assign) OverrideMode overrideMode;

-(IBAction)PrevButton;
-(IBAction)NextButton;
-(NSUInteger)GetNextSection:(MatchType) currentSection;
-(NSUInteger)GetPreviousSection:(NSUInteger) currentSection;

// Match Scores
@property (nonatomic, weak) IBOutlet UILabel *teamName;
@property (nonatomic, weak) IBOutlet UISlider *driverRating;
@property (nonatomic, weak) IBOutlet UISlider *defenseRating;
@property (nonatomic, weak) IBOutlet UISlider *robotSpeed;
@property (nonatomic, weak) IBOutlet UISwitch *attemptedClimb;
@property (nonatomic, strong) UISegmentedControl *climbLevel;
@property (nonatomic, weak) IBOutlet UITextField *notes;
@property (nonatomic, weak) IBOutlet UIButton *matchResetButton;
@property (nonatomic, weak) IBOutlet UIButton *climbTimerButton;
-(IBAction)matchResetRequest:(id) sender;
-(void)matchReset;
-(IBAction)updateDriverRating:(id) sender;
-(IBAction)updateDefenseRating: (id) sender;
-(IBAction)updateRobotSpeed: (id) sender;
-(IBAction)toggleForClimbAttempt: (id) sender;
-(void)setClimbSegment: (id) sender;
-(IBAction)climbTimerStart:(id)sender;
-(IBAction)climbTimerStop:(id) sender;
- (void)timerFired;

-(IBAction)scoreButtons: (id)sender;
@property (nonatomic, weak) IBOutlet UIButton *teleOpMissButton;
@property (nonatomic, weak) IBOutlet UIButton *teleOpHighButton;
@property (nonatomic, weak) IBOutlet UIButton *teleOpMediumButton;
@property (nonatomic, weak) IBOutlet UIButton *teleOpLowButton;
@property (nonatomic, weak) IBOutlet UIButton *autonMissButton;
@property (nonatomic, weak) IBOutlet UIButton *autonHighButton;
@property (nonatomic, weak) IBOutlet UIButton *autonMediumButton;
@property (nonatomic, weak) IBOutlet UIButton *autonLowButton;
@property (nonatomic, weak) IBOutlet UIButton *pyramidGoalsButton;
@property (nonatomic, weak) IBOutlet UIButton *passesButton;
@property (nonatomic, weak) IBOutlet UIButton *blocksButton;
@property (nonatomic, weak) IBOutlet UIButton *wallPickUpsButton;
@property (nonatomic, weak) IBOutlet UIButton *floorPickUpsButton;
@property (nonatomic, weak) IBOutlet UIButton *wall1Button;
@property (nonatomic, weak) IBOutlet UIButton *wall2Button;
@property (nonatomic, weak) IBOutlet UIButton *wall3Button;
@property (nonatomic, weak) IBOutlet UIButton *wall4Button;
@property (nonatomic, strong) PopUpPickerViewController *scoreButtonReset;
@property (nonatomic, strong) NSMutableArray *scoreButtonChoices;
@property (nonatomic, strong) UIPopoverController *scoreButtonPickerPopover;
@property (nonatomic, strong) ValuePromptViewController *valuePrompt;
@property (nonatomic, strong) UIPopoverController *valuePromptPopover;

-(void)teleOpMiss:(NSString *)choice;
-(void)teleOpHigh:(NSString *)choice;
-(void)teleOpMedium:(NSString *)choice;
-(void)teleOpLow:(NSString *)choice;
-(void)autonMiss:(NSString *)choice;
-(void)autonHigh:(NSString *)choice;
-(void)autonMedium:(NSString *)choice;
-(void)autonLow:(NSString *)choice;
-(void)pyramidGoals;
-(void)blockedShots;
-(void)passesMade;
-(IBAction)wallPickUpsMade:(id) sender;
-(void)floorPickUpsMade;
-(void)promptForValue:(UIButton *)button;

// Overall Match Scores
@property (nonatomic, weak) IBOutlet UITextField *redScore;
@property (nonatomic, weak) IBOutlet UITextField *blueScore;

// Match Number
@property (nonatomic, weak) IBOutlet UITextField *matchNumber;
-(IBAction)MatchNumberChanged;

// Match Type
@property (nonatomic, weak) IBOutlet UIButton *matchType;
@property (nonatomic, strong) NSMutableArray *matchTypeList;
@property (nonatomic, strong) MatchTypePickerController *matchTypePicker;
@property (nonatomic, strong) UIPopoverController *matchTypePickerPopover;
-(IBAction)MatchTypeSelectionChanged:(id)sender;
-(NSMutableArray *)getMatchTypeList;

// Alliance Picker
@property (nonatomic, weak) IBOutlet UIButton *alliance;
@property (nonatomic, strong) NSMutableArray *allianceList;
@property (nonatomic, strong) AlliancePickerController *alliancePicker;
@property (nonatomic, strong) UIPopoverController *alliancePickerPopover;
-(IBAction)AllianceSelectionChanged:(id)sender;
-(void)AllianceSelectionPopUp;

// Team Picker
-(IBAction)TeamSelectionChanged:(id)sender;
-(void)TeamSelectionPopUp;
@property (nonatomic, weak) IBOutlet UIButton *teamNumber;
@property (nonatomic, strong) NSMutableArray *teamList;
@property (nonatomic, strong) TeamPickerController *teamPicker;
@property (nonatomic, strong) UIPopoverController *teamPickerPopover;

// Other Stuff
@property (nonatomic, weak) IBOutlet UIButton *matchListButton;
@property (nonatomic, weak) IBOutlet UIButton *teamEdit;
@property (nonatomic, weak) IBOutlet UIButton *syncButton;
@property (nonatomic, assign) id<MainScoutingPageDelegate> delegate;
- (NSString *)applicationDocumentsDirectory;

// Make It Look Good
-(void)SetTextBoxDefaults:(UITextField *)textField;
-(void)SetBigButtonDefaults:(UIButton *)currentButton;
-(void)SetSmallButtonDefaults:(UIButton *)currentButton;
// Data Handling
-(void)ShowTeam:(NSUInteger)currentTeamIndex;
-(TeamScore *)GetTeam:(NSUInteger)currentTeamIndex;
-(void)setTeamList;
-(void)CheckDataStatus;

// Match Drawing
typedef enum {
	DrawOff,
	DrawAuton,
	DrawTeleop,
    DrawDefense,
    DrawLock,
} DrawingMode;

@property (nonatomic, weak) IBOutlet UIImageView *fieldImage;
@property (nonatomic, weak) IBOutlet UIView *imageContainer;
@property (nonatomic, assign) BOOL fieldDrawingChange;
@property (nonatomic, strong) NSMutableArray *scoreList;
@property (nonatomic, strong) RecordScorePickerController *scorePicker;
@property (nonatomic, strong) UIPopoverController *scorePickerPopover;
@property (nonatomic, strong) NSMutableArray *defenseList;
@property (nonatomic, strong) DefensePickerController *defensePicker;
@property (nonatomic, strong) UIPopoverController *defensePickerPopover;
@property (nonatomic, assign) int popCounter;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) DrawingMode drawMode;
@property (nonatomic, weak) IBOutlet UIButton *drawModeButton;
@property (nonatomic, weak) IBOutlet UIButton *eraserButton;

-(void)floorDiskPickUp:(UITapGestureRecognizer *)gestureRecognizer;
-(void)scoreDisk:(UITapGestureRecognizer *)gestureRecognizer;
-(void)drawPath:(UIPanGestureRecognizer *)gestureRecognizer;
-(void)drawText:(NSString *) marker location:(CGPoint) point;
-(CGPoint)scorePopOverLocation:(CGPoint)location;
-(CGPoint)defensePopOverLocation:(CGPoint)location;
-(IBAction)drawModeChange: (id)sender;
-(IBAction)eraserPressed:(id)sender;

-(void)drawModeSettings:(DrawingMode) mode;
-(void)checkOverrideCode:(UIButton *)button;
-(void)checkAdminCode:(UIButton *)button;

@end