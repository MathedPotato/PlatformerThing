extends Node

class_name CharState


func enter(player: Char):
	pass

func processInput(player: Char, input: InputComponent) -> CharState:
	return null

func physicsUpdate(player: Char, delta: float):
	pass

func update(player: Char, delta: float):
	pass

func processAsyncInput(player: Char, input: InputEvent):
	pass

func exit(player: Char):
	pass
