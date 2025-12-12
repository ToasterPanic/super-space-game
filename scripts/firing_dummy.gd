extends "res://scripts/character_ground.gd"

func _ready() -> void:
	super()
	
	health = 1000
	max_health = 1000

func _process(delta: float) -> void:
	super(delta)
	
	if health <= 100:
		health = 1000
