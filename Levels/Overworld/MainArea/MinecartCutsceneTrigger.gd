extends DriveableObj


var cutsceneStarted := false
signal startCutscene

func _process(delta):
	if driver != null and !cutsceneStarted:
		cutsceneStarted = true
		StartCutscene()

func _on_Area_body_entered(body: Node) -> void:
	if body.has_method("AreaEnter"):
		body.AreaEnter(self)

func StartCutscene():
	emit_signal("startCutscene")

func _on_AnimationPlayer_animation_finished(anim_name):
	# Load minecart level
#	yield(get_tree().create_timer(0.1), "timeout")
	GameManager.loadLevel("res://Levels/SubAreas/MinecartGame/MinecartGame.tscn")
