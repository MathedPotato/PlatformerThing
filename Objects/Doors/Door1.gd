extends KinematicBody


export var closedPos := Vector3(0,0,0)
export var openPos : Vector3
export var moveSpeed := 1.0
export var isOpen : bool
var isMoving := false

func Open():
	print("Door opening")
	isOpen = true
	isMoving = true

func Close():
	isOpen = false
	isMoving = true

func _physics_process(delta: float) -> void:
	if isMoving:
		var velocity : Vector3
		if isOpen:
			velocity = (openPos - global_transform.origin).normalized() * moveSpeed
		else:
			velocity = (closedPos - global_transform.origin).normalized() * moveSpeed
		
		translate(velocity * delta)
