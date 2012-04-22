//
//  MainLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MainLayer.h"
#import "CCTouchDispatcher.h"

CCSprite *oldLady;
CCSprite *plant;
CCSprite *movingTarget;
//CCLabelAtlas* scoreLabel;


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
		
		// TIP: cocos2d and chipmunk uses the same struct to store its position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

// HelloWorldLayer implementation
@implementation MainLayer

@synthesize plantActive;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	if( (self=[super init])) {
		
        // initiate the menu
        


		//CCMenuItemLabel *label = [CCMenuItemLabel itemWithLabel:@"0" target:self selector:@selector(menuCallbackConfig:)];
        /*scoreLabel = [[CCLabelAtlas alloc] initWithString:@"20" charMapFile:@"fps_images.png" itemWidth:6 itemHeight:8 startCharMap:'2'];
        
        [scoreLabel setPosition:ccp(160, 420)];
        [scoreLabel setString:[NSString stringWithFormat:@"20"]]; 

        [self addChild:scoreLabel];*/

        score = 0;
        
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:@"20" fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = ccp(160, 420 ); //Middle of the screen...
        [self addChild:scoreLabel z:1];
        
        //CCMenuItemLabel *labelItem1 = [CCMenuItemLabel itemWithLabel:scoreLabel];
        //[labelItem1 setTag:111];
        
        //CCMenu *myMenu = [CCMenu menuWithItems:  labelItem1, nil];
        //[self addChild:myMenu];

        
        // initiate the background
        CCSprite *background = [CCSprite spriteWithFile: @"bg.png"];
        background.position = ccp(160, 187  ); //187
        [self addChild:background];
        [background setScale:0.225];
                
        // initiate our old lady
        oldLady = [CCSprite spriteWithFile: @"old1.png"];
        oldLady.position = ccp( 160, 300 );
        [self addChild:oldLady];
        [oldLady setScale:0.5];
        
        // initiate her plant
        plant = [CCSprite spriteWithFile: @"flower.png"];
        plant.position = ccp( 160, 300 );
        [self addChild:plant];
        [plant setScale:0.5];
        plantActive = NO;  //our finger is not currrently on the plant

        // initial passerby
        movingTarget = [CCSprite spriteWithFile: @"hoodlum.png"];
        movingTarget.position = ccp( 0, 50 );
        [self addChild:movingTarget];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		

		cpInitChipmunk();
        [self schedule:@selector(nextFrame:)];		
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	cpSpaceFree(space);
	space = NULL;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void) nextFrame:(ccTime)dt {
    
    movingTarget.position = ccp( movingTarget.position.x + 20*dt, movingTarget.position.y );
    if (movingTarget.position.x > 480+32) {
        movingTarget.position = ccp( -32, movingTarget.position.y );
    }
    
    if (plantActive) {
        
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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if (CGPointEqualToPoint(location, plant.position)) {
        plantActive = YES;
    }
    
    return YES;
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (plantActive) {
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        plant.position = location;

    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    plantActive = NO;
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
 
    [oldLady stopAllActions];
    
    //need logic around duration given location
    
    
    [oldLady runAction: [CCMoveTo actionWithDuration:2 position:location]];
 
 
 
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
