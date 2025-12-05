extends Node2D

func play():
	for n in get_children():
		n.restart()
