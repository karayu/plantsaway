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
        
        [self loadDatafromURL];
        /*
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
        }*/
    }
    return self;
}



-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading"); //nothing showing here
    NSString *message = [[NSString alloc] initWithFormat:@"Succeeded! Received %d bytes of data",[self.receivedData length]];
    NSLog(@"%@", message);
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullName = [NSString stringWithFormat:@"quotes.csv"];
    
    fullFilePath = [NSString stringWithFormat:@"%@/%@",docDir,fullName];
    [self.receivedData writeToFile:fullFilePath atomically:YES];
    [self writeToFile];
    
} 

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data2: %@", myString);
    
    if (self.receivedData)
        [self.receivedData appendData:data];
    else 
        self.receivedData = [[NSMutableData alloc] initWithData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"%@", [error description]);
}

- (void)loadDatafromURL
{    
    NSString *urlString = @"http://hcs.harvard.edu/~organizations/soap/test.csv";
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//saves the scores to the plist
- (void)saveScores
{
    //[self.highScores writeToFile: [self.filePath stringByAppendingString: @".plist"] atomically:YES];
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
