extends Area2D

var weapon_name : String

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_weapon(weapon_name, GlobalInven.weapon_dict[weapon_name])
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.stop()


func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
