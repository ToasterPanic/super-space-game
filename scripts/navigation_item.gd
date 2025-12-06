extends VBoxContainer

var goal = null
var game = null

func _on_button_pressed() -> void:
	game._navigation_item_pressed(goal)
