//
//  GameScene.swift
//  tap_test
//
//  Created by Alex Zaykowski on 7/5/15.
//  Copyright (c) 2015 Alex Zaykowski. All rights reserved.
//  This code is really bad right now it will change
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let shape = SKShapeNode(circleOfRadius: 20)
    let enemy = SKShapeNode(circleOfRadius: 15)
    let time = SKLabelNode(text:"")
    let tb = SKLabelNode(text: "")
    var count = 0
    var start = false
    var timer = NSTimer()
    
    var dtimer = NSTimer()
    var dcount = 6
 
    
    enum ColliderType:UInt32{
        case hero = 1
        case badguy = 2
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -6)
        let  physicsBody = SKPhysicsBody (edgeLoopFromRect: self.frame)
        self.physicsBody = physicsBody
        self.backgroundColor = UIColor.whiteColor()
        dtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("cdtimer"), userInfo: nil, repeats: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        addtb()
        addPlayer()
        addEnemy()
        addtimer()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let move = SKAction.moveTo(location, duration: 1.0)
            let move_enemy = SKAction.moveTo(location, duration: 1.6)
            shape.runAction(move)
            enemy.runAction(move_enemy)
        }
    }
    
    func updateTimer(){
        if start == true{
            count += 1
            time.text = "Timer: "+String(count)
        }
    }
    
    func cdtimer(){
        if dcount > 0{
            dcount -= 1
            tb.text = String(dcount)
            self.view!.userInteractionEnabled = false
        }else{
            start = true
            tb.text = ""
            self.view!.userInteractionEnabled = true
        }
    }
    
    func addPlayer(){
        
        shape.zPosition = 1
        shape.fillColor = UIColor.blueColor()
        shape.lineWidth = 4
        shape.position = CGPoint (x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 20.0);
        shape.physicsBody!.dynamic = true
        shape.physicsBody!.affectedByGravity = false
        shape.physicsBody!.categoryBitMask = ColliderType.hero.rawValue
        shape.physicsBody!.contactTestBitMask = ColliderType.badguy.rawValue
        shape.physicsBody!.collisionBitMask = ColliderType.badguy.rawValue
        
        self.addChild(shape)
    }
    
    func addEnemy(){
        
        enemy.zPosition = 1
        enemy.fillColor = UIColor.redColor()
        enemy.lineWidth = 0
        enemy.position = CGPoint (x:CGRectGetMaxX(self.frame),y:CGRectGetMaxY(self.frame))
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 15.0);
        enemy.physicsBody!.dynamic = true
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = ColliderType.badguy.rawValue
        
        self.addChild(enemy)
    }
    
    func addtimer(){
        time.position = CGPoint(x: CGRectGetMidX(self.frame)-160, y: CGRectGetMidY(self.frame)+360)
        time.fontName = "Arial"
        time.fontSize = 24
        time.fontColor = UIColor.blackColor()
        time.text = ""
        
        self.addChild(time)
    }
    
    func addtb(){
        
        // configure touhch to begin node
        tb.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        tb.fontName = "Arial"
        tb.zPosition = 2
        tb.fontSize = 120
        tb.fontColor = UIColor.blackColor()
        
        self.addChild(tb)
    }

    func didBeginContact(contact: SKPhysicsContact) {
        println("COLLISION")
        timer.invalidate()
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
