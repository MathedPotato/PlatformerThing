extends CharState


func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	return load("res://Characters/CharStateMoving.gd").new()

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
