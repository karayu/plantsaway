//
//  Boost.m
//  PlantsAway
//
//  Created by Kara Yu on 12/3/12.
//
//

#import "Boost.h"

@implementation Boost

-(void) drawBoundingBox: (CGRect) rect
{
    CGPoint vertices[4]={
        ccp(rect.origin.x,rect.origin.y),
        ccp(rect.origin.x+rect.size.width,rect.origin.y),
        ccp(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height),
        ccp(rect.origin.x,rect.origin.y+rect.size.height),
    };
    ccDrawPoly(vertices, 4, YES);
}

-(void) draw
{
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // _world->DrawDebugData();
    
    glColor4f(1.0, 0, 0, 1.0);
    glLineWidth(1.0f);
    
    //[self drawBoundingBox: object1Rect];
    //[self drawBoundingBox: object2Rect];
    //keep adding for addition items
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    [super draw];
}


@end
