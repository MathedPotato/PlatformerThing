extends Area

class_name DriveableObj


var driver : Node

signal ejecting_driver(ejectInfo)


func _init():
	connect("tree_exiting", self, "_on_tree_exiting")

func StartDriving(newDriver):
	driver = newDriver

func processInput(input : InputComponent):
	pass

func _on_tree_exiting():
	# If this object is being deleted (e.g. loading a new level), we need to make sure that the driver (if present) is aware asap
	if driver:
		emit_signal("ejecting_driver", EjectDriver())

func EjectDriver():
	return ExitVehicleInfo.new(Vector3.ZERO)

func _physics_process(delta: float) -> void:
	pass

func processAsyncInput(input: InputEvent):
	pass
