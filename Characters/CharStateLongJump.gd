extends CharState


# Probably use coroutines for this action

var initJumpVel := Vector3(0, 10, 15)
var constVel := Vector3(0,0,0)
var gravity := -20.0
var startFallTime := 4.0
var coroutineInstance: GDScriptFunctionState

func enter(player: Char):
	coroutineInstance = BackflipCoroutine(player)

func processInput(player: Char, input: InputComponent) -> CharState:
	if !(coroutineInstance is GDScriptFunctionState and coroutineInstance.is_valid()):
		return load("res://Characters/CharStateMoving.gd").new()
	
	return null

func physicsUpdate(player: Char, delta: float):
	coroutineInstance = coroutineInstance.resume(delta)

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass

func BackflipCoroutine(player: Char):
	var delta : float = yield()
	
	player.velocity = player.velocity.normalized() * initJumpVel.z
	player.velocity.y = initJumpVel.y
	while true:
		player.velocity.y += gravity * delta
		player.velocity += constVel
		player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)
		delta = yield()
		if player.is_on_floor(): break
