extends CharState


# Probably use coroutines for this action

var attackTime := 1.0
var coroutineInstance: GDScriptFunctionState

func enter(player: Char):
	coroutineInstance = AttackCoroutine(player)

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

func AttackCoroutine(player: Char):
	var delta : float = yield()
	
	var timer := 0.0
	player.velocity = Vector3.ZERO
	# Play animation
	# Create attack area
	while timer < attackTime:
		timer += delta
		delta = yield()
