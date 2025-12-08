extends VBoxContainer

var contract = null
var game = null

func update() -> void:
	$Label.text = """[font size=24]%s[/font]
%s""" % [global.missions[contract].name, global.missions[contract].desc]

func _on_button_pressed() -> void:
	game._contracts_item_pressed(contract)

func _ready() -> void:
	update()
