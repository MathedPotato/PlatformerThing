extends CharState


var waterBody : WaterObj
var swimSpeed := 1
var riseToSurfaceSpeed := 2
var riseToSurfaceAccel := 2
var yOffset := 0
var surfaceCloseLimit := 0.2

func _init(collObj : WaterObj) -> void:
	waterBody = collObj

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	if input.is_action_just_pressed("Jump"):
		# Make sure to only jump if player is on water surface
		var surfaceLevel = waterBody.SurfacePoint(player.global_transform.origin.x, player.global_transform.origin.z).y
		if abs(surfaceLevel - player.global_transform.origin.y) < surfaceCloseLimit:
			return load("res://Characters/CharStateJumping.gd").new()
	if input.is_action_just_pressed("Dive"):
		return load("res://Characters/CharStateDiving.gd").new(waterBody)
	
	player.moveDir = Vector3()
	
	var inputVector = Vector2()
	
	if input.is_action_pressed("Forward"):
		inputVector.y += 1
	if input.is_action_pressed("Back"):
		inputVector.y -= 1
	if input.is_action_pressed("Left"):
		inputVector.x -= 1
	if input.is_action_pressed("Right"):
		inputVector.x += 1
	
	inputVector = inputVector.normalized()
	
	player.moveDir += -player.cameraObj.get_global_transform().basis.z * inputVector.y
	player.moveDir += player.cameraObj.get_global_transform().basis.x * inputVector.x
	
	return null

func physicsUpdate(player: Char, delta: float):
	player.moveDir.y = 0
	player.moveDir = player.moveDir.normalized()
	
	var hVel = player.velocity
	hVel.y = 0
	
	var target = player.moveDir * player.maxSpeed.x
	
	var accel
	if player.moveDir.dot(hVel) > 0:
		accel = player.hAccel
	else:
		accel = player.hDeaccel
	
	hVel = hVel.linear_interpolate(target, delta * accel)
	player.velocity.x = hVel.x
	player.velocity.z = hVel.z
	
	var surfaceLevel = waterBody.SurfacePoint(player.global_transform.origin.x, player.global_transform.origin.z).y
	if surfaceLevel < player.global_transform.origin.y:
		player.velocity.y = (surfaceLevel - player.global_transform.origin.y) / delta
	else:
		player.velocity.y = player.velocity.linear_interpolate(Vector3(0,riseToSurfaceSpeed,0), delta * riseToSurfaceAccel).y
	
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass
