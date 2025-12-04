## Like a [TextureRect], but automatically updates as an input icon based on the provided [param action_name].
extends TextureRect
class_name InputIconTextureRect

## The action used for the input icon.
@export var action_name: String = &"":
	set(value):
		action_name = value
		_update_icon()

var _known_using_gamepad = null
var _known_gamepad_name = null

var _time_until_next_check = 0

## Updates the current icon.
func _update_icon():
	
	# Loop through all events in an action:
	
	var events = InputMap.action_get_events(action_name)
	
	for n in events:
		print(n)
		
		# If it's a keyboard input and we're not using a gamepad, use a keyboard input icon
		
		if n.is_class("InputEventKey") and !input_icon.using_gamepad:
			var keycode = n.keycode if n.keycode else n.physical_keycode
			
			texture = load("res://addons/super_awesome_input_icons/textures/keyboard/" + OS.get_keycode_string(keycode).to_snake_case() + ".png")
			
			break
			
				
		# If it's a mouse input and we're using a gamepad, use the corresponding gamepad input icon
			
		elif n.is_class("InputEventMouseButton") and !input_icon.using_gamepad:
			texture = load("res://addons/super_awesome_input_icons/textures/mouse/" + input_icon.mouse_button_dictionary[n.button_index] + ".png")
			
			break
		
		# If it's a gamepad input and we're using a gamepad, use the corresponding gamepad input icon
			
		elif n.is_class("InputEventJoypadButton") and input_icon.using_gamepad:
			if input_icon.gamepad_type:
				texture = load("res://addons/super_awesome_input_icons/textures/" + input_icon.gamepad_type + "/" + input_icon.button_dictionary[n.button_index] + ".png")
				
				break

func _process(delta: float) -> void:
	_time_until_next_check -= delta
	
	if _time_until_next_check < 0:
		_time_until_next_check = 0.2
		
		if _known_gamepad_name != input_icon.gamepad_name:
			_update_icon()
			_known_gamepad_name = input_icon.gamepad_name
			
		elif _known_using_gamepad != input_icon.using_gamepad:
			_update_icon()
			_known_using_gamepad = input_icon.using_gamepad
