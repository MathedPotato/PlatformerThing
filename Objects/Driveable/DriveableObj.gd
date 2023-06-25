extends Node

class_name DriveableObj


var driver : Node


func StartDriving(newDriver):
	driver = newDriver

func processInput(input : InputComponent):
	pass

func _physics_process(delta: float) -> void:
	pass

func processAsyncInput(input: InputEvent):
	pass
