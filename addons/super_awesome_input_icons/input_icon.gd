extends Node

# If the player is using the gamepad, returns [code]true[/code].
static var using_gamepad = false 
## The type of the current gamepad. 
static var gamepad_type = "generic"
## The name of the current gamepad.
static var gamepad_name = "NoController"

## A dictionary where each JoyButton key corresponds to a string pair. Used for textures.
static var button_dictionary = {
	JOY_BUTTON_A: "down_action",
	JOY_BUTTON_B: "right_action",
	JOY_BUTTON_X: "left_action",
	JOY_BUTTON_Y: "up_action",
	JOY_BUTTON_DPAD_DOWN: "dpad_down",
	JOY_BUTTON_DPAD_LEFT: "dpad_left",
	JOY_BUTTON_DPAD_RIGHT: "dpad_right",
	JOY_BUTTON_DPAD_UP: "dpad_up",
	JOY_BUTTON_START: "start",
	JOY_BUTTON_MISC1: "select",
	JOY_BUTTON_LEFT_SHOULDER: "left_shoulder",
	JOY_BUTTON_RIGHT_SHOULDER: "left_shoulder",
	JOY_BUTTON_PADDLE1: "left_shoulder",
}

## A dictionary where each JoyAxis key corresponds to a string pair. Used for textures.
static var axis_dictionary = {
	JOY_AXIS_TRIGGER_LEFT: "left_trigger",
	JOY_AXIS_TRIGGER_RIGHT: "right_trigger"
}

func check_gamepad_type():
	if gamepad_name != Input.get_joy_name(0):
		gamepad_name = Input.get_joy_name(0)
		
		if gamepad_name.contains("PS4") or gamepad_name.contains("PS3") or gamepad_name.contains("PS2") or gamepad_name.contains("PS1") or gamepad_name.contains("PSX") or gamepad_name.contains("PlayStation"):
			gamepad_type = "playstation"
		elif gamepad_name.contains("Nintendo"):
			gamepad_type = "nintendo"
		else:
			gamepad_type = "generic"

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if using_gamepad:
			using_gamepad = false
	elif event is InputEventJoypadMotion:
		check_gamepad_type()
		
		if !using_gamepad:
			if abs(event.axis_value) > 0.5:
				using_gamepad = true
	elif event is InputEventJoypadButton:
		check_gamepad_type()
		
		if !using_gamepad:
			using_gamepad = true
