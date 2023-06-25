extends CharState


var jumpVel := Vector3(0,10,0)

func _init(initVel:= Vector3(0,10,0)):
	jumpVel = initVel

func enter(player: Char):
	player.velocity = jumpVel

func processInput(player: Char, input: InputComponent) -> CharState:
	for index in player.get_slide_count():
		#if player.get_slide_collision(index)
		var coll = player.get_slide_collision(index).collider
		if coll is ClimbableObj:
			return load("res://Characters/CharStateClimbing.gd").new(coll)
	if input.is_action_just_pressed("Ground Pound") and !player.is_on_floor():
		return load("res://Characters/CharStateGroundPound.gd").new()
	if player.velocity.y <= 0:
		return load("res://Characters/CharStateFalling.gd").new()
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
	
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope))

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass
