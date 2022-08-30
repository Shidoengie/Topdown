extends KinematicBody2D

var velocity = Vector2.ZERO
var is_reloading = false
var inventory_dict = {}

var current_weapon : Weapon

export var walk_speed = 100
export var run_speed = 150
export var health = 100

onready var Leg_anim = get_node("Leg_anim")
onready var Body_anim = get_node("Body_anim")
onready var Reload_timer = get_node("Reload_timer")
onready var Firerate_timer = get_node("Firerate_timer")
onready var Weapon_ray = get_node("RayCast2D")

func _ready():
	
	current_weapon = GlobalInven.weapon_dict["PISTOL"].duplicate()
	inventory_dict["PISTOL"] = current_weapon
	
func _physics_process(delta):
	GameManager.player_health = health
	var inp_vec = Input.get_vector("left","right","up","down")
	var end_speed = 0
	if inp_vec == Vector2.ZERO:
		Leg_anim.play("RESET")
	elif Input.is_action_pressed("Run"):
		end_speed = run_speed
		Leg_anim.play("run")
	else:
		end_speed = walk_speed
		Leg_anim.play("walk")

	velocity = inp_vec
	look_at(get_global_mouse_position())

	velocity = move_and_slide(velocity*end_speed,Vector2.ZERO)
	if health < 0: get_tree().quit()
	weapons()
func weapons():

	Weapon_ray.cast_to.x = current_weapon.attack_range
	
	Reload_timer.wait_time = current_weapon.reload_time 
#	Firerate_timer.wait_time = current_weapon.firerate
	Firerate_timer.wait_time = 1

	var _current_ammo = current_weapon.ammo
	var collider = Weapon_ray.get_collider()
	var not_null_or_tilemap = !(collider is TileMap) and Weapon_ray.is_colliding()
	var _melee_and_reloading = current_weapon.uses_ammo and not is_reloading
	
	if ((_current_ammo < 1 and _melee_and_reloading) or 
		(_melee_and_reloading and Input.is_action_just_pressed("reload"))
	):
		Reload_timer.start()
		is_reloading = true

	if is_reloading:
		return
	match current_weapon.type:
		"manual":
			if !Input.is_action_just_pressed("Shoot"):
				return
			current_weapon.ammo -= 1
			if not_null_or_tilemap: 
				collider._health -= current_weapon.dammage
				collider.current_state = 2
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
				collider._health -= current_weapon.dammage
				collider.current_state = 2
			melee_anim()

func melee_anim():
	match current_weapon.model_name:
		"FISTS":
			Body_anim.play("punch")

func add_weapon(name, weapon):
	
	if inventory_dict.has(name):
		var inv_wp = inventory_dict[name] as Weapon
		if inv_wp.ammo == inv_wp.max_ammo:
			inv_wp.clip = clamp(inv_wp.clip + 1,0,inv_wp.max_clip)
			return
		inv_wp.ammo = inv_wp.max_ammo
	inventory_dict[name] = weapon
	
func _on_Reload_timeout():
	if current_weapon.clip < 1:
		return
	current_weapon.ammo = current_weapon.max_ammo
	current_weapon.clip -= 1
	is_reloading = false

