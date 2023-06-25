extends CharState


var enteredWaterObj := false
var waterObj : WaterObj
var enteredDriveableObj := false
var driveableObj : DriveableObj
var onFloorDist := 0.2

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	var inputVector = Vector2()
	
	if input.is_action_pressed("Forward"):
		inputVector.y += 1
	if input.is_action_pressed("Back"):
		inputVector.y -= 1
	if input.is_action_pressed("Left"):
		inputVector.x -= 1
	if input.is_action_pressed("Right"):
		inputVector.x += 1
	#print(inputVector)
	
	player.moveDir = Vector3()
	
	inputVector = inputVector.normalized()
	
	player.moveDir += -player.cameraObj.get_global_transform().basis.z * inputVector.y
	player.moveDir += player.cameraObj.get_global_transform().basis.x * inputVector.x
	
#	for index in player.get_slide_count():
#		var coll = player.get_slide_collision(index).collider
	if enteredWaterObj:
		if (waterObj as WaterObj).SurfacePoint(player.global_transform.origin.x, player.global_transform.origin.z).y > player.global_transform.origin.y + player.waterEnterYOffset:
			return load("res://Characters/CharStateSwimming.gd").new(waterObj)
	if enteredDriveableObj:
		return load("res://Characters/CharStateDriving.gd").new(driveableObj)
	if !player.is_on_floor():
		return load("res://Characters/CharStateFalling.gd").new()
	
	if input.is_action_just_pressed("Crouch") and player.is_on_floor():
		return load("res://Characters/CharStateCrouch.gd").new()
	if input.is_action_just_pressed("Jump") and player.is_on_floor():
		return load("res://Characters/CharStateJumping.gd").new()
	
	return null

func physicsUpdate(player: Char, delta: float):
	player.moveDir.y = 0
	player.moveDir = player.moveDir.normalized()
	
	player.velocity.y += delta * player.gravity
	
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
	
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)

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
	if other is DriveableObj:
		enteredDriveableObj = true
		driveableObj = other

func areaExit(other : Area):
	if other is WaterObj:
		enteredWaterObj = false
