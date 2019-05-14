//  Created by Carlos Arenas on 05/14/19.
//  Copyright © 2018 Polygon. All rights reserved.
//

import Foundation

struct PhysicsCategory {
  // Setting up the constants for the physics categories.
  // The category on SpriteKit is just a single 32-bit integer, acting as a bitmask. This is afancy way of saying each of the 32-bits in the integer represents a single category (and hence you can have 32 categories max). Here you're setting the first bit to indicate a monster, the next bit over to represent a projectile, and so on.
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1
  static let projectile: UInt32 = 0b10
}
