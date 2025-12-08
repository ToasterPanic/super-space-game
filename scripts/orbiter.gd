extends Node2D

@export var orbit_speed: float = 1

func _ready() -> void:
	rotation_degrees = orbit_speed * global.stats.time

func _physics_process(delta: float) -> void:
	rotation_degrees += orbit_speed * delta
