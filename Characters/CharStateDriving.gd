extends CharState


var driveObj : DriveableObj

func _init(otherObj : DriveableObj) -> void:
	driveObj = otherObj
	driveObj.StartDriving(self)

func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	return driveObj.processInput(input)
	
	return null

func physicsUpdate(player: Char, delta: float):
	pass

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
#	if input is InputEventMouseMotion:
#		player.rotateCam(deg2rad(-input.relative.y * GameManager.mouseSensitivity),
#			deg2rad(-input.relative.x * GameManager.mouseSensitivity))
	driveObj.processAsyncInput(input)

func exit(player: Char):
	pass
