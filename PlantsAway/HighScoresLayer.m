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

@synthesize deviceID, receivedData;
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
        CCMenuItemFont *goBack = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(pauseMenu:)];
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:goBack, nil];
        menu.position = ccp( 160, 50 );
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
        
        //create the NSURL request - this will soon be a connection to our own web service
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        //create the connection with the request and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (theConnection) 
        {
            //create the NSMutableData to hold the received data
            self.receivedData = [[NSMutableData alloc] init];
        } 
        else
        {
            //inform the user that the connection failed
            UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in init"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [connectFailMessage show];
        }
    }
    return self;
}

//go back to pause menu
-(void)pauseMenu: (id)sender
{
	[SceneManager goPause];
}

//gets this device's unique ID
-(void)findDeviceID
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    self.deviceID = uniqueIdentifier;
}

#pragma mark NSURLConnection methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
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



@end
