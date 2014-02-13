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
        
        //Reset scene
        [self resetScene];
        
        //Add background
        SKNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.zPosition = -101;
        background.name = @"background";
        [self addChild:background];
        
        //Create ground plane
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
        ground.anchorPoint = CGPointMake(0, 0);
        ground.position = CGPointMake(0, 0);
        ground.zPosition = 0;
        ground.name = @"ground";
        [self addChild:ground];
        
        //Add scene physics body
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, ground.frame.size.height - 5, self.frame.size.width, self.frame.size.height - ground.frame.size.height)];
        
        //Play
        [self play];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isPlaying) {
        return;
    }
    [self childNodeWithName:@"bird"].physicsBody.velocity = CGVectorMake(0, 450);
}

-(void)play {
    if (self.isPlaying) {
        return;
    }
    self.pipeSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(spawnPipes) userInfo:nil repeats:YES];
    self.isPlaying = YES;
}

-(void)stop {
    if (!self.isPlaying) {
        return;
    }
    [self.pipeSpawnTimer invalidate];
    self.pipeSpawnTimer = nil;
    self.isPlaying = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    if (!self.isPlaying) {
        return;
    }
    
    //Get nodes
    SKNode *bird = [self childNodeWithName:@"bird"];
    SKNode *ground = [self childNodeWithName:@"ground"];
    
    //Manage pipes
    [self enumerateChildNodesWithName:@"pipe" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < -CGRectGetWidth(node.frame)) {
            [node removeFromParent];
        } else {
            node.position = CGPointMake(node.position.x - 2, node.position.y);
        }
        if ([bird intersectsNode:node]) {
            [self stop];
        }
    }];
    
    //Manage ground
    if (ground.position.x == -24) {
        ground.position = CGPointMake(0, ground.position.y);
    } else {
        ground.position = CGPointMake(ground.position.x - 2, ground.position.y);
    }
    if ([ground intersectsNode:bird]) {
        [self stop];
    }
}

-(NSArray*)spawnPipes {
    SKNode *topPipe = [SKSpriteNode spriteNodeWithImageNamed:@"Pipe"];
    SKNode *bottomPipe = [SKSpriteNode spriteNodeWithImageNamed:@"Pipe"];
    topPipe.name = @"pipe";
    bottomPipe.name = @"pipe";
    
    //Define gap location
    NSInteger gapLocation = arc4random()%100 - 50;
    int gapSize = 50;
    int offset = 40;
    
    //Rotate top pipe
    [topPipe runAction:[SKAction rotateToAngle:M_PI duration:0]];
    
    //Positioning
    topPipe.position = CGPointMake(CGRectGetMaxX(self.frame) + CGRectGetWidth(topPipe.frame) / 2, CGRectGetMaxY(self.frame) + gapLocation + gapSize + offset);
    topPipe.zPosition = -1;
    bottomPipe.position = CGPointMake(CGRectGetMaxX(self.frame) + CGRectGetWidth(topPipe.frame) / 2, CGRectGetMinY(self.frame) + gapLocation - gapSize + offset);
    bottomPipe.zPosition = -1;
    
    //Add pipes to view
    [self addChild:topPipe];
    [self addChild:bottomPipe];
    
    return @[topPipe, bottomPipe];
}

-(void)resetScene {
    //Respawn birdie
    SKNode *oldBird = [self childNodeWithName:@"bird"];
    if (oldBird.name != nil) {
        [self removeChildrenInArray:@[oldBird]];
    }
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    bird.name = @"bird";
    bird.position = CGPointMake(CGRectGetWidth(self.frame) * 0.3, CGRectGetMidY(self.frame));
    bird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bird.size];
    [self addChild:bird];
    
    //Remove old pipes
    [self enumerateChildNodesWithName:@"pipe" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}

@end
