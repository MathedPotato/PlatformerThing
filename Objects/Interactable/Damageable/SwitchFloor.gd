extends Spatial

class_name SwitchFloor


export var unpressedPos := Vector3(0,0.2,0)
export var pressedPos := Vector3(0,0.05,0)
export var moveSpeed := 0.2
export var toggleable := false
export var extendToBase := true
var isMoving := false
var pressed := false
export var switchFlag : int

var moveCo

signal OnPressedStart()
signal OnUnpressedStart()
signal OnPressed()
signal OnUnpressed()

func _ready() -> void:
	$Switch.transform.origin = unpressedPos
	if extendToBase: $Switch.scale.y = unpressedPos.y/2.0

func Press(other : DmgObj = null):
	emit_signal("OnPressedStart")
	pressed = true
	isMoving = true
	moveCo = Move(moveSpeed, pressedPos, "OnPressed")

func Unpress(other : DmgObj = null):
	emit_signal("OnUnpressedStart")
	#print("Unpress start")
	pressed = false
	isMoving = true
	moveCo = Move(moveSpeed, unpressedPos, "OnUnpressed")

func _physics_process(delta: float) -> void:
	if moveCo is GDScriptFunctionState and moveCo.is_valid():
		moveCo = moveCo.resume(delta)
		if !(moveCo is GDScriptFunctionState and moveCo.is_valid()):
			emit_signal(moveCo)
#	var delta = yield()
#
#	if isMoving:
#		var velocity : Vector3
#		if pressed:
#			velocity = (global_transform.xform(pressedPos) - $Switch.global_transform.origin).normalized() * moveSpeed
#		else:
#			velocity = (global_transform.xform(unpressedPos) - $Switch.global_transform.origin).normalized() * moveSpeed
#
#		$Switch.translate(velocity * delta)

func Move(speed, target, signalName):
	var delta = yield()
	#print("Move start with signal ", signalName)
	while isMoving:
		var velocity : Vector3
		velocity = (global_transform.xform(target) - $Switch.global_transform.origin).normalized() * moveSpeed
		if (velocity*delta).length_squared() >= (global_transform.xform(target) - $Switch.global_transform.origin).length_squared():
			isMoving = false
			velocity = global_transform.xform(target) - $Switch.global_transform.origin
			$Switch.translate(velocity * delta)
			#print("Move finished with signal ", signalName)
			return signalName
		
		$Switch.translate(velocity * delta)
		delta = yield()
