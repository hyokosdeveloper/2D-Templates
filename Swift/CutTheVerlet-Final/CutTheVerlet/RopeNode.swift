//
//  RopeNode.swift
//  CutTheVerlet
//
//  Created by Nick Lockwood on 07/09/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import UIKit
import SpriteKit

class RopeNode: SKNode {
   
    private let length: Int
    private let anchorPoint: CGPoint
    private var ropeSegments: [SKNode] = []
    
    init(length: Int, anchorPoint: CGPoint, name: String) {

        self.length = length
        self.anchorPoint = anchorPoint
        
        super.init()
        
        self.name = name
    }

    required init?(coder aDecoder: NSCoder) {
        
        length = aDecoder.decodeIntegerForKey("length")
        anchorPoint = aDecoder.decodeCGPointForKey("anchorPoint")
        
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(length, forKey: "length")
        aCoder.encodeCGPoint(anchorPoint, forKey: "anchorPoint")
        
        super.encodeWithCoder(aCoder)
    }
    
    func addToScene(scene: SKScene) {
        
        // add rope to scene
        zPosition = Layer.Rope
        scene.addChild(self)
        
        // create rope holder
        let ropeHolder = SKSpriteNode(imageNamed: RopeHolderImage)
        ropeHolder.position = anchorPoint
        ropeHolder.zPosition = Layer.Rope
        
        ropeSegments.append(ropeHolder)
        addChild(ropeHolder)
        
        ropeHolder.physicsBody = SKPhysicsBody(circleOfRadius: ropeHolder.size.width / 2)
        ropeHolder.physicsBody?.categoryBitMask = Category.RopeHolder
        ropeHolder.physicsBody?.collisionBitMask = 0
        ropeHolder.physicsBody?.contactTestBitMask = Category.Prize
        ropeHolder.physicsBody?.dynamic = false

        // add each of the rope parts
        for i in 0..<length {
            
            let ropeSegment = SKSpriteNode(imageNamed: RopeTextureImage)
            let offset = ropeSegment.size.height * CGFloat(i + 1)
            ropeSegment.position = CGPointMake(anchorPoint.x, anchorPoint.y - offset)
            ropeSegment.name = name
            
            ropeSegments.append(ropeSegment)
            addChild(ropeSegment)
 
            ropeSegment.physicsBody = SKPhysicsBody(rectangleOfSize: ropeSegment.size)
            ropeSegment.physicsBody?.categoryBitMask = Category.Rope
            ropeSegment.physicsBody?.collisionBitMask = Category.RopeHolder
            ropeSegment.physicsBody?.contactTestBitMask = Category.Prize
        }
        
        // set up joints between rope parts
        for i in 1...length {
            
            let nodeA = ropeSegments[i - 1]
            let nodeB = ropeSegments[i]
            let joint = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody, bodyB: nodeB.physicsBody,
                anchor: CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)))
            
            scene.physicsWorld.addJoint(joint)
        }
    }
    
    func attachToPrize(prize: SKSpriteNode) {
        
        // align last segment of rope with prize
        let lastNode = ropeSegments.last!
        lastNode.position = CGPointMake(prize.position.x, prize.position.y + prize.size.height * 0.1)
        
        // set up connecting joint
        let joint = SKPhysicsJointPin.jointWithBodyA(lastNode.physicsBody,
            bodyB: prize.physicsBody, anchor: lastNode.position)
    
        prize.scene?.physicsWorld.addJoint(joint)
    }
}
