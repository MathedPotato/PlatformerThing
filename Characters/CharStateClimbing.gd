extends CharState


var climbableObject : ClimbableObj
var climbSpeedY = 3
var jumpVel = 20

func _init(collObj : ClimbableObj):
	print(collObj)
	climbableObject = collObj

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	if input.is_action_just_pressed("Jump"):
		# Set velocity away from climbing object
		var relativePos = climbableObject.global_transform.affine_inverse().xform(player.global_transform.origin)
		var relativeDispl := Vector3(relativePos.x, 0, relativePos.z)
		var globalDispl := (climbableObject.global_transform.basis.xform(relativeDispl) as Vector3).normalized()
		return load("res://Characters/CharStateJumping.gd").new(globalDispl * jumpVel)
	
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
	
	player.moveDir.y += inputVector.y * climbSpeedY
	player.moveDir.x += inputVector.x
	
	return null

func physicsUpdate(player: Char, delta: float):
	# Left and right = move around radius of object
	# Up and down = move along length of object
	var newPos = (climbableObject as ClimbableObj).NextPos(player.transform.origin, player.moveDir, delta)
	var moveDelta = newPos - player.transform.origin
	player.velocity = moveDelta
	
	player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope))

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	if input is InputEventMouseMotion:
		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
			deg2rad(-input.relative.x * GameManager.mouseSensitivity))

func exit(player: Char):
	pass
