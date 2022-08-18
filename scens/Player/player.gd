extends KinematicBody2D
var velocity = Vector2.ZERO

enum leg_enum {RESET = -1,WALK = 0,RUN = 1}
enum body_enum {RESET = -1,PUNCH = 0,UNARMED = 1}
var leg_state
var body_state

export var walk_speed = 100
export var run_speed = 150

export var health = 100

func _physics_process(delta):
	Stats.player_health = health
	var inp_vec = Input.get_vector("left","right","up","down")
	var end_speed = 0
	if inp_vec == Vector2.ZERO:
		leg_state = leg_enum.RESET
	elif Input.is_action_pressed("Run"):
		end_speed = run_speed
		leg_state = leg_enum.RUN
	else:
		leg_state = leg_enum.WALK
		end_speed = walk_speed
		
	velocity = inp_vec
	look_at(get_global_mouse_position())
	
	velocity = move_and_slide(velocity*end_speed,Vector2.ZERO)
	if health < 0: get_tree().quit()

	anim()
	weapons()
func weapons():
	$RayCast2D.cast_to.x = Weapon.current_range
	var collider = $RayCast2D.get_collider()
	var not_null_or_tilemap = !(collider is TileMap) and $RayCast2D.is_colliding()
	
	match Weapon.current_type:
		"manual":
			if Input.is_action_just_pressed("Shoot"):
				pass
		"semi":
			if Input.is_action_pressed("Shoot"):
				pass
		"auto":
			if Input.is_action_pressed("Shoot"):
				pass
		"projectile":
			if Input.is_action_just_pressed("Shoot"):
				pass
		"melee":
			if Input.is_action_just_pressed("Shoot"):
				if not_null_or_tilemap:
					collider.health -= Weapon.current_dmg

func anim():
	var leg_anim = "RESET"
	var body_anim = "RESET"
	match body_state:
		body_enum.PUNCH:
			body_anim = "punch"
	match leg_state:
		leg_enum.WALK:
			leg_anim = "walk"
		leg_enum.RUN:
			leg_anim = "run"
	$Leg_anim.play(leg_anim)
