//
//  MyScene.m
//  WackyBird
//
//  Created by Adam Robertson on 2/12/14.
//  Copyright (c) 2014 AR Creative. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        //Set view properties
        self.backgroundColor = [SKColor colorWithRed:0.33 green:0.75 blue:0.79 alpha:1.0];
        
        //Set constants
        self.gravity = -0.35;
        self.flapVelocity = 6.5;
        self.groundHeight = 40;
        
        //Create bird
        [self resetScene];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.velocity = self.flapVelocity;
    
    
    
    [self spawnPipes];

}

-(void)update:(CFTimeInterval)currentTime {
    //TODO: Use the timer, this won't work for slower/faster devices
    
    //Get bird
    SKNode *bird = [self childNodeWithName:@"bird"];
    
    //Apply gravity
    self.velocity += self.gravity;
    
    //Move to new location
    [bird runAction:[SKAction moveByX:0.0 y:self.velocity duration:0.0]];
    
    //Update pipe location
    [self updatePipes];
}

-(NSArray*)spawnPipes {
    SKNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"Pipe"];
    SKNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"Pipe"];
    topPipe.name = @"pipe";
    bottomPipe.name = @"pipe";
    
    //Define gap location
    NSInteger gapLocation = arc4random()%100 - 50;
    
    //Rotate top pipe
    [topPipe runAction:[SKAction rotateToAngle:M_PI duration:0]];
    
    //Positioning
    topPipe.position = CGPointMake(CGRectGetMaxX(self.frame) + CGRectGetWidth(topPipe.frame) / 2, CGRectGetMaxY(self.frame) + gapLocation);
    bottomPipe.position = CGPointMake(CGRectGetMaxX(self.frame) + CGRectGetWidth(topPipe.frame) / 2, CGRectGetMinY(self.frame) + gapLocation);
    
    
    //Add pipes to view
    [self addChild:topPipe];
    [self addChild:bottomPipe];
    
    return @[topPipe, bottomPipe];
}

-(void)updatePipes {
    for (SKNode *node in [self children]) {
        if ([node.name isEqual:@"pipe"]) {
            if (CGRectGetMinX(node.frame) < -CGRectGetWidth(node.frame)) {
                [node removeFromParent];
            } else {
                [node runAction:[SKAction moveByX:-2 y:0 duration:0.0]];
            }
        }
    }
}

-(void)resetScene {
    //Remove old birdie
    SKNode *oldBird = [self childNodeWithName:@"bird"];
    if (oldBird.name != nil) {
        [self removeChildrenInArray:@[oldBird]];
    }
    
    //Remove old pipes
    for (SKNode *node in [self children]) {
        if ([node.name isEqual:@"pipe"]) {
            [node removeFromParent];
        }
    }
    
    //Set/reset variables
    self.velocity = 0.0;
    
    //Spawn birdie
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    bird.name = @"bird";
    bird.position = CGPointMake(CGRectGetWidth(self.frame) * 0.3, CGRectGetMidY(self.frame));
    [self addChild:bird];
}

@end
