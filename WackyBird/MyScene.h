//
//  MyScene.h
//  WackyBird
//

//  Copyright (c) 2014 AR Creative. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property (nonatomic, assign) float gravity;
@property (nonatomic, assign) float velocity;
@property (nonatomic, assign) float flapVelocity;
@property (nonatomic, assign) int groundHeight;

@end
