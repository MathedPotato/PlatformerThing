extends CharState


var movingThreshold = 2
var deaccel = 4

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	if !player.is_on_floor():
		return load("res://Characters/CharStateFalling.gd").new()
	if !input.is_action_pressed("Crouch"):
		if player.velocity.length() < movingThreshold:
			return load("res://Characters/CharStateIdle.gd").new()
		else:
			return load("res://Characters/CharStateMoving.gd").new()
	if input.is_action_just_pressed("Backflip"):
		if player.velocity.length() < movingThreshold:
			# Return backflip state
			return load("res://Characters/CharStateBackflip.gd").new()
	if input.is_action_just_pressed("Long Jump"):
		if player.velocity.length() > movingThreshold:
			# Return long jump state
			return load("res://Characters/CharStateLongJump.gd").new()
	return null

func physicsUpdate(player: Char, delta: float):
	player.velocity.y += delta * player.gravity
	player.velocity = player.velocity.linear_interpolate(Vector3(0,player.velocity.y,0), deaccel*delta)
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope))

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass
