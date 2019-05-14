/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SpriteKit

class GameScene: SKScene {
  
  // MARK: - Private properties
  
  // Player sprite (i.e the ninja)
  private let player = SKSpriteNode(imageNamed: "player")
  
  // MARK: - SKScene methods
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.white
    // Setting the position of the sprite to be 10% across horizontally, and centered veritcally.
    player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    // To make the sprite appear on the scene, we must add it as a child of the scene.
    addChild(player)
    
    // Create the monster and make them contiounsly spawning over time
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addMonster),
        SKAction.wait(forDuration: 1.0)
        ])
    ))
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Choose one of the touches to work with
    guard let touch = touches.first else {
      return
    }
    
    // Using location(in:) to find out where the touch is within the scene's coordinate system.
    let touchLocation = touch.location(in: self)
    
    // Set up initial location of projectile
    let projectile = SKSpriteNode(imageNamed: "projectile")
    projectile.position = player.position
    
    // Determine offset of location to projectile. Subtract the projectile's current position
    // from the touch location to get a vector from the current position to the touch location.
    let offset = touchLocation - projectile.position
    
    // Bail out if you are shooting down or backwards
    if offset.x < 0 { return }
    
    // The position has been double checked, we should add the projectile now
    addChild(projectile)
    
    // Get the direction of where to shoot. Convert the offset into a unit vector (of length 1) by
    // calling normalized(). This will make it easy to make a vector with a fixed length in the
    // same direction, because 1 * length = length.
    let direction = offset.normalized()
    
    // Make it shoot far enough to be guaranteed off screen. Add the shoot amount to the current
    // position to get where it should end up on the screen.
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
    
    // The sequence action allows you to chain together a sequence of actions that are performed in order, one at a time. This way, you can have the “move to” action performed first, and once it is complete, you perform the “remove from parent” action.
    monster.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
}

// MARK: - Utilities

extension GameScene {
  
  func random() -> CGFloat {
    // TODO: But the preferred way would be using random(in:) method
    // return CGFloat(Float.random(in: from...to))
    // or simply: return CGFloat.random(in: from...to)
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
  }
  
  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }
}
