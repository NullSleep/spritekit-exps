//  Created by Carlos Arenas on 05/14/19.
//  Copyright © 2018 Polygon. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  // MARK: - Private properties
  
  // Player sprite (i.e the ninja)
  private let player = SKSpriteNode(imageNamed: "player")
  var monstersDestroyed = 0
  
  // MARK: - SKScene methods
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.white
    // Setting the position of the sprite to be 10% across horizontally, and centered veritcally.
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    // To make the sprite appear on the scene, we must add it as a child of the scene.
    addChild(player)
    
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    // Create the monster and make them contiounsly spawning over time
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addMonster),
        SKAction.wait(forDuration: 1.0)
        ])
    ))
    
    // This uses SKAudioNode to play and loop the background music for the game
    let backgroundMusic = SKAudioNode(fileNamed: "background-music-acc.caf")
    backgroundMusic.autoplayLooped = true
    addChild(backgroundMusic)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Choose one of the touches to work with
    guard let touch = touches.first else {
      return
    }
    
    // Playing the shootting sound
    run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    
    // Using location(in:) to find out where the touch is within the scene's coordinate system.
    let touchLocation = touch.location(in: self)
    
    // Set up initial location of projectile
    let projectile = SKSpriteNode(imageNamed: "projectile")
    projectile.position = player.position
    
    // -- Collision detection and physics
    // Using a circle shaped body instead of a rectangle body. Since the projectile is a nice circle, this makes for a better match.
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    // You also set usesPreciseCollisionDetection to true. This is important to set for fast moving bodies like projectiles, because otherwise there is a chance that two fast moving bodies can pass through each other without a collision being detected.
    projectile.physicsBody?.usesPreciseCollisionDetection = true
    // --
    
    // Determine offset of location to projectile. Subtract the projectile's current position from the touch location to get a vector from the current position to the touch location.
    let offset = touchLocation - projectile.position
    
    // Bail out if you are shooting down or backwards
    if offset.x < 0 { return }
    
    // The position has been double checked, we should add the projectile now
    addChild(projectile)
    
    // Get the direction of where to shoot. Convert the offset into a unit vector (of length 1) by calling normalized(). This will make it easy to make a vector with a fixed length in the same direction, because 1 * length = length.
    let direction = offset.normalized()
    
    // Make it shoot far enough to be guaranteed off screen. Add the shoot amount to the current position to get where it should end up on the screen.
    let shootAmount = direction * 1000
    
    // Add the shoot amount to the current position
    let realDest = shootAmount + projectile.position
    
    // Create the actions
    let actionMove = SKAction.move(to: realDest, duration: 2.0)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
}

// MARK: - Private methods

extension GameScene {
  
  private func addMonster() {
    
    // Create the sprite
    let monster = SKSpriteNode(imageNamed: "monster")
    
    // -- Collision detection and physics
    // Create a physics body for the sprite. In this case, the body is defined as a rectangle of the same size as the sprite, since that's a decent approximation for the monster.
    monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
    // Set the sprite to be dynamic. This means that the physics enfine will control the movement of the monster. It will be controlled through the move actions (already written)
    monster.physicsBody?.isDynamic = true
    // Set the category bit mask to be the mosnterCategory defined ealier.
    monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
    // contactTestBitMask indicates what categories of objects this object should notify the contact listener when they intersect. Since it's a monster we choose projectiles here.
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
    // collisionBitMask indicates what categories of objects that the physics engine will handle as contact responses (i.e. bounce off of). You don't want the monster and projectile to bounce of each other - it's OK for them to go right through each other in this game - so you set this to .none
    monster.physicsBody?.collisionBitMask = PhysicsCategory.none
    // --
    
    // Determine where to spawn the monster along the Y axis
    let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
    
    // Position the monster slightly off-screen along the right edge, and along a random position along Y axis calculated above
    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    
    // Add the monster to the scene
    addChild(monster)
    
    // Determine the speed of the monster
    let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
    
    // Create the actions
    // You use this action to make the object move off-screen to the left. You can specify how long the movement should take, and here you vary the duration randomly from 2-4 seconds as specified by the constant actualDuration.
    let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY),
                                   duration: TimeInterval(actualDuration))
    
    // Here you use this action to remove the monster from the scene when it is no longer visible. This is important because otherwise you would have an endless supply of monsters and would eventually consume all device resources.
    let actionMoveDone = SKAction.removeFromParent()
    
    // Prescent the game over scene action when a monster goes off-screen.
    let loseAction = SKAction.run() { [weak self] in
      guard let `self` = self else { return }
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    // The sequence action allows you to chain together a sequence of actions that are performed in order, one at a time. This way, you can have the “move to” action performed first, and once it is complete, you perform the “remove from parent” action and then show the Game Over scene
    monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
  }
  
  private func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
    print("A shuriken hit a monster!")
    
    // All you do here is remove the projectile and monster from the scene when they collide.
    projectile.removeFromParent()
    monster.removeFromParent()
    
    monstersDestroyed += 1
    
    if monstersDestroyed > 30 {
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: self.size, won: true)
      view?.presentScene(gameOverScene, transition: reveal)
    }
  }
}

// MARK: - Utilities

extension GameScene {
  
  func random() -> CGFloat {
    // TODO: But the preferred way would be using random(in:) method: return CGFloat(Float.random(in: from...to))
    // or simply: return CGFloat.random(in: from...to)
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
  }
  
  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }
}

// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
  
  // Since you set the scene as the physics world's contactDelegate earlier, this method will be called whenever two physics bodies collide and their contactTestBitMask are set appropiately. This mehtods passes you two bodies that collide, but does no guarantee that they are passed in any particular order.
  func didBegin(_ contact: SKPhysicsContact) {
    //  This arranges them so they are sorted by their category bit masks so you can make some decissions later.
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    // Here we check if the two bodies that collided are the projectile and monster and if so the projectileDidCollideWithMonster mehtod is called.
    if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let monster = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithMonster(projectile: projectile, monster: monster)
      }
    }
  }
  
}
