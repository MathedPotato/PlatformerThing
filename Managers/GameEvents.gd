extends Node


signal CutsceneStarted(cutsceneObj, stopPlayer)
signal CutsceneEnded(cutsceneObj)
signal GreatCylinderGet(cylinderObj, total)

func StartCutscene(cutsceneObj : AnimationPlayer = null, stopPlayer : bool = true):
	emit_signal("CutsceneStarted", cutsceneObj, stopPlayer)
	cutsceneObj.connect("animation_finished", self, "EndCutscene", [cutsceneObj], CONNECT_ONESHOT)

func EndCutscene(animName : String, cutsceneObj : AnimationPlayer):
	emit_signal("CutsceneEnded", cutsceneObj)
	#cutsceneObj.disconnect("animation_finished", self, "EndCutscene")

func GetGreatCylinder(cylinder: GreatCylinder, total: int):
	emit_signal("GreatCylinderGet", cylinder, total)
