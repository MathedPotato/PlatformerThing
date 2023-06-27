extends KinematicBody

class_name Char

enum CharStates {IDLE, MOVING, JUMPING, FALLING, CROUCH, CLIMBING, SOFTLAND, SWIMMING}

var StateRes = load("res://Characters/CharState.gd")
var IdleState = load("res://Characters/CharStateIdle.gd")
var MovingState = load("res://Characters/CharStateMoving.gd")
var JumpingState = load("res://Characters/CharStateJumping.gd")
var FallingState = load("res://Characters/CharStateFalling.gd")
var CrouchState = load("res://Characters/CharStateCrouch.gd")
var ClimbingState = load("res://Characters/CharStateClimbing.gd")
var SwimmingState = load("res://Characters/CharStateSwimming.gd")
var SoftLandState = load("res://Characters/CharStateSoftLand.gd")
var PlayerController = load("res://Characters/InputComponentPlayer.gd")

var currentState
var inputController

export var velocity := Vector3(0,0,0)
export var maxSpeed := Vector2(10,20)
export var hAccel = 4
export var hDeaccel = 20
export var gravity = -30
export var maxSlope = 45
export var mouseSens = 20

export var moveDir := Vector3()

var cameraObj : Camera
var camDist : float
var springArmEnd : Transform

export var waterEnterYOffset := -1
#var areasJustEntered


func _ready() -> void:
	cameraObj = get_tree().root.find_node("Camera", true, false)
	currentState = IdleState.new()
	inputController = PlayerController.new()

func _physics_process(delta: float) -> void:
	if currentState.has_method("processInput"):
		var newState = currentState.processInput(self, inputController)
		if newState != null:
			ChangeState(newState)
	if currentState.has_method("physicsUpdate"):
		currentState.physicsUpdate(self, delta)

func ChangeState(newState):
	if currentState.has_method("exit"): currentState.exit(self)
	currentState = newState
	if currentState.has_method("enter"): currentState.enter(self)

func _process(delta: float) -> void:
	if currentState.has_method("update"):
		currentState.update(self, delta)

func getCamPos() -> Transform:
	#return springArmEnd
	return $CamFocus/SpringArm/SpringArmEnd.global_transform

func rotateCam(angleX: float, angleY: float):
	$CamFocus/SpringArm.rotate_x(angleX)
	$CamFocus.rotate_y(angleY)
	$CamFocus/SpringArm.rotation_degrees.x = clamp($CamFocus/SpringArm.rotation_degrees.x, -70, 70)

func _input(event: InputEvent) -> void:
	if currentState.has_method("processAsyncInput"):
		var newState = currentState.processAsyncInput(self, event)
		if newState != null:
			if currentState.has_method("exit"): currentState.exit(self)
			currentState = newState
			if currentState.has_method("enter"): currentState.enter(self)

func AreaEnter(other):
	print(other)
	#if other is WaterObj:
		#areasJustEntered += other
	if other is GreatCylinder:
		CollectGreatCylinder(other as GreatCylinder)
	if other is DriveableObj:
		StartDriving(other)
	if currentState.has_method("areaEnter"):
		currentState.areaEnter(other)

func AreaExit(other):
	if currentState.has_method("areaExit"):
		currentState.areaExit(other)

func CollectGreatCylinder(cylinder : GreatCylinder):
	# Check that cylinder is not duplicate
	if GameManager.playerData.greatCylinders.has(cylinder.id):
		return
	# Do things that are done regardless of state
	GameManager.playerData.greatCylinders[cylinder.id] = true
	# Invoke state's implementation of method (if it exists)
	if currentState.has_method("CollectGreatCylinder"):
		currentState.CollectGreatCylinder(cylinder)
	pass

func StartDriving(driveObj : DriveableObj):
	ChangeState(load("res://Characters/CharStateDriving.gd").new(driveObj))
