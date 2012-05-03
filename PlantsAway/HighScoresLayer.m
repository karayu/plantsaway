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
        //create high scores header label
        highScoresLabel = [CCLabelTTF labelWithString:@"High Scores:" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        highScoresLabel.position = ccp( 160, 360 ); 
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
        
        [self saveScores];
        [self loadScores];

    }
    return self;
}



//load the plist of high scores
- (void)loadScores
{    
    //see if we can find the plist and load it
    self.highScores = [[NSMutableArray alloc] initWithContentsOfFile: [self.fullFilePath stringByAppendingString: @".plist"]];
    
    //otherwise, initialize an empty high scores array
    if (!self.highScores) 
    {
        self.highScores = [[NSMutableArray alloc] init];
    }
    
    //y-position
    int position = 360;
    
    //check if high scores exist
    if (self.highScores.count > 0)
    {
        
        for (NSNumber *score in self.highScores) 
        {
            //create label to display each score
            CCLabelTTF *newScore = [CCLabelTTF labelWithString:[score stringValue] fontName:@"Marker Felt" fontSize:16];
            newScore.position = ccp( 160, position );
            [self addChild:newScore];
            
            //decrease down for next score
            position -= 30;
        }
    }
    else 
    {
        //create a dummy label to take up space if there are no high scores
        CCLabelTTF *notify = [CCLabelTTF labelWithString:@"No high scores yet!!!" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:28 ];
        notify.position = ccp( 160, 200 ); 
        [self addChild:notify];
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

@end
