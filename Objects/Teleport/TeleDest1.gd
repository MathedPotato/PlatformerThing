extends Spatial

class_name TeleDest1


export var id : int

func _enter_tree() -> void:
	GameManager.teleDests[id] = self
