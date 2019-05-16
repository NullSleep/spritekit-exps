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
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
  }

}
