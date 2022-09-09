extends Area2D


func _ready():
	randomize()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.money += randi() % 50 + 20
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.stop()


func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
