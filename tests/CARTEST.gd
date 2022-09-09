extends Node2D

func _process(delta):
	$VectorDisplay2D.position = $Car.position
