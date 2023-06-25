extends CharState

class_name CharStateIdle
# Initial state

# Possible previous states: Moving, Crouch, SoftLand
# Possible outgoing states: Moving, Crouch, Jumping, Falling, Swimming

var enteredWaterObj := false
var waterObj : WaterObj

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	# If touching water, return swimming
	if enteredWaterObj:
		if (waterObj as WaterObj).SurfacePoint(player.global_transform.origin.x, player.global_transform.origin.z).y > player.global_transform.origin.y + player.waterEnterYOffset:
			return load("res://Characters/CharStateSwimming.gd").new(waterObj)
	if !player.is_on_floor():
		return load("res://Characters/CharStateFalling.gd").new()
	if input.is_action_pressed("Crouch"):
		return load("res://Characters/CharStateCrouch.gd").new()
	if input.is_action_just_pressed("Jump"):
		return load("res://Characters/CharStateJumping.gd").new()
	if input.is_action_pressed("Forward"):
		return load("res://Characters/CharStateMoving.gd").new()
	if input.is_action_pressed("Back"):
		return load("res://Characters/CharStateMoving.gd").new()
	if input.is_action_pressed("Left"):
		return load("res://Characters/CharStateMoving.gd").new()
	if input.is_action_pressed("Right"):
		return load("res://Characters/CharStateMoving.gd").new()
	return null

func physicsUpdate(player: Char, delta: float):
	pass

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass

func areaEnter(other : Area):
	if other is WaterObj:
		enteredWaterObj = true
		waterObj = other

func areaExit(other : Area):
	if other is WaterObj:
		enteredWaterObj = false
