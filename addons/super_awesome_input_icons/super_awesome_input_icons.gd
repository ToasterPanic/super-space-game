@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("input_icon", "res://addons/super_awesome_input_icons/input_icon.gd")
	
func _exit_tree() -> void:
	remove_autoload_singleton("input_icon")
