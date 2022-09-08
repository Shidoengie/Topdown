extends Node2D

onready var player = $Player
var in_auto
var driven_auto = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	if in_auto:
		player.global_position = driven_auto.global_position

func _input(event):
	
	if Input.is_action_just_pressed("CarEnter") and player.near_auto and not in_auto:
		player.hide()
		player.set_physics_process(false)
		player.closest_auto.set_physics_process(true)
		$Player/Car_range/CollisionShape2D.disabled = true
		$Player/CollisionShape2D.disabled = true
		in_auto = true
		driven_auto = player.closest_auto
	elif Input.is_action_just_pressed("CarEnter") and in_auto:
		player.show()
		player.set_physics_process(true)
		player.closest_auto.set_physics_process(false)
		$Player/Car_range/CollisionShape2D.disabled = false
		$Player/CollisionShape2D.disabled = false
		in_auto = false
		driven_auto = player.closest_auto
		player.position.x += 48
