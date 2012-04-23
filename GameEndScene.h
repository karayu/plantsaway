//
//  GameEndScene.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCScene.h"
#import "GameEndLayer.h"


@interface GameEndScene : CCScene
{
    GameEndLayer *gameEndLayer; 
}

-(void) menuWillClose:(id)sender;



@end
