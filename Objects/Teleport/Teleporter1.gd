extends Area


export var destScene : String
export var destId : int
export var flag1 : String
export var animIndex : int


func _on_Teleporter1_body_entered(body: Node) -> void:
	if body is Char:
		# Teleport
		GameManager.loadLevel(destScene, destId)
