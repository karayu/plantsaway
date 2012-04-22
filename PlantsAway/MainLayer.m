//
//  MainLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


//Import the interfaces
#import "MainLayer.h"
#import "CCTouchDispatcher.h"

CCSprite *oldLady;
CCSprite *plant;
CCSprite *movingTarget;
CCSprite *hourGlass;



enum {
	kTagBatchNode = 1,
};

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		//TIP: cocos2d and chipmunk uses the same struct to store its position
		//chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		//since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

//MainLayer implementation
@implementation MainLayer

@synthesize plantActive;

+(CCScene *) scene
{
	//'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	//'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}


//on "init" you need to initialize your instance
-(id) init
{
	//always call "super" init
	if( (self=[super init])) 
    {
		
        //initiate the menu

        score = 0;
        
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:@"0 pts" fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = ccp(160, 440 ); //Middle of the screen...
        [self addChild:scoreLabel];
        
        //Create and add pause button as a child
        CCMenuItem *pauseMenuItem = [CCMenuItemImage 
                                    itemFromNormalImage: @"pause.png" selectedImage:@"pause.png" 
                                    target:self selector:@selector(pauseTapped)];
        pauseMenuItem.position = ccp(350, 530);
        CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        pauseMenu.position = CGPointZero;
        [self addChild:pauseMenu];
        [pauseMenu setScale:0.7];

        //hour glass
        hourGlass = [CCSprite spriteWithFile: @"hourglass.png"];
        hourGlass.position = ccp( 20, 440 );
        [self addChild:hourGlass];
        [hourGlass setScale:0.05];
        
        timeLabel = [CCLabelTTF labelWithString:@"100" fontName:@"Marker Felt" fontSize:24];
        timeLabel.position = ccp(50, 440 ); //Middle of the screen...
        [self addChild:timeLabel];
        [self schedule: @selector(tick:) interval:1.0];
        time = 100; 


        //initiate the background
        CCSprite *background = [CCSprite spriteWithFile: @"bg.png"];
        background.position = ccp(160, 187  ); //187
        [self addChild:background];
        [background setScale:0.24];
            
        //initiate images for oldLady's two positions
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        oldLadyTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old2.png"]];
        
        //initiate oldLady
        oldLady = [CCSprite spriteWithTexture:oldLadyTexture1];
        oldLady.position = ccp( 160, 300 );
        [self addChild:oldLady];
        [oldLady setScale:0.5];
        
        //initiate her plant
        plant = [CCSprite spriteWithFile: @"flower.png"];
        plant.position = ccp( 160, 300 );
        [self addChild:plant];
        [plant setScale:0.5];
        plantActive = NO;  //our finger is not currrently on the plant
        
        //initial passerby
        movingTarget = [CCSprite spriteWithFile: @"hoodlum2.png"];
        movingTarget.position = ccp( 0, 50 );
        [self addChild:movingTarget];
        [movingTarget setScale:0.75];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		

		cpInitChipmunk();
        [self schedule:@selector(nextFrame:)];		
	}
	return self;
}


-(void) tick: (ccTime) dt
{
    time = time - dt/2;
    [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
}


//on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	//in case you have something to dealloc, do it in this method
	cpSpaceFree(space);
	space = NULL;
	
	//don't forget to call "super dealloc"
	[super dealloc];
}

- (void) pauseTapped
{
    
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void) nextFrame:(ccTime)dt 
{
    
    movingTarget.position = ccp( movingTarget.position.x + 20*dt, movingTarget.position.y );
    if (movingTarget.position.x > 480+32) 
    {
        movingTarget.position = ccp( -32, movingTarget.position.y );
    }
    
    if (plantActive) 
    {
        
    }
}

/*
-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
}*/

//touch sensors
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    plant.position = location;

    
    if (CGRectContainsPoint(plant.boundingBox, location)) 
    {
        plantActive = YES;
        oldLady.texture = oldLadyTexture2;
    }
    
    return YES;
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{
    
    if(plantActive) 
    {
        CGPoint location = [touch locationInView: [touch view]];
        int newPlantY = oldLady.position.y + 30;
        location = ccp(oldLady.position.x, newPlantY);
        plant.position = location;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    plantActive = NO;
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
    location.y = 300;
    
    [oldLady stopAllActions];
    
    //need logic around duration given location
    
    oldLady.texture = oldLadyTexture1;
    [oldLady runAction: [CCMoveTo actionWithDuration:2 position:location]];
    
    CGPoint plantDestination = ccp( location.x, -20 );
    [plant runAction: [CCMoveTo actionWithDuration:2 position:plantDestination]]; 

    //[plant runAction: [CCMoveTo actionWithDuration:2 position:location]]; 
    
	/*for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteX: location.x y:location.y];
	}*/
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space->gravity = ccpMult(v, 200);
}
@end
