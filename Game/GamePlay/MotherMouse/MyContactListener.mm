//
//  MyContactListener.m
//  Box2DPong
//
//  Created by Ray Wenderlich on 2/18/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "MyContactListener.h"


MyContactListener::MyContactListener() : _contacts() {
    soundEffect=[[sound alloc] init];
    [soundEffect initSound];
    ballAnim=0;
    ballLost=0;
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact* contact) {
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
	
    int32 count = contact->GetManifold()->pointCount;
    float32 maxImpulse = 0.0f;
    for (int32 i = 0; i < count; ++i) {
        maxImpulse = b2Max(maxImpulse, impulse->normalImpulses[i]);
    }
    
    //NSLog(@"maxImpulse: %f", maxImpulse);
    if(maxImpulse > 0.03f) {
        maxImpulse = maxImpulse * 8.0f;
        if(maxImpulse > 0.3f)
            maxImpulse = 0.3f;
        b2Body *bodyA = contact->GetFixtureA()->GetBody();
		b2Body *bodyB = contact->GetFixtureB()->GetBody();
		CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
		CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
        if (spriteA.tag == 3 && (spriteB.tag == 1||spriteB.tag == 11||spriteB.tag == 21)) {
            ballAnim=1;
            animX=bodyB->GetPosition().x;
            animY=bodyB->GetPosition().y;
        }
    }
}

