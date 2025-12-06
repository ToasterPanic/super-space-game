extends VBoxContainer

var goal = null
var game = null

func update() -> void:
	var player = game.get_node("Player")
	
	var distance = floori((goal.point.global_position - player.position).length())
	
	$Label.text = """[font size=24]%s[/font]
%su away""" % [goal.name, str(distance)]

func _on_button_pressed() -> void:
	game._navigation_item_pressed(goal)
