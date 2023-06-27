extends CharState


var driveObj : DriveableObj
var initRotation : Vector3

func _init(otherObj : DriveableObj) -> void:
	print("Started driving object: ", otherObj.name)
	driveObj = otherObj
	driveObj.StartDriving(self)

func enter(player: Char):
	initRotation = player.rotation
	driveObj.connect("ejecting_driver", self, "_on_ejected", [player])

func processInput(player: Char, input: InputComponent) -> CharState:
	var info = driveObj.processInput(input)
	if info is ExitVehicleInfo:
		player.translate(info.positionOffset)
		player.rotation = initRotation
		player.velocity = Vector3.ZERO
		driveObj.disconnect("ejecting_driver", self, "_on_ejected")
		return load("res://Characters/CharStateMoving.gd").new()
	
	return null

func _on_ejected(info, player):
	player.translate(info.positionOffset)
	player.rotation = initRotation
	player.velocity = Vector3.ZERO
	player.ChangeState(load("res://Characters/CharStateMoving.gd").new())

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
