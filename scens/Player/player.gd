extends KinematicBody2D
var velocity = Vector2.ZERO

export var walk_speed = 100
export var run_speed = 150

export var health = 100

func _physics_process(delta):
	Stats.player_health = health
	var inp_vec = Input.get_vector("left","right","up","down")
	var end_speed = 0
	if inp_vec == Vector2.ZERO:
		$Leg_anim.play("RESET")
	elif Input.is_action_pressed("Run"):
		end_speed = run_speed
		$Leg_anim.play("run")
	else:
		end_speed = walk_speed
		$Leg_anim.play("walk")
		
	velocity = inp_vec
	look_at(get_global_mouse_position())
	
	velocity = move_and_slide(velocity*end_speed,Vector2.ZERO)
	if health < 0: get_tree().quit()

	weapons()
func weapons():
	$RayCast2D.cast_to.x = Weapon.current_range
	$Timer.wait_time = Weapon.current_reload
	var collider = $RayCast2D.get_collider()
	var not_null_or_tilemap = !(collider is TileMap) and $RayCast2D.is_colliding()
	
	match Weapon.current_type:
		"manual":
			if Input.is_action_just_pressed("Shoot"):
				pass
		"auto":
			if Input.is_action_pressed("Shoot"):
				pass
		"projectile":
			if Input.is_action_just_pressed("Shoot"):
				pass
		"melee":
			if !Input.is_action_just_pressed("Shoot"):
				return
			if not_null_or_tilemap: 
				collider.health -= Weapon.current_dmg
				collider.current_state = 2
			melee_anim()
func melee_anim():
	match Weapon.current:
		Weapon.FISTS:
			$Body_anim.play("punch")
	


func _on_Reload_timeout():
	Weapon.current_ammo
	pass # Replace with function body.
