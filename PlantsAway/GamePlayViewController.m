//
//  GamePlayViewController.m
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePlayViewController.h"

@interface GamePlayViewController (){
@private
CGPoint _velocity;
}

@property (nonatomic, readwrite, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, readwrite, weak) IBOutlet UIImageView *oldLadyImage;
@property (nonatomic, readwrite, weak) IBOutlet UIImageView *plantImage;

@property (nonatomic, readwrite, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *scoreLabel;


@end

@implementation GamePlayViewController

@synthesize backgroundImage = _backgroundImage;
@synthesize oldLadyImage = _oldLadyImage;
@synthesize plantImage = _plantImage;
@synthesize timeLabel = _timeLabel;
@synthesize scoreLabel = _scoreLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//checks to see if number of guesses remaining is at zero; if so, user has lost and starts new game
- (void)checkEndGame
{
    //send user an alert if she is out of guesses
    if (self.numberOfGuesses == 0) 
    {
        //declare the string word
        NSString *losingWord;
        
        //get losing word from Evil or Good
        if (isEvil)
            losingWord = [self.Evil losingWord];
        else
            losingWord = [self.Good word];
        
        //create losing message that gives user the word they were not smart enough to guess
        NSString *losingMessage = [NSString stringWithFormat:@"In case you were wondering, your word was %@", losingWord];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YOU LOSE!" 
                                                            message:losingMessage
                                                           delegate:self 
                                                  cancelButtonTitle:@"New Game" 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        //refresh the view, initializing new settings and thus starting new game
        [self viewDidLoad];
    }
    //if won, calculate EVIL score based on dictionary used, word length, and factor in extra EVIL points
    else if (isEvil && [self.Evil checkGameWon]) 
    {
        //get score from Evil model and display it to user
        int score = [self.Evil calculateScore];
        [self.History addHighScore:score];
        [self.History saveScores];
        
        
        NSString *calculatedScore = [NSString stringWithFormat:@"Score: %d", score];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You win! Joseph Lives"
                                                            message:calculatedScore
                                                           delegate:self 
                                                  cancelButtonTitle:@"New Game" 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        //refresh the view, initializing new settings and thus starting new game
        [self viewDidLoad];        
    }
    //if won, calculate score based on dictionary, word length, and # of guesses
    else if (!isEvil && [self.Good checkGameWon])
    {        
        //get score from Good model and add it to user's high scores
        int score = [self.Good calculateScore];
        [self.History addHighScore:score];
        
        //display score to user too
        NSString *calculatedScore = [NSString stringWithFormat:@"Score: %d", score];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You win! Joseph Lives"
                                                            message:calculatedScore
                                                           delegate:self 
                                                  cancelButtonTitle:@"New Game" 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        //refresh the view, initializing new settings and thus starting new game
        [self viewDidLoad];        
    }
}*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backgroundImage = [[UIImageView alloc] init];

    NSLog(@"height: %@", self.backgroundImage.frame.size.height);
    
    NSLog(@"width: %@", self.backgroundImage.frame.size.width);

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
