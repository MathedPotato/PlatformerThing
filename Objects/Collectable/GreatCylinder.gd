extends Area

class_name GreatCylinder


export var id : int


func _ready() -> void:
	connect("body_entered", self, "OnBodyEntered")

func OnBodyEntered(other : Node):
	print("Node ", other, " picked up cylinder ", id)

func EnableCollision():
	$CollisionShape.disabled = false


func _on_Area_body_entered(body: Node) -> void:
	if body.has_method("AreaEnter"):
		body.AreaEnter(self)


func _on_Area_body_exited(body: Node) -> void:
	if body.has_method("AreaExit"):
		body.AreaExit(self)
