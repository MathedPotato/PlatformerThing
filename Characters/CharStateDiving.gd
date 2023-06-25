extends CharState


var waterBody : WaterObj
var diveSpeedFactor := 1.0
var diveAccelFactor := 1.0
var surfaceCloseLimit := 0.1

func _init(collObj : WaterObj) -> void:
	waterBody = collObj

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	# If touching surface, change to swimming state
	if player.global_transform.origin.y - waterBody.SurfacePoint(player.global_transform.origin.x, player.global_transform.origin.z).y > surfaceCloseLimit:
		return load("res://Characters/CharStateSwimming.gd").new(waterBody)
	
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
	#player.moveDir.y = 0
	player.moveDir = player.moveDir.normalized()
	
	var hVel = player.velocity
	#hVel.y = 0
	
	var target = player.moveDir * player.maxSpeed.x * diveSpeedFactor
	
	var accel
	if player.moveDir.dot(hVel) > 0:
		accel = player.hAccel
	else:
		accel = player.hDeaccel
	
	hVel = hVel.linear_interpolate(target, delta * accel)
	player.velocity.x = hVel.x
	player.velocity.y = hVel.y
	player.velocity.z = hVel.z
	
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass
