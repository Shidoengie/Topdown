extends KinematicBody2D

var velocity = Vector2.ZERO
var is_reloading = false
var cant_shoot = false
var inventory_dict = {}

var current_weapon : Weapon
var money = 0

var max_stamina
var hp_RegenTime
var stamina
var walk_speed
var run_speed
var max_health
var health

var can_regen_stamina = false
var can_regen_health = false

onready var Leg_anim = get_node("Leg_anim")
onready var Body_anim = get_node("Body_anim")
onready var Reload_timer = get_node("Reload_timer")
onready var Weapon_ray = get_node("RayCast2D")
onready var Rest_Timer = get_node("Rest_Timer")

func _ready():
	var json_file = File.new()
	json_file.open("res://Json/PlayerStats.json",File.READ_WRITE)
	var json_str = json_file.get_as_text()
	var data = JSON.parse(json_str)
	max_stamina = data.result["max_stamina"]
	max_health = data.result["max_health"]
	hp_RegenTime = data.result["hp_RegenTime"]
	Rest_Timer.wait_time = data.result["stamina_RegenTime"]
	walk_speed = data.result["walk_speed"]
	run_speed = data.result["run_speed"]
	health = max_health
	stamina = max_stamina
	current_weapon = GlobalInven.weapon_dict["AUTO_PISTOL"].duplicate()
	inventory_dict[current_weapon.model_name] = current_weapon
	
func _physics_process(delta):
	var inp_vec = Input.get_vector("left","right","up","down")
	var end_speed = 0
	if inp_vec == Vector2.ZERO:
		Leg_anim.play("RESET")
	elif Input.is_action_pressed("Run"):
		can_regen_stamina = false
		Rest_Timer.start()
		end_speed = run_speed
		Leg_anim.play("run")
		if stamina <= 0:
			health -= 5 *delta
		else:
			stamina -=  15*delta
	else:
		Rest_Timer.start()
		end_speed = walk_speed
		Leg_anim.play("walk")
	velocity = inp_vec
	look_at(get_global_mouse_position())

	velocity = move_and_slide(velocity*end_speed,Vector2.ZERO)
	if health <= 0: 
		get_tree().quit()
	weapons()
	if can_regen_stamina:
		stamina += 10*delta
		if stamina > max_stamina:
			can_regen_stamina = false
			stamina = max_stamina
		
	if can_regen_health:
		health += 5*delta
		if health > max_health:
			can_regen_health = true
			health = max_health
			
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
			collider._health -= current_weapon.dammage
			collider.current_state = 2
	else:
		if !Input.is_action_pressed("Shoot"):
			return
		weapon_anim()
		if current_weapon.uses_ammo:
			current_weapon.ammo -= 1
		if not_null_or_tilemap: 
			collider._health -= current_weapon.dammage
			collider.current_state = 2

func weapon_anim():
	match current_weapon.model_name:
		"FISTS":
			Body_anim.play("punch")
		"PISTOL":
			Body_anim.play("punch")
		_:
			Body_anim.play("punch")

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

func _on_Body_anim_animation_finished(anim_name):
	cant_shoot = false

func _on_Body_anim_animation_started(anim_name):
	cant_shoot = true

func _on_Rest_Timer_timeout():
	can_regen_stamina = true
