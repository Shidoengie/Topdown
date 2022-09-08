extends KinematicBody2D

signal health_changed(old_value, new_value)


var velocity = Vector2.ZERO
var is_reloading = false
var cant_shoot = false
var inventory_dict = {}

var driven_auto
var closest_auto_dist = -INF
var closest_auto
var auto_arr = []
var near_auto = false
var in_auto

var current_weapon : Weapon
var money = 0
var end_speed = 0
var max_stamina
var hp_RegenTime
var stamina
var walk_speed
var run_speed
var max_runspeed
var max_health
var health

var health_changed = false
var can_regen_stamina = false
var can_regen_health = false

onready var Body_anim = get_node("Body_anim")
onready var Reload_timer = get_node("Reload_timer")
onready var Weapon_ray = get_node("RayCast2D")
onready var Rest_Timer = get_node("Rest_Timer")
onready var Leg_State_anim = get_node("Leg_State")
onready var Heal_timer = get_node("Heal_timer")
onready var GUI = get_parent().find_node("GUI")
var Leg_state

func _ready():
	var json_file = File.new()
	json_file.open("res://Json/PlayerStats.json",File.READ_WRITE)
	var json_str = json_file.get_as_text()
	var data = JSON.parse(json_str)
	max_stamina = data.result["max_stamina"]
	max_health = data.result["max_health"]
	hp_RegenTime = data.result["hp_RegenTime"]
	Rest_Timer.wait_time = data.result["stamina_RegenTime"]
	Heal_timer.wait_time = data.result["hp_RegenTime"]
	walk_speed = data.result["walk_speed"]
	run_speed = data.result["run_speed"]
	health = max_health
	stamina = max_stamina
	max_runspeed = run_speed
	current_weapon = GlobalInven.weapon_dict["AUTO_PISTOL"].duplicate()
	inventory_dict[current_weapon.model_name] = current_weapon
	Leg_state = Leg_State_anim.get("parameters/playback")
	GUI.update_health(health)
func _process(delta):
	if near_auto:
		closest_auto_dist = global_position.distance_to(closest_auto.position)
	regen(delta)
	if in_auto:
		global_position = driven_auto.global_position

func _input(event):
	if Input.is_action_pressed("Run") and not in_auto:
		can_regen_stamina = false
		Rest_Timer.stop()
	else:
		Rest_Timer.start()
	if Input.is_action_just_pressed("CarEnter") and near_auto and not in_auto:
		hide()
		set_physics_process(false)
		closest_auto.set_physics_process(true)
		$Car_range/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		in_auto = true
		driven_auto = closest_auto
	elif Input.is_action_just_pressed("CarEnter") and in_auto:
		show()
		set_physics_process(true)
		closest_auto.set_physics_process(false)
		$Car_range/CollisionShape2D.disabled = false
		$CollisionShape2D.disabled = false
		in_auto = false
		driven_auto = closest_auto
		position.x += 48
func _physics_process(delta):
	run_speed = clamp(run_speed,walk_speed,max_runspeed)
	var inp_vec = Input.get_vector("left","right","up","down")
	if inp_vec == Vector2.ZERO:
		Leg_state.travel("RESET")
	elif Input.is_action_pressed("Run"):
		
		if stamina <= 0 and run_speed > walk_speed:
			var old_health = health
			health -= 2 *delta
			run_speed -= 15 * delta
			emit_signal("health_changed", old_health, health)
			Leg_state.travel("run")
		elif stamina > 0:
			stamina -=  8*delta
			Leg_state.travel("run")
		else:
			Leg_state.travel("walk")
		end_speed = run_speed
	else:
		end_speed = walk_speed
		Leg_state.travel("walk")
	velocity = inp_vec
	look_at(get_global_mouse_position())

	velocity = move_and_slide(velocity*end_speed,Vector2.ZERO)
	if health <= 0: 
		get_tree().quit()
	weapons()

func regen(delta):
	if can_regen_stamina:
		stamina += 10*delta
		run_speed += 10*delta
		if stamina > max_stamina:
			can_regen_stamina = false
			stamina = max_stamina
			
	if can_regen_health:
		var old_health = health
		health += 5*delta
		if health > max_health:
			can_regen_health = false
			health = max_health
		emit_signal("health_changed", old_health, health)

#Weapons
func weapons():

	Weapon_ray.cast_to.x = current_weapon.attack_range
	Reload_timer.wait_time = current_weapon.reload_time 
	var _current_ammo = current_weapon.ammo
	var collider = Weapon_ray.get_collider()
	var not_null_or_tilemap = !(collider is TileMap) and Weapon_ray.is_colliding()
	var _melee_and_reloading = current_weapon.uses_ammo and not is_reloading

	Body_anim.playback_speed = current_weapon.firerate
	
	if ((_current_ammo < 1 and _melee_and_reloading) or 
		(_melee_and_reloading and Input.is_action_just_pressed("reload"))
	):
		Reload_timer.start()
		is_reloading = true

	if is_reloading or cant_shoot:
		return
	
	if current_weapon.single_fire:
		if !Input.is_action_just_pressed("Shoot"):
			return
		if current_weapon.uses_ammo:
			current_weapon.ammo -= 1
		weapon_anim()
		if current_weapon.projectile:
			return
		if not_null_or_tilemap: 
			collider.health -= current_weapon.dammage
			collider.current_state = 2
	else:
		if !Input.is_action_pressed("Shoot"):
			return
		weapon_anim()
		if current_weapon.uses_ammo:
			current_weapon.ammo -= 1
		if not_null_or_tilemap: 
			collider.health -= current_weapon.dammage
			collider.current_state = 2

func weapon_anim():
	match current_weapon.model_name:
		"FISTS":
			Body_anim.play("punch")
		"PISTOL":
			Body_anim.play("Shoot")
		_:
			Body_anim.play("Shoot")

func add_weapon(name, weapon):
	if inventory_dict.has(name):
		var inv_wp = inventory_dict[name] as Weapon
		if inv_wp.ammo == inv_wp.max_ammo:
			inv_wp.clip = clamp(inv_wp.clip + 1 ,0,inv_wp.max_clip)
			return
		inv_wp.ammo = inv_wp.max_ammo
	inventory_dict[name] = weapon

func _on_Reload_timeout():
	if current_weapon.clip < 1:
		return
	current_weapon.ammo = current_weapon.max_ammo
	current_weapon.clip -= 1
	is_reloading = false

#Animations
func _on_Body_anim_animation_finished(anim_name):
	cant_shoot = false
	
func _on_Body_anim_animation_started(anim_name):
	cant_shoot = true

#Stat regen and update
func _on_Rest_Timer_timeout():
	can_regen_stamina = true

func _on_Heal_timer_timeout():
	can_regen_health = true

func take_dmg(amount):
	var old_health = health
	health -= amount
	emit_signal("health_changed", old_health, health)
	
func _on_Player_health_changed(old_value, new_value):
	if old_value > new_value:
		Heal_timer.start()
	GUI.update_health(new_value)
#CAR
func _on_Car_range_body_entered(body):
	if body.is_in_group("Cars"):
		near_auto = true
		auto_arr.append(body)
		if closest_auto_dist < global_position.distance_to(body.position):
			closest_auto = body

func _on_Car_range_body_exited(body):
	if body.is_in_group("Cars"):
		auto_arr.erase(body)
		if auto_arr.empty():
			near_auto = false

	
