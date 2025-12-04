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

var stats = {
	"fuel": 12,
	"fuel_tank_size": 1,
	"speed": 512,
	"boost_tank_size": 1,
	"marks": 200,
}
