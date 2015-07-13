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
    
    //booleans
    var game_over = false
    var start = false
    var moved = false
    
    //entities
    let shape = SKShapeNode(circleOfRadius: 20)
    let enemy = SKShapeNode(circleOfRadius: 15)
    let time = UILabel(frame: CGRectMake(0, 0, 100, 50))
    let tb = SKLabelNode()
    let restart = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    
    //timer vars
    var count = 0
    var timer = NSTimer()
    
    //countdown vars
    var dtimer = NSTimer()
    var dcount = 6
    
    //collider enum
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
        shape.zPosition = 1
        shape.fillColor = UIColor.blueColor()
        shape.lineWidth = 0
        shape.position = CGPoint (x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 20.0);
        shape.physicsBody!.dynamic = true
        shape.physicsBody!.affectedByGravity = false
        shape.physicsBody!.categoryBitMask = ColliderType.hero.rawValue
        shape.physicsBody!.contactTestBitMask = ColliderType.badguy.rawValue
        shape.physicsBody!.collisionBitMask = ColliderType.badguy.rawValue
        
        self.addChild(shape)
        
        addtb()
        addEnemy()
        addtimer()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            if game_over == false{
                moved = true
                let location = touch.locationInNode(self)
                let move = SKAction.moveTo(location, duration: 1.0)
                let move_enemy = SKAction.moveTo(location, duration: 1.6)
                shape.runAction(move)
                enemy.runAction(move_enemy)
            }else if game_over == true{
                self.removeAllActions()
            }
        }
    }
    
    func updateTimer(){
        if start == true && game_over == false{
            count += 1
            time.text = "Timer: "+String(count)
        }else if start == true && game_over == false && count < 0{
            time.text = "0"
        }
        if dcount > 0{
            count = -1
        }
    }
    
    func cdtimer(){
        if dcount > 0 && game_over == false{
            dcount -= 1
            tb.text = String(dcount)
            self.view!.userInteractionEnabled = false
        }else if dcount==0 && game_over == false && moved == false{
            start = true
            tb.text = ""
            self.view!.userInteractionEnabled = true
            let move_e = SKAction.moveTo(shape.position, duration: 1.3)
            enemy.runAction(move_e)
        }
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
        time.center = CGPointMake(40, CGRectGetMidY(self.frame)-370)
        time.textAlignment = NSTextAlignment.Center
        time.text = ""
        self.view!.addSubview(time)
    }
    
    func addtb(){

        tb.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+30)
        tb.fontName = "Arial"
        tb.zPosition = 2
        tb.fontSize = 120
        tb.fontColor = UIColor.blackColor()
        
        self.addChild(tb)
    }

    func didBeginContact(contact: SKPhysicsContact) {
        println("COLLISION")
        game_over = true
        //let die = SKAction.scaleXTo(0, y: 0, duration: 1.0)
        //shape.runAction(die)
        if game_over == true{
            timer.invalidate()
        }
        gameover()
    }
    func gameover(){
        if game_over == true{
            tb.fontSize = 50
            tb.text = "Game Over"
            restart.frame = CGRectMake(0, 0, 50, 50)
            restart.center = self.view!.center
            restart.setTitle("Restart", forState: .Normal)
            restart.setTitleColor(UIColor.blueColor(), forState: .Normal)
            restart.addTarget(self, action: "playagain", forControlEvents: UIControlEvents.TouchUpInside)
            self.view!.addSubview(restart)
            
        }
    }
    func playagain(){
        game_over = false
        moved = false
        dcount = 5
        tb.fontSize = 120
        tb.text = ""
        restart.setTitle("", forState: .Normal)
        enemy.position = CGPoint (x:CGRectGetMaxX(self.frame),y:CGRectGetMaxY(self.frame))
        shape.position = CGPoint (x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
