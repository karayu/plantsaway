//
//  HighScoresLayer.m
//  PlantsAway
//
//  Created by Brooke Griffin on 4/23/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//
//  sources for NSURL help: 
//  Apple Dev & http://cagt.bu.edu/w/images/8/8b/URL_Connection_example.txt

#import "HighScoresLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"

@implementation HighScoresLayer

@synthesize highScores, fullFilePath;

//global constant
NSString *HighScoreFileName = @"scores";
int MaxHighScores = 10;


+(CCScene *) scene
{
	//initialize scene
	CCScene *scene = [CCScene node];
	
	//initialize layer
    HighScoresLayer *layer =  [HighScoresLayer node];
    
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}

-(id)init
{
	//always call "super" init
	if( (self=[super init])) 
    {
        //create a dummy label to take up space for now
        highScoresLabel = [CCLabelTTF labelWithString:@"HIGH SCORES WILL GO HERE!" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        highScoresLabel.position = ccp( 160, 200 ); 
        [self addChild:highScoresLabel];
        
        //button for returning to pause menu
        CCMenuItemFont *goBack = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(goBack:)];
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:goBack, nil];
        menu.position = ccp( 160, 50 );
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
                
        
        //figures out where high scores list is kept
        if (! self.fullFilePath)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex: 0];
            self.fullFilePath = [docDir stringByAppendingPathComponent: HighScoreFileName];
        }
        
        //initializes high scores list
        if (!self.highScores)
        {
            [self loadScores];
        }
        
        [self saveScores];
        
        [self loadScores];

    }
    return self;
}



//load the plist of high scores
- (void)loadScores
{    
    //sees if we can find the plist and load it

    self.highScores = [[NSMutableArray alloc] initWithContentsOfFile: [self.fullFilePath stringByAppendingString: @".plist"]];
    
    //otherwise, initialize an empty high scores array
    if (! self.highScores) 
    {
        self.highScores = [[NSMutableArray alloc] init];
        
    }
}


//saves the scores to the plist
- (void)saveScores
{    
    [self.highScores writeToFile: [self.fullFilePath stringByAppendingString: @".plist"] atomically:YES];
}



//go back to pause menu
-(void)goBack: (id)sender
{
    [[CCDirector sharedDirector] popScene];
}

//depending on how high the score is, adds the high score to the high scores table, in the right position
//taken from Project 2
- (BOOL)addHighScore: (int)score
{
    NSNumber *newScore = [[NSNumber alloc] init];
    newScore = [NSNumber numberWithInt:score];
    
    //add score to the high scores array
    [self.highScores addObject: newScore];
    
    //sort the high scores array... descending - http://stackoverflow.com/questions/3749657/nsmutablearray-arraywitharray-vs-initwitharray
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    NSArray *sorted = [self.highScores sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    self.highScores = [[NSMutableArray alloc] initWithArray:sorted];
    
    //if we have too many scores, delete the smallest one
    if ((int)[self.highScores count] > MaxHighScores ) 
    {
        [self.highScores removeLastObject];
        
    }
    return YES;
}


@end
