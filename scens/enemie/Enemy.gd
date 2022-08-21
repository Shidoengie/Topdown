extends KinematicBody2D

onready var ray1 = get_node("RayCast2D")
onready var ray2 = get_node("RayCast2D2")
onready var ray3 = get_node("RayCast2D3")
onready var timer = get_node("Timer")

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
		# NOTE: replace position setting with 
		1:
			var ray_arr = [ray1.get_collider(),ray2.get_collider(),ray3.get_collider()]
			if not (player in ray_arr):
				seeing_player = false
			else:
				seeing_player = true
			if seeing_player or been_hit: 
				look_at(player.global_position)
				been_hit = false
				var player_distance = global_position.distance_to(player.position)
				if player_distance > 200:
					position -= -player.global_position.normalized()*100 * delta
			elif not seeing_player:
				position = player.global_position
		# hit
		2:
			been_hit = true
			current_state = HUNT

func _on_Area2D_body_entered(body):
	if body == player:
		current_state = HUNT
		timer.stop()
		seeing_player = true

func _on_Area2D_body_exited(body):
	if body == player:
		timer.start()
		seeing_player = false


func _on_Timer_timeout():
	current_state = SEARCH
