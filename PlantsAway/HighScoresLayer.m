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

@synthesize deviceID, receivedData, highScores, fullFilePath;

//global constant
NSString *HighScoreFileName = @"scores";


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


//saves the scores to the plist
- (void)saveScores
{
    [self.highScores writeToFile:[self.fullFilePath stringByAppendingString: @".cvs"] atomically:YES];
}

-(void)showScores
{
    NSString *source = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
   // NSData* plistData = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
    //NSPropertyListFormat format;
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:source];
    NSLog( @"plist is %@", plist );
    if(!plist){
        NSLog(@"Error: %@",error);
        [error release];
    }
}


//load the plist of high scores
- (void)loadScores
{    
    //sees if we can find the plist and load it

    self.highScores = [[NSMutableDictionary alloc] initWithContentsOfFile: [self.fullFilePath stringByAppendingString: @".plist"]];
    
    //otherwise, initialize an empty high scores array
    if (! self.highScores) 
    {
        self.highScores = [[NSMutableDictionary alloc] init];
        
    }
    
    //button for returning to pause menu
    CCMenuItemFont *score.i = [CCMenuItemFont itemFromString:@"back"];
    
    //create menu to display scores
    CCMenu *menu = [CCMenu menuWithItems:goBack, nil];
    menu.position = ccp( 300, 50 );
    [menu alignItemsVerticallyWithPadding: 1.0f];
    [self addChild:menu z: 1];
}


//go back to pause menu
-(void)goBack: (id)sender
{
    [[CCDirector sharedDirector] popScene];

	//[SceneManager goPause];
}


//gets this device's unique ID
-(void)findDeviceID
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    self.deviceID = uniqueIdentifier;
}

-(void)writeToFile
{

}


#pragma mark NSURLConnection methods

/*-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it has enough information to create the NSURLResponse.
    [self.receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.    
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    // inform the user that connection failed
    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [didFailWithErrorMessage show];
	
    //info on failed connection NSLog'd:
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    //alert the user that NSURL connection is working
    NSString *message = [[NSString alloc] initWithFormat:@"Succeeded! Received %d bytes of data",[self.receivedData length]];
    
    UIAlertView *finishedLoadingMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message:message  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [finishedLoadingMessage show];
}

*/

@end
