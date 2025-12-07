extends Node2D

func play():
	var last = null
	for n in get_children():
		last = n
		n.restart()
		
	await last.finished
	
	queue_free()
