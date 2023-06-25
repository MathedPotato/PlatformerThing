extends KinematicBody

class_name CharOld

enum CharStates {IDLE, WALKING, RUNNING, JUMPING, FALLING, ATTACKING, CLIMBING}

var currentState

export var velocity = Vector3(0,0,0)
export var maxSpeed = Vector2(10,20)
export var hAccel = 4
export var hDeaccel = 20
export var gravity = -30
export var maxSlope = 45
export var mouseSens = 20

export var moveDir = Vector3()

var cameraObj : Camera
var camDist : float
var springArmEnd : Transform


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cameraObj = get_tree().root.find_node("Camera", true, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	getInput(delta)
	move(delta)

func getInput(delta):
	moveDir = Vector3()
	
	var inputVector = Vector2()
	
	if Input.is_action_pressed("Forward"):
		inputVector.y += 1
	if Input.is_action_pressed("Back"):
		inputVector.y -= 1
	if Input.is_action_pressed("Left"):
		inputVector.x -= 1
	if Input.is_action_pressed("Right"):
		inputVector.x += 1
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = maxSpeed.y
	
	inputVector = inputVector.normalized()
	
	moveDir += -cameraObj.get_global_transform().basis.z * inputVector.y
	moveDir += cameraObj.get_global_transform().basis.x * inputVector.x

func move(delta):
	moveDir.y = 0
	moveDir = moveDir.normalized()
	
	velocity.y += delta * gravity
	
	var hVel = velocity
	hVel.y = 0
	
	var target = moveDir * maxSpeed.x
	
	var accel
	if moveDir.dot(hVel) > 0:
		accel = hAccel
	else:
		accel = hDeaccel
	
	hVel = hVel.linear_interpolate(target, delta * accel)
	velocity.x = hVel.x
	velocity.z = hVel.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0), false, 4, deg2rad(maxSlope))

func getCamPos() -> Transform:
	#return springArmEnd
	return $CamFocus/SpringArm/SpringArmEnd.global_transform

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$CamFocus/SpringArm.rotate_x(deg2rad(-event.relative.y * GameManager.mouseSensitivity))
		$CamFocus.rotate_y(deg2rad(-event.relative.x * GameManager.mouseSensitivity))
		
		$CamFocus/SpringArm.rotation_degrees.x = clamp($CamFocus/SpringArm.rotation_degrees.x, -70, 70)
		#springArmEnd = $CamFocus/SpringArm/SpringArmEnd.global_transform
		#camDist = $CamFocus/SpringArm.get_hit_length()
		
		#cameraObj.transform.origin = $CamFocus/SpringArm.transform.origin
		#var camTranslation = Vector3()
		#camTranslation += $CamFocus.get_global_transform().basis.z * camDist
		#cameraObj.translate(camTranslation)
		
		#cameraObj.look_at($".".transform.origin, Vector3(0,1,0))
