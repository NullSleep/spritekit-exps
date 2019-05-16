//  Created by Carlos Arenas on 05/14/19.
//  Copyright © 2018 Polygon. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
  
  init(size: CGSize, won: Bool) {
    super.init(size: size)
    
    // Setting the background of the scene to white
    backgroundColor = SKColor.white
    
    // Based on the won parameter set the appropiate message
    let message = won ? "You Won!" : "You lose :["
    
    // Displaying a label of text in SpriteKit
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.black
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    // Runs the seequence of two actions. First wait for 3 seconds the run the transition to the game scene.
    run(SKAction.sequence([
      SKAction.wait(forDuration: 3.0),
      SKAction.run() { [weak self] in
        // Transitioning to the game scene. You pick from a variety og different animated transitions for how you want the scenes to display. Then you create the scen you want to display, and use presentScene(_:trnsition:) on self.view
        guard let `self` = self else { return }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition: reveal)
      }
      ]))
  }
  // If we override the initializer on a scene, you must implement the required init(coder:) initializer as well. However this initializer will never be called, so you just add a dummy implementation with a fatalError(_:)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

