# PlatformerThing

*Note: This project only works correctly in Godot 3.x versions (several things, mainly coroutines, are incompatible with Godot 4's GDScript 2)

## About
This is a small platformer demo/programming exercise I made around April 2021. I essentially tried to recreate some of the minigames and other aspects from Donkey Kong 64.

## Features
### Character controls
Arguably the main feature of this project is a playable character with a range of abilities/states, including basic moving, jumping, climbing, swimming, diving, backflipping, long-jumping, and ground-pounding. This is all handled by a Finite State Machine. The MainArea scene has various objects for showcasing all these features. Instructions on how to do some of these things are as follows:
* Move: WASD
* Jump: Press Space
* Backflip: While standing still, hold Ctrl and press Space.
* Long-jump: While moving, hold Ctrl and press Space.
* Ground-pound: Jump, then press Ctrl before landing.
* Climbing: Jump onto a climbable object (the pole in MainArea is the only one that exists so far). Once in the climbing state, use W/S to climb up/down, and A/D to rotate around the object. Use Space to jump off the object.
* Swimming (surface): Enter a body of water (in MainArea, there is a transparent blue cube off the side of the floor). Moving is mostly the same as normal, however, the character's y-coordinate will always try to match that of the surface of the water. Jumping out of the water is also only possible when on the surface (it's also the only way to leave the swimming state, leaving the body of water currently does not do anything!).
* Diving (swimming underwater): While swimming, press Ctrl. Again, moving is similar to normal, but pressing W/S will move the character in the exact direction the camera is facing, meaning it can move vertically. This state is left by returning to the surface of the water.

### Minecart segment
(Levels/SubAreas/MinecartGame/MinecartGame.tscn)
A short minecart segment, mimicking the ones from DK64. This makes use of Bezier curves for both the track placement (which additionally uses an editor script) and for the path the minecart (and camera) takes. There is no goal currently, once it reaches the end of the track, it loops back to the start. Use W to speed up and S to slow down.

### Button puzzle
(Levels/SubAreas/ButtonPushRoom.tscn)
A 4x4 grid of buttons that must be hit in the correct order (this is another recreation of a DK64 minigame). Once all* have been pressed, you are rewarded with a Golden bana- erm, I mean a Great Cylinder (that currently does nothing).
*For the sake of testing, I lowered the requirement to 1, which means you only need to press the button 2nd from bottom, 2nd from right. This can be reset to require all buttons by changing Num Buttons in ButtonPushRoom->ButtonPanel->Buttons to 16.
