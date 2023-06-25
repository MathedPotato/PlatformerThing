extends Area

class_name WaterObj


func SurfacePoint(x : float, z : float) -> Vector3:
	return Vector3(x, global_transform.origin.y, z)


func _on_Area_body_entered(body: Node) -> void:
	if body.has_method("AreaEnter"):
		body.AreaEnter(self)


func _on_Area_body_exited(body: Node) -> void:
	if body.has_method("AreaExit"):
		body.AreaExit(self)
