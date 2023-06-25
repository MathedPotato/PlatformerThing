extends Node

export var autoloadLevel = false

var charPrefab = preload("res://Characters/Char.tscn")

var currCam : Camera
export var mouseSensitivity = 0.3
enum CamModes {fixed, player}
export var camMode = CamModes.fixed
var currChar : Spatial
var teleDests = {}
var cutsceneCo
var playerData : PlayerData


func _ready() -> void:
	playerData = PlayerData.new()
	var newCam = Camera.new()
	newCam.name = "Camera"
	$".".add_child(newCam)
	var lvlNode = Node.new()
	lvlNode.name = "CurrentLevel"
	$".".add_child(lvlNode)
	var charNode = Node.new()
	charNode.name = "CurrentChar"
	$".".add_child(charNode)
	currCam = $Camera
	if autoloadLevel:
		loadLevel("res://Levels/Overworld/MainArea/MainArea.tscn")
	spawnChar()

func _process(delta: float) -> void:
	if camMode == CamModes.player:
		currCam.global_transform = currChar.getCamPos()
#	elif camMode == CamModes.fixed:
#		pass
	
	if cutsceneCo is GDScriptFunctionState and cutsceneCo.is_valid():
		cutsceneCo = cutsceneCo.resume(delta)

func spawnChar():
	currChar = charPrefab.instance()
	#var scene_root = get_tree().root.get_children()[0]
	#scene_root.add_child(currChar)
	if $CurrentChar.get_child_count() != 0:
		for childNode in $CurrentChar.get_children():
			$CurrentChar.remove_child(childNode)
			childNode.queue_free()
	$CurrentChar.add_child(currChar)
	changeCamMode(CamModes.player)

func changeCamMode(newMode):
	camMode = newMode

func loadLevel(levelPath, destId = 0):
	teleDests.clear()
	if $CurrentLevel.get_child_count() != 0:
		for childNode in $CurrentLevel.get_children():
			$CurrentLevel.remove_child(childNode)
			childNode.queue_free()
	
	#var newLevel : Resource = preload("res://Levels/SubAreas/ButtonPushRoom.tscn")
	#get_tree().change_scene_to(newLevel)
	#var levelInstance = newLevel.instance()
	#$CurrentLevel.add_child(levelInstance)
	#print("Before level load")
	var levelLoader = ResourceLoader.load_interactive(levelPath)
	levelLoader.wait()
	var levelData = levelLoader.get_resource()
	get_tree().change_scene_to(levelData)
	#print("After level load")
	SetPlayerPos(destId)

func SetPlayerPos(id : int):
	yield(get_tree(), "idle_frame") # Wait 1 frame to ensure all teledests have been registered
	#print("Setting player pos")
	currChar.transform.origin = teleDests[id].transform.origin
	# Will need to do other things to the player depending on teledest properties (anim, etc.)


static func GetManager():
	return ((Engine.get_main_loop() as SceneTree).current_scene.find_node("GameManager"))

static func Exists() -> bool:
	#for node in ((Engine.get_main_loop() as SceneTree).current_scene).get_children():
		#print(((Engine.get_main_loop() as SceneTree).current_scene).get_path_to(node))
	return false# (Engine.get_main_loop() as SceneTree).current_scene.has_node()

static func LoadLevel(levelPath):
	GetManager().loadLevel(levelPath)

func PlayCutscene(animObj : AnimationPlayer, animName : String, camObj : NodePath = ""):
	animObj.play(animName)
	print("Animation started")
	cutsceneCo = ProcessCutscene(animObj, animName, camObj)
	yield(animObj, "animation_finished")
	print("Animation finished")
	cutsceneCo = null
	if camObj != "":
		camMode = CamModes.player

func ProcessCutscene(animObj : AnimationPlayer, animName : String, camPath : NodePath = ""):
	var delta = yield()
	if camPath != "":
		changeCamMode(CamModes.fixed)
	while true:
		if camPath != "":
			var camObj = get_node(camPath)
			currCam.global_transform.origin = camObj.global_transform.origin
			currCam.rotation = camObj.rotation
		delta = yield()

func LoadPlayerData():
	pass

var keyPressedLastFrame = {}

func _input(event):
	if Input.is_physical_key_pressed(KEY_1):
		if !keyPressedLastFrame[KEY_1]:
			loadLevel("res://Levels/Overworld/MainArea/MainArea.tscn")
		keyPressedLastFrame[KEY_1] = true
	else:
		keyPressedLastFrame[KEY_1] = false
	
	if Input.is_physical_key_pressed(KEY_2):
		if !keyPressedLastFrame[KEY_2]:
			loadLevel("res://Levels/SubAreas/ButtonPushRoom.tscn")
		keyPressedLastFrame[KEY_2] = true
	else:
		keyPressedLastFrame[KEY_2] = false
	
	if Input.is_physical_key_pressed(KEY_3):
		if !keyPressedLastFrame[KEY_3]:
			loadLevel("res://Levels/SubAreas/MinecartGame/MinecartGame.tscn")
		keyPressedLastFrame[KEY_3] = true
	else:
		keyPressedLastFrame[KEY_3] = false
	
