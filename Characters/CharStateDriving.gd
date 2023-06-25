extends CharState


var driveObj : DriveableObj
var initRotation : Vector3

func _init(otherObj : DriveableObj) -> void:
	print("Started driving object: ", otherObj.name)
	driveObj = otherObj
	driveObj.StartDriving(self)

func enter(player: Char):
	initRotation = player.rotation

func processInput(player: Char, input: InputComponent) -> CharState:
	var info = driveObj.processInput(input)
	if info is ExitVehicleInfo:
		player.translate(info.positionOffset)
		player.rotation = initRotation
		player.velocity = Vector3.ZERO
		return load("res://Characters/CharStateMoving.gd").new()
	
	return null

func physicsUpdate(player: Char, delta: float):
	player.transform.origin = driveObj.global_transform.origin
	player.rotation = driveObj.global_rotation

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
#	if input is InputEventMouseMotion:
#		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
#			deg2rad(-input.relative.x * GameManager.mouseSensitivity))
	driveObj.processAsyncInput(input)

func exit(player: Char):
	pass
