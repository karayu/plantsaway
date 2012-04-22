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
CCSprite *goodTarget;
CCSprite *badTarget;

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

@synthesize plantActive, goodCollision, badCollision;

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
        

		//CCMenuItemLabel *label = [CCMenuItemLabel itemWithLabel:@"0" target:self selector:@selector(menuCallbackConfig:)];
        CCMenu *myMenu = [CCMenu menuWithItems: nil];
        [self addChild:myMenu];

        
        //initiate the background
        CCSprite *background = [CCSprite spriteWithFile: @"bg.png"];
        background.position = ccp(160, 187);
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

        //initialize mommy and baby
        goodTarget = [CCSprite spriteWithFile: @"mom2.png"];
        goodTarget.position = ccp( 0, 50 );
        [self addChild:goodTarget];
        [goodTarget setScale:0.75];
        
        //initialize hoodlum
        badTarget = [CCSprite spriteWithFile: @"hoodlum.png"];
        badTarget.position = ccp( 500, 50 );
        [self addChild:badTarget];
        [badTarget setScale:0.75];
        
        //initialize bools: currently no intersection of sprites
        goodCollision = NO;
        badCollision = NO;
        
        //our finger is not currrently on the plant
        plantActive = NO;  
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		

		cpInitChipmunk();
        [self schedule:@selector(nextFrameGoodTarget:)];		
        [self schedule:@selector(nextFrameBadTarget:)];	
    }
	return self;
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

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void) nextFrameGoodTarget:(ccTime)dt 
{
    //detect intersection of target and plant
    if (CGRectIntersectsRect(goodTarget.boundingBox, plant.boundingBox))
    {
        goodTarget.rotation = -90;
        goodCollision = YES;
    }
    else 
    {
        goodTarget.position = ccp( goodTarget.position.x + 20*dt, goodTarget.position.y );
        if (goodCollision || goodTarget.position.x > 480+32) 
        {
            goodCollision = NO;
            goodTarget.rotation = 0;
            goodTarget.position = ccp( -32, goodTarget.position.y );
        }    
    }
}

- (void) nextFrameBadTarget:(ccTime)dt 
{
    //detect intersection of target and plant
    if (CGRectIntersectsRect(badTarget.boundingBox, plant.boundingBox))
    {
        badTarget.rotation = -90;
        badCollision = YES;
    }
    else 
    {
        badTarget.position = ccp( badTarget.position.x - 20*dt, badTarget.position.y );
        if (badCollision || badTarget.position.x < -480-32) 
        {
            badCollision = NO;
            badTarget.rotation = 0;
            badTarget.position = ccp( 480+32, badTarget.position.y );
        }    
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
    if (plant.position.y < 0)
        plant.position = oldLady.position;
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
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
        //shows oldLady lifting plant above her head
        int newPlantY = oldLady.position.y + 30;
        CGPoint location = ccp(oldLady.position.x, newPlantY);
        plant.position = location;
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //set location for oldLady 
    CGPoint oldLadyLocation = [self convertTouchToNodeSpace: touch];
    oldLadyLocation.y = 300;
    
    [oldLady stopAllActions];
    
    //need logic around duration given location
    
    oldLady.texture = oldLadyTexture1;
    [oldLady runAction: [CCMoveTo actionWithDuration:2 position:oldLadyLocation]];
    
    CGPoint plantDestination = ccp( oldLadyLocation.x, -50 );
    if ((plant.position.y > 0) && plantActive)
        [plant runAction: [CCMoveTo actionWithDuration:2 position:plantDestination]]; 
    else if (plant.position.y == oldLadyLocation.y)
        [plant runAction: [CCMoveTo actionWithDuration:2 position:oldLadyLocation]];
    
    plantActive = NO;
    
    
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
