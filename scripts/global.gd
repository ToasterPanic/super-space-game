extends Node

var using_gamepad = false 
var ground_location = null

var orbit_zones = [
	{
		"name": "The Star",
		"distance": 2048 * 1.5,
		"spawns": []
	},
	{
		"name": "Test Zone",
		"distance": 0,
		"spawns": [
			{
				"type": "asteroid",
				"chance_percent": 100,
				"amount_min": 4,
				"amount_max": 5,
			}
		]
	},
	
]

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if using_gamepad:
			using_gamepad = false
	elif event is InputEventJoypadMotion:
		if !using_gamepad:
			if abs(event.axis_value) > 0.5:
				using_gamepad = true
	elif event is InputEventJoypadButton:
		if !using_gamepad:
			using_gamepad = true
