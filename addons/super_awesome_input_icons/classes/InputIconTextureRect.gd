## Like a [TextureRect], but automatically updates as an input icon based on the provided [param action_name].
extends TextureRect
class_name InputIconTextureRect

@export var action_name = &"":
	set(value):
		action_name = value
		_update_icon()

var known_using_gamepad = null
var known_gamepad_name = null

var time_until_next_check = 0

## Updates the current icon.
func _update_icon():
	var events = InputMap.action_get_events(action_name)
	
	for n in events:
		if ("keycode" in n) and !input_icon.using_gamepad:
			var keycode = n.keycode if n.keycode else n.physical_keycode
			
			texture = load("res://addons/super_awesome_input_icons/textures/keyboard/" + OS.get_keycode_string(keycode).to_lower() + ".png")
			
			break
			
		elif ("button_index" in n) and input_icon.using_gamepad:
			if input_icon.gamepad_type:
				texture = load("res://addons/super_awesome_input_icons/textures/" + input_icon.gamepad_type + "/" + input_icon.button_dictionary[n.button_index] + ".png")
				break

func _process(delta: float) -> void:
	time_until_next_check -= delta
	
	if time_until_next_check < 0:
		time_until_next_check = 0.2
		
		if known_gamepad_name != input_icon.gamepad_name:
			_update_icon()
			known_gamepad_name = input_icon.gamepad_name
			
		elif known_using_gamepad != input_icon.using_gamepad:
			_update_icon()
			known_using_gamepad = input_icon.using_gamepad
