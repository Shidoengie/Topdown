extends KinematicBody2D

var health : float
var wheel_base = 120
export var steering_angle = 10
var engine_power = 800
var friction = -0.9
export var drag = -0.001
var braking = -450
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction
var vroom = 1

func _ready():
	GlobalInven.load_vehicle("Car",$".")
	if get_tree().current_scene.name != "Car" and get_tree().current_scene.name != "CARTEST":
		set_physics_process(false)
	
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
	
func get_input():
	
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 3
	if Input.is_action_pressed("left"):
		turn -= 3
	
	steer_direction = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("Run"):
		vroom = 1.5
	elif Input.is_action_just_released("Run"):
		vroom = 1
	if Input.is_action_pressed("up"):
		acceleration = transform.x * engine_power * vroom
	if Input.is_action_pressed("down"):
		acceleration = transform.x * braking * vroom
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
