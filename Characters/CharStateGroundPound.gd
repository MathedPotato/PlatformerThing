extends CharState


# Probably use coroutines for this action

var poundStartTime := 0.4
var poundStartTimer := 0.0
var initYSpeed := -3.0
var bounceSpeed := 7.0
var bounceGravity := -15.0
var endTime := 3.0
var endTimer := 0.0
var coroutineInstance: GDScriptFunctionState

func enter(player: Char):
	coroutineInstance = GPoundCoroutine(player)

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

func GPoundCoroutine(player: Char):
	var delta : float = yield()
	
	# Reset horizontal velocity
	player.velocity.x = 0
	player.velocity.z = 0
	
	# Start phase
	while poundStartTimer < poundStartTime:
		poundStartTimer += delta
		
		# Hover mid-air
		delta = yield()
	
	# Falling phase
	player.velocity.y = initYSpeed
	while !player.is_on_floor():
		player.velocity.y += player.gravity * delta
		player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)
		delta = yield()
	
	# Hit ground phase
	for index in player.get_slide_count():
		var coll = player.get_slide_collision(index).collider
		if coll.has_method("TakeDamage"):
			var newDmgObj = load("res://Objects/DmgObj.gd").new()
			newDmgObj.type = DmgObj.DamageType.GPOUND
			coll.TakeDamage(newDmgObj)
	player.velocity.y = bounceSpeed
	while !player.is_on_floor() or player.velocity.y > 0.0:
		endTimer += delta
		if endTimer >= endTime: break
		player.velocity.y += bounceGravity * delta
		player.velocity = player.move_and_slide(player.velocity, Vector3(0,1,0), false, 4, deg2rad(player.maxSlope), false)
		delta = yield()
