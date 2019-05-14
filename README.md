# SpriteKit Experiments

> Based on Ray Wenderlich tutorials.

SpriteKit is one of the best ways to make games on iOS. It’s easy to learn, powerful, and is fully supported by Apple.

## Advantages to SpriteKit:
- It’s built right into iOS. There is no need to download extra libraries or have external dependencies. You can also seamlessly use other iOS APIs like iAd, In-App Purchases, etc. without having to rely on extra plugins.
- It leverages your existing skills. If you already know Swift and iOS development, you can pick up SpriteKit extremely quickly.
- t’s written by Apple. This gives you some confidence that it will be well supported moving forward on all of Apple’s new products. For example, you can use the same SpriteKit code to make your game work on iOS, macOS, and tvOS without a hitch.
- It’s free. Maybe one of the best reasons for small indies! You get all of SpriteKit’s functionality at no cost. Unity does have a free version but it doesn’t have all of the features of the Pro version. You’ll need to upgrade if you want to avoid the Unity splash screen, for example.

## Disadvantages of SpriteKit:
- Cross-platform. This is one of the big ones. If you use SpriteKit, you’re locked into the Apple ecosystem. With other engines like Unity, you can easily port your games to Android, Windows, and more.
- Visual scene designer. Different engines make it extremely easy to lay out your levels and test your game in realtime with the click of a button. SpriteKit does have a scene editor, but it is very basic compared to what Unity offers.
- Asset store. Other engines come with a built-in asset stores where you can buy various components for your game. Some of these components can save you a good bit of development time!
- Power. In general, other engines like Unity just has more features and functionality than the SpriteKit/Scene Kit combination.

## Which Should I Choose?
After this you may be thinking, “Well, which 2D framework should I choose?”

The answer depends on what your goals are:
- If you’re a complete beginner, or solely focused on the Apple ecosystem: Use SpriteKit — it’s built-in, easy to learn, and will get the job done.
- If you want to be cross-platform, or have a more complicated game: Use Unity — it’s more powerful and flexible.

## SpriteKit functionality:
SpriteKit provides a lot of extremely useful built-in actions that help you easily change the state of sprites over time, such as move actions, rotate actions, fade actions, animation actions, and more. Here you use three actions on the monster:
- SKAction.move(to:duration:): You use this action to make the object move off-screen to the left. You can specify how long the movement should take, and here you vary the duration randomly from 2-4 seconds.
- SKAction.removeFromParent(): SpriteKit comes with a helpful action that removes a node from its parent, effectively deleting it from the scene. Here you use this action to remove the monster from the scene when it is no longer visible. This is important because otherwise you would have an endless supply of monsters and would eventually consume all device resources.
- SKAction.sequence(_ :): The sequence action allows you to chain together a sequence of actions that are performed in order, one at a time. This way, you can have the “move to” action performed first, and once it is complete, you perform the “remove from parent” action.
