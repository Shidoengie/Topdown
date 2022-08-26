extends KinematicBody2D

onready var ray1 = get_node("RayCast2D")
onready var ray2 = get_node("RayCast2D2")
onready var ray3 = get_node("RayCast2D3")
onready var timer = get_node("Timer")

onready var player = get_parent().get_parent().find_node("Player") as KinematicBody2D
onready var nav = get_parent().get_parent().find_node("Navigation2D") as Navigation2D

var velocity = Vector2.ZERO
var path = []

export var _walkspeed = 100
export var _health = 200

enum {SEARCH = 0,HUNT =1,HIT = 2}
var current_state = SEARCH
var seeing_player = false
var been_hit = false
var path_update = true

var current_weapon = Weapon.WEAPON_ENUM.PISTOL

func _ready():
	pass

func _process(delta):
	
	if _health < 1:
		drop_weapon()
		queue_free()
	
	# State Machine
	match current_state:
		# Search
		0:
			pass
		# Hunt
		1:
			hunt_func(delta)
		# hit
		2:
			been_hit = true
			current_state = HUNT


func hunt_func(delta):
	var ray_arr = [ray1.get_collider(),ray2.get_collider(),ray3.get_collider()]
	
	if not (player in ray_arr):
		seeing_player = false
	else:
		seeing_player = true
		
	if seeing_player or been_hit:
		look_at(player.global_position)
		been_hit = false
		path_update = true
		var player_distance = global_position.distance_to(player.position)
		
		if player_distance > 200:
			path = nav.get_simple_path(global_position,player.global_position)
			move_along_path(_walkspeed*delta)
	
	elif not seeing_player:
		if path_update:
			path = nav.get_simple_path(global_position,player.global_position)
			path_update = false
		move_along_path(_walkspeed*delta)

func move_along_path(distance):
	var last_point = position
	while path.size() > 1:
		var distance_between_points = last_point.distance_to(path[1])
		if distance <= distance_between_points:
			position = last_point.linear_interpolate(path[1], distance / distance_between_points)
			return
		distance -= distance_between_points
		last_point = path[1]
		path.remove(1)
	position = last_point

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
	
func drop_weapon():
	var weapon_scene = preload("res://scens/weapon.tscn").instance()
	weapon_scene.get_node("Sprite").texture = ""
	print("weapon_scene.iforgor_skull")
	get_parent().add_child(weapon_scene)
	
	
