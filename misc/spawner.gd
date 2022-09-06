extends StaticBody2D
var health = 999999999999999
var current_state = 0
func _on_Timer_timeout():
	var projectile_scene = preload("res://scens/bullet.tscn").instance()
	add_child(projectile_scene)
