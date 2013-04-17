/* Copyright (c) 2013 Scott Lembcke and Howling Moon Software
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "HelloWorldLayer.h"
#import "AppDelegate.h"

#import "ConcaveSprite.h"

@implementation HelloWorldLayer {
	ChipmunkSpace *_space;
	CCPhysicsDebugNode *_debugNode;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	[scene addChild:[HelloWorldLayer node]];
	
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
		_space = [[ChipmunkSpace alloc] init];
		_space.gravity = cpv(0, -100);
		
		CGRect rect = {CGPointZero, [CCDirector sharedDirector].winSize};
		[_space addBounds:rect thickness:10.0 elasticity:1.0 friction:0.0 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:nil];
		
		_debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
		[self addChild:_debugNode z:1000];
		
		[self addStarAt:ccp(210, 220)];
		[self addStarAt:ccp(270, 220)];
		[self addStarAt:ccp(180, 100)];
		[self addStarAt:ccp(240, 100)];
		[self addStarAt:ccp(300, 100)];
	}
	
	return self;
}

-(void)addStarAt:(CGPoint)point
{
	ConcaveSprite *sprite = [ConcaveSprite spriteWithFile:@"Star.png"];
	sprite.position = point;
	sprite.elasticity = 1.0;
	[self addChild:sprite];
	[_space add:sprite];
}

-(void)onEnter
{
	[super onEnter];
	
	[self scheduleUpdate];
}

-(void)update:(ccTime)delta
{
	// Just doing a dumb fixed update here...
	[_space step:1.0/60.0];
	
	for(ChipmunkBody *body in _space.bodies){
		[_debugNode drawDot:body.pos radius:10.0 color:ccc4f(0, 0, 1, 1)];
	}
}

@end
