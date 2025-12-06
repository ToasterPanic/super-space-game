extends Node

func _ready() -> void:
	load_settings()

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

func generate_save():
	var save_dict = {
		"stats": stats
	}
	return save_dict
	
## Saves the game in its current state.
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(generate_save())

	save_file.store_line(json_string)
	
func save_settings():
	var save_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	
	var json_string = JSON.stringify(settings)

	save_file.store_line(json_string)
	
## Loads the game data from the savegame.save file.
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	var json = JSON.new()

	var parse_result = json.parse(save_file.get_as_text())
	
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", parse_result, " at line ", json.get_error_line())
		return
		
	if json.data.settings: settings = json.data.settings
	if json.data.stats: settings = json.data.stats
	
func load_settings():
	if not FileAccess.file_exists("user://settings.json"):
		return

	var save_file = FileAccess.open("user://settings.json", FileAccess.READ)
	
	var json = JSON.new()

	var parse_result = json.parse(save_file.get_as_text())
	
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", parse_result, " at line ", json.get_error_line())
		return
		
	settings = json.data
	
func delete_game():
	await DirAccess.remove_absolute("user://savegame.save")

var default_stats = {
	"loaded": false,
	"fuel": 12,
	"fuel_tank_size": 1,
	"speed": 512,
	"boost_tank_size": 1,
	"marks": 200,
	"location": "space",
	"ship_position": Vector2(),
	"ship_rotation": 0,
	"story_progress": 1,
}

var stats = default_stats.duplicate_deep()

var settings = {
	"master_volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0,
}
