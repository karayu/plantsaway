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

+(CCScene *) scene;

//high score file name
extern NSString *HighScoreFileName;


//variables for NSURL connection
@property (strong) NSString *deviceID;
@property (strong) NSString *fullFilePath;
@property (strong) NSMutableData *receivedData;
@property (strong) NSMutableDictionary *highScores;

//functionality of high scores layer
-(void)findDeviceID;
-(void)goBack: (id)sender;

//-(void)pauseMenu:(id)sender;

//NSURL functionality
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end