extends Line2D

func play() -> void:
	$AnimationPlayer.play("default")
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
