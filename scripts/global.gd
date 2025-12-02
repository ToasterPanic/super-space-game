extends Node

var orbit_zones = [
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
	{
		"name": "Test Zone 2",
		"distance": 2048 * 1.5,
		"spawns": []
	}
]
