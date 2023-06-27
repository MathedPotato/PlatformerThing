extends Spatial

export(NodePath) onready var target = get_node(target) as Spatial

func _process(delta):
	look_at(target.global_transform.origin, Vector3.UP)
