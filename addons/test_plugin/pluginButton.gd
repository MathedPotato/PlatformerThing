tool
extends Button


func _enter_tree() -> void:
	connect("pressed", self, "clicked")

func clicked():
	print("Hi")
