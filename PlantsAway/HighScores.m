//
//  HighScores.m
//  PlantsAway
//
//  Created by Kara Yu on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScores.h"

@implementation HighScores

@synthesize scores, fullFilePath;

//global constant
NSString *HighScoreFileName = @"scores";
int MaxHighScores = 10;

-(id)init
{
	//always call "super" init
	if( (self=[super init])) 
    {
          
        //figures out where high scores list is kept
        if (! self.fullFilePath)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex: 0];
            self.fullFilePath = [docDir stringByAppendingPathComponent: HighScoreFileName];
        }
        
        //initializes high scores list
        if (!self.scores)
        {
            [self loadScores];
        }
        
    }
    return self;
}

//load the plist of high scores
- (void)loadScores
{    
    //sees if we can find the plist and load it
    
    self.scores = [[NSMutableArray alloc] initWithContentsOfFile: [self.fullFilePath stringByAppendingString: @".plist"]];
    
    //otherwise, initialize an empty high scores array
    if (! self.scores) 
    {
        self.scores = [[NSMutableArray alloc] init];
        
    }
}

//saves the scores to the plist
- (void)saveScores
{    
    [self.scores writeToFile: [self.fullFilePath stringByAppendingString: @".plist"] atomically:YES];
}

//depending on how high the score is, adds the high score to the high scores table, in the right position & saves it to file
//taken from Project 2
- (BOOL)addHighScore: (int)score
{
    NSNumber *newScore = [[NSNumber alloc] init];
    newScore = [NSNumber numberWithInt:score];
    
    //add score to the high scores array
    [self.scores addObject: newScore];
    
    //sort the high scores array... descending - http://stackoverflow.com/questions/3749657/nsmutablearray-arraywitharray-vs-initwitharray
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    NSArray *sorted = [self.scores sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    self.scores = [[NSMutableArray alloc] initWithArray:sorted];
    
    //if we have too many scores, delete the smallest one
    if ((int)[self.scores count] > MaxHighScores ) 
    {
        [self.scores removeLastObject];
        
    }
    
    [self saveScores];
    return YES;
}


@end


