extends InputComponent


var isActive := true
var wasActiveLastFrame := true

func _init() -> void:
	GameEvents.connect("CutsceneStarted", self, "CutsceneStart")
	GameEvents.connect("CutsceneEnded", self, "CutsceneEnd")

func is_action_pressed(action: String):
	if !isActive:
		return false
	return Input.is_action_pressed(action)

func is_action_just_pressed(action: String):
	if Input.is_action_pressed(action) and isActive and !wasActiveLastFrame:
		return true
	if !isActive:
		return false
	return Input.is_action_just_pressed(action)

func is_action_just_released(action: String):
	if !isActive and wasActiveLastFrame and Input.is_action_pressed(action):
		return true
	if !isActive:
		return false
	return Input.is_action_just_released(action)

func update():
	wasActiveLastFrame = isActive

func SetActive(value : bool):
	isActive = value

func CutsceneStart(cutsceneObj : AnimationPlayer, playerStop : bool):
	SetActive(!playerStop)

func CutsceneEnd(cutsceneObj : AnimationPlayer):
	SetActive(true)
