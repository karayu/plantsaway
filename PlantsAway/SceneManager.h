//
//  SceneManager.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneManager : NSObject
{
    
}

+(void) goMenu;
+(void) goPause;
+(void) goEndGame: (int) score;
+(void) goNewGame;




@end
