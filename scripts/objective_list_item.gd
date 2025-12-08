extends Label

var progress = 1
var hiding = false

func _ready() -> void:
	$AnimationPlayer.play("show")
	
func _process(delta: float) -> void:
	if hiding: return
	
	if global.stats.mission_progress >= progress:
		hiding = true
		
		$AnimationPlayer.play("hide")
		
		await $AnimationPlayer.animation_finished
		
		queue_free()
