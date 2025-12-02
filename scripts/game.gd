extends Node2D

func _process(delta: float) -> void:
	$UI/Control/BoostText.text = "BOOST: " + str($Player.boost)
