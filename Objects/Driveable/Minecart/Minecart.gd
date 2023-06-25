extends DriveableObj


var currSpeed : Vector3
var speedFactor := 1.0
export var accel : float
export var defaultSpeed : float
export var minSpeed : float
export var maxSpeed : float
var inputSpeed : int
export(NodePath) onready var trackPointer = get_node(trackPointer) as PathFollow
export(NodePath) onready var camTrackFollow = get_node(camTrackFollow) as PathFollow
export var camBaseDist : float
export var camMaxDist : float
export var speedCamModifier : float
export var selfDriving : bool

func StartDriving(newDriver):
	driver = newDriver
	camTrackFollow.get_child(0).current = true

func processInput(input : InputComponent):
	inputSpeed = 0
	if input.is_action_pressed("Forward"):
		inputSpeed += 1
	if input.is_action_pressed("Back"):
		inputSpeed -= 1
	if input.is_action_pressed("Crouch"):
		driver = null
		camTrackFollow.get_child(0).current = false
		return ExitVehicleInfo.new(Vector3(0,0,-5))

func _physics_process(delta: float) -> void:
	if !selfDriving and !driver: return
	
	if selfDriving:
		inputSpeed = 0
		if Input.is_action_pressed("Forward"):
			inputSpeed += 1
		if Input.is_action_pressed("Back"):
			inputSpeed -= 1
	var targetSpeed : Vector3
	
	if inputSpeed == 0:
		targetSpeed.z = defaultSpeed
	elif inputSpeed < 0:
		targetSpeed.z = minSpeed
	else:
		targetSpeed.z = maxSpeed
	
	targetSpeed *= speedFactor
	currSpeed = currSpeed.linear_interpolate(targetSpeed, delta * accel)
	
	trackPointer.offset += currSpeed.z * delta
	print(currSpeed.z)

func _process(delta: float) -> void:
	if camTrackFollow.get_child_count() < 1: return
	camTrackFollow.offset = trackPointer.offset - camBaseDist - (currSpeed.z - defaultSpeed) * speedCamModifier
	if trackPointer.offset - camTrackFollow.offset > camMaxDist:
		camTrackFollow.offset = trackPointer.offset - camMaxDist
	(camTrackFollow.get_child(0) as Camera).look_at(trackPointer.transform.origin, Vector3.UP)

func processAsyncInput(input: InputEvent):
	pass


func _on_Area_body_entered(body: Node) -> void:
	if body.has_method("AreaEnter"):
		body.AreaEnter(self)


func _on_Area_body_exited(body: Node) -> void:
	if body.has_method("AreaExit"):
		body.AreaExit(self)
