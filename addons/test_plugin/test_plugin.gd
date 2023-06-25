tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("NewButton", "Button", preload("res://addons/test_plugin/pluginButton.gd"), preload("res://icon.png"))


func _exit_tree() -> void:
	remove_custom_type("NewButton")
