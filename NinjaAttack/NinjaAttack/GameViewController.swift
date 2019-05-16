//  Created by Carlos Arenas on 05/14/19.
//  Copyright © 2018 Polygon. All rights reserved.
//

import UIKit
import SpriteKit

// GameViewController is a normal UIViewController, except that its root view is an SKView, which is a view that contains a SpriteKit scene.
class GameViewController: UIViewController {
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a new instance of the GameScene on startup, with the same size as the view itself.
    let scene = GameScene(size: view.bounds.size)
    let skView = view as! SKView
    
    // Setting skView.showsFPS to true means a frame rate indicator will be displayed.
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
}
