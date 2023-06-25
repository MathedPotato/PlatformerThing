extends Spatial


export var buttons = {} # Dictionary format: {ID, button ref}
export var numButtons := 16
var pushedButtons := 0
export(NodePath) var animPlayerPath
export var animClipFinish : String
onready var animPlayer : AnimationPlayer = get_node(animPlayerPath)
export(NodePath) var animCamPos

signal finished()

func _ready() -> void:
	#print(get_child_count())
	for i in get_child_count():
		#print(get_child(i))
		var btnNode = get_child(i)
		if btnNode is SwitchFloor:
			#print(get_child(i).switchFlag)
			buttons[btnNode.switchFlag] = btnNode
			btnNode.connect("OnPressed", self, "TryPushButton", [btnNode])
	print(buttons)

func TryPushButton(button : SwitchFloor):
	if buttons[pushedButtons] == button:
		print("Button ", button.switchFlag, " pushed successfully")
		pushedButtons += 1
		if pushedButtons >= numButtons:
			emit_signal("finished")
			#if animPlayer != null:
				#animPlayer.play(animClipFinish)
				#GameManager.PlayCutscene(animPlayer, animClipFinish, get_node(animCamPos).get_path())
	else:
		print("Button ", button.switchFlag, " pushed early")
		button.Unpress()
