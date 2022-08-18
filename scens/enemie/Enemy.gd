extends KinematicBody2D

onready var player = get_parent().get_parent().find_node("Player") as KinematicBody2D
var velocity = Vector2.ZERO
export var health = 200

enum {SEARCH = 0,HUNT =1,HIT = 2}
var current_state = SEARCH
var seeing_player = false
var been_hit = false

func _process(delta):
	if health < 1:
		queue_free()
	
	# State Machine
	match current_state:
		
		# Search
		0:
			pass
		# Hunt
		1:
			var ray_arr = [$RayCast2D.get_collider(),$RayCast2D2.get_collider(),$RayCast2D3.get_collider()]
			if !(player in ray_arr):
				seeing_player = false
			else:
				seeing_player = true
			if seeing_player or been_hit: 
				look_at(player.global_position)
				been_hit = false
		# hit
		2:
			been_hit = true
			current_state = HUNT

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		current_state = HUNT
		$Timer.stop()
		seeing_player = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Timer.start()
		seeing_player = false


func _on_Timer_timeout():
	current_state = SEARCH
