//
//  HighScoresLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface HighScoresLayer : CCLayer
{
    CCLabelTTF *highScoresLabel;
}

//variables to return to pause menu & eventually resume game
@property int score;
@property int time;

//variables for NSURL connection
@property (strong) NSString *deviceID;
@property (strong) NSMutableData *receivedData;

//functionality of high scores layer
-(void)findDeviceID;
-(void)pauseMenu:(id)sender;

//NSURL functionality
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end