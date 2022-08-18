extends Node2D

export(float) var character_speed = 10.0
var path = []
onready var test = preload("res://scens/Bullet.tscn")


func _process(delta):
#	var walk_distance = character_speed * delta
#	if $Enemies.get_child_count() != 0:
#		for body in $Enemies.get_children():
#			move_along_path(walk_distance,body)
#			_update_navigation_path(body.global_position, $Player.position)
	if Input.is_action_just_pressed("click"):
		var testinstance = test.instance()
		testinstance.transform = $Player.transform
		add_child(testinstance)
		
#
#func move_along_path(distance,body):
#	var last_point = body.position
#	while path.size():
#		var distance_between_points = last_point.distance_to(path[0])
#		if distance <= distance_between_points:
#			body.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
#			return
#		distance -= distance_between_points
#		last_point = path[0]
#		path.remove(0)
#	body.position = last_point
#
#
#
#func _update_navigation_path(start_position, end_position):
#	path = $Navigation2D.get_simple_path(start_position, end_position, true)
#	path.remove(0)
#
