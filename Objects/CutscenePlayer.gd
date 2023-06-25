extends AnimationPlayer

class_name CutscenePlayer


export var animClipFinish : String
export(NodePath) var animCamPos = "CamPos"


func StartCutscene():
	GameEvents.StartCutscene(self, true)
	GameManager.PlayCutscene(self, animClipFinish, get_node(animCamPos).get_path())
