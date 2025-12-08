extends Node

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

var missions = {
	"waking_up": {
		"id": "waking_up",
		"name": "Waking Up",
		"desc": "Welcome back, spaceperson.",
		"rewards": {
			"marks": 500
		},
		"objectives": {
			"desk": "Visit the doctor at their desk",
			"follow": "Follow the doctor",
			"run": "My suggestion: RUN!",
			"escape": "Escape to your ship"
		}
	},
	"test_contract": {
		"id": "test_contract",
		"name": "HEMA Removal",
		"desc": "Space station 02 is currently overrun with HEMA mercenaries. We know they have a bomb in the storage warehouse. We want someone to plant that bomb on the station.",
		"rewards": {
			"marks": 500
		},
		"objectives": {
			"arrive": "Enter Space Station 02 (navigate to it via your navagent)",
			"collect_bomb": "Collect the bomb in the back room",
			"plant_bomb": "Plant the bomb in the main foyer",
			"escape": "Escape"
		}
	},
}

var contracts = [ "test_contract" ]

var ground_guns = {
	"pistol": {
		"name": "Oni",
		"type": "kinetic",
		"damage": 10,
		"magazine_size": 12,
		"fire_rate": 0.3
	},
	"docgun": {
		"name": "Docgun",
		"type": "kinetic",
		"damage": 150,
		"magazine_size": 12,
		"fire_rate": 0.25
	},
	"smg": {
		"name": "Ripper",
		"type": "energy",
		"damage": 8,
		"magazine_size": 24,
		"fire_rate": 1.0/6.0
	}
}

var checkpoint = null

func load_checkpoint():
	if checkpoint:
		get_tree().change_scene_to_packed(checkpoint)

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
		
	if json.data.stats: stats = json.data.stats
	
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
	
func set_story_progress(value: int) -> void:
	stats.story_progress = value
	
func set_active_mission(value = null) -> void:
	stats.active_mission = value

var default_stats = {
	"loaded": false,
	"fuel": 75,
	"fuel_tank_size": 1,
	"speed": 512,
	"boost_tank_size": 1,
	"marks": 200,
	"location": "space_station_1",
	"position": Vector2(),
	"rotation": 0,
	"story_progress": 0,
	"navigation_goal": null,
	"equipped_ground_gun": null,
	"gun_holstered": true,
	
	"active_mission": null,
	"mission_progress": 0,
	"completed_missions": [],
	
	"time": 0,
}

var stats = default_stats.duplicate_deep()

var settings = {
	"master_volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0,
}

func _ready() -> void:
	load_settings()
	
	LimboConsole.register_command(set_story_progress, "set_story_progress", "Sets the current story_progress variable")
	LimboConsole.register_command(set_active_mission, "set_active_mission", "Sets the current active_mission variable")

func _process(delta: float) -> void:
	global.stats.time += delta
