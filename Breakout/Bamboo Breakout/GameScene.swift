//  Created by Carlos Arenas on 05/14/19.
//  Copyright © 2018 Polygon. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

// SpriteKit Physics Overview:

// In Sprite Kit you work in two environments: the graphical world that you see on the screen and the physics world, which determines how objects move and interact.

// The first thing you need to do when using Sprite Kit physics is to change the world according to the needs of your game. The world object is the main object in Sprite Kit that manages all of the objects and the physics simulation. It also sets up the gravity that works on physics bodies added to it. The default gravity is -9.81 thus similar to that of the earth. So, as soon as you add a body it would “fall down”.

// Once you have configured the world object, you can add things to it that interact according to the principles of physics. For this the most usual way is to create a sprite (graphics) and set its physics body. The properties of the body and the world determine how it moves.

// Bodies can be dynamic objects (balls, ninja stars, birds, …) that move and are influenced by physical forces, or they can be static objects (platforms, walls, …) that are not influenced by those forces. When creating a body you can set a ton of different properties like shape, density, friction and many more. Those properties heavily influence how the body behaves within the world.

// When defining a body, you might wonder about the units of their size and density. Internally Sprite Kit uses the metric system (SI units). However within your game you usually do not need to worry about actual forces and mass, as long as you use consistent values.

// Physics properties set in the attribute inspector:
// - Allows Rotation: does exactly what the name implies. It either allows rotation of the body or not. Here you do not want the ball to rotate.
// - Friction is also quite clear – it simply removes all friction.
// - Restitution: refers to the bounciness of an object. You set the restitution to 1, meaning that when the ball collides with an object the collision will be perfectly elastic. In plain English, this means that the ball will bounce back with equal force to the impact.
// - Linear Damping: simulates fluid or air friction by reducing the body’s linear velocity. In the Breakout game the ball should not be slowed down when moving. So, you set the damping to 0.
// - Angular Damping: is the same as Linear Damping but for the angular velocity. Setting this is optional as you don’t allow rotation for the ball.

// Note: Usually, it’s best to have the physics body be fairly similar to what the player sees. For the ball it’s very easy to have a perfect match. However, with more complex shapes you’ll need to be careful since very complex bodies can exact a high toll on performance. Since iOS 8 and Xcode 6, Sprite Kit supports alpha masks body types, that automatically take the shape of a sprite as the shape of its physics body, but be careful as it can degrade performance.

class GameScene: SKScene {
    
    // MARK: - Class properties
    var isFingerOnPaddle = false
    
    // Setting the last bit to 1 and the other bits to zero. We use the << operator to shift a bit to the left. As a result each category constant has only one bit set to 1 and the position of the 1 in the binary number is unique across the four categories.
    let BallCategory   : UInt32 = 0x1 << 0
    let BottomCategory : UInt32 = 0x1 << 1
    let BlockCategory  : UInt32 = 0x1 << 2
    let PaddleCategory : UInt32 = 0x1 << 3
    let BorderCategory : UInt32 = 0x1 << 4
    
    // MARK: - GameScene methods
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Edge-based body. In contrasts tio the volume based body (the ball) this one doesn't have mass or volume and it's unaffected by forces or impulses.
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // The friction es set to 0 so that the ball will not be slowed down when colliding with the border barrier, since we want to have a perfect reflection, where the ball leaves along the same angle that hit the barrier.
        borderBody.friction = 0
        // This physics body is set to every node and we attach it to the scene.
        self.physicsBody = borderBody
        
        // Removing gravity from the scene.
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        // Setting the GameScene as a SKPhysicsContactDelegate
        physicsWorld.contactDelegate = self
        // Getting the instnace of the ball
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        // Applying an impulse (and immediate force to a physiscs body to get it moving in a particuar direction) diagonally down to the right.
        ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        
        // To determine when the user has lost we create a physics body that stretches across the bottom of the screen.
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        // Setting categories for all the nodes
        let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        // The above executes a bitwise OR operation on BottomCategory and BlockCategory. The result is that the bits for those two particular categories are set to one while all other bits are still zero. Now, collisions between ball and floor as well as ball and blocks will be sent to to the delegate.
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory
        
        // Adding the blocks to be broken
        let numberOfBlocks = 8
        let blockWidth = SKSpriteNode(imageNamed: "block").size.width
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
        // calculating the x offset, the distance between the left border of the screen and the first block. You calculate it by substracting the width of all the blocks from the screen width and then dividing it by 2
        let xOffset = (frame.width - totalBlocksWidth) / 2
        // Create the blocks, configure each with the proper physics properties, and position each one using blockWith, and xOffset.
        for i in 0..<numberOfBlocks {
            let block = SKSpriteNode(imageNamed: "block.png")
            block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) + 0.5) * blockWidth,  y: frame.height * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.affectedByGravity = false
            block.physicsBody!.isDynamic = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            block.zPosition = 2
            addChild(block)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get's the touch location
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        // Checks if there is a body in the position touched and if there is, is it the paddle? If yes the user is touching the paddle.
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == PaddleCategoryName {
                print("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if the user is touching the paddle
        if isFingerOnPaddle {
            
            // Update the position of the paddle depending where the user moves it's finger.
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            // Get the SKSpriteNode for the paddle.
            let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            
            // Take the current position and add the difference between the new and the previous touch locations.
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // Before repositioning the paddle, limit the position so that the paddle will not go off the screen to the left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // Set the position of the paddle to the position you just calculated
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This ensures that when the player takes their finger off the screen and taps it again, the paddle does not jump around the previous touch location
        isFingerOnPaddle = false
    }

}

// MARK: - Utilities

extension GameScene {
    
    func breakBlock(node: SKNode) {
        // Emitter nodes are a special type of nodes that display particle systems created in the Scene Editor.
        // Creating and instance of the SKEmitterNode from the BrokenPlatform.sks file.
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        // Sets it's position to the same position as the node
        particles.position = node.position
        // The emitter node's zPosition is set to 3, so the particles appear above the remaining blocks.
        particles.zPosition = 3
        // Add the particles then remove them after 1 second.
        addChild(particles)
        let actionSequence = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                SKAction.removeFromParent()])
        particles.run(actionSequence)
    }
    
}

// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Create the two local variables to hold the two physics bodies involved in the collision
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Check the two bodies  that collided to see which has the lower categoryBitmask. Then store them into the local variables, so that the body with the lower category is always stored in the first body. This will sabe quite some effort reacting to contacts between specific categories.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Beacuse of the sorting made above we only need to check whether firstBody is in the BallCategory and whether secondBody is in the BottomCategory to figure out that the ball has touched the bottom of the screen. This is since we already know that SecondBody could not possibly be in the BallCategory if firstBody is in the BottomCategory (becuse BottomCategory has a higher bit mask than BallCategory)
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. First contact has been made.")
        }
    }
}
