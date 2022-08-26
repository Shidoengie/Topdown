extends KinematicBody2D
var velocity = Vector2.ZERO
var is_reloading = false
var inventory_dict = {}
var current_weapon = Weapon.new()

export var walk_speed = 100
export var run_speed = 150
export var health = 100

onready var Leg_anim = get_node("Leg_anim")
onready var Body_anim = get_node("Body_anim")
onready var Reload_timer = get_node("Reload_timer")
onready var Firerate_timer = get_node("Firerate_timer")
onready var Weapon_ray = get_node("RayCast2D")

func _ready():
	current_weapon.current_name = "PISTOL"
func _physics_process(delta):
	Stats.player_health = health
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

	Weapon_ray.cast_to.x = Weapon.current_range
	Reload_timer.wait_time = Weapon.current_reload
	Firerate_timer.wait_time = Weapon.current_firerate
	
	var _current_ammo = Weapon.current_ammo[Weapon.current]
	var collider = Weapon_ray.get_collider()
	var not_null_or_tilemap = !(collider is TileMap) and Weapon_ray.is_colliding()
	var _melee_and_reloading = Weapon.current_type != "melee" and not is_reloading
	if ((_current_ammo < 1 and _melee_and_reloading) or 
		(_melee_and_reloading and Input.is_action_just_pressed("reload"))
	):
		Reload_timer.start()
		is_reloading = true
		
	if is_reloading:
		return
	match Weapon.current_type:
		"manual":
			if !Input.is_action_just_pressed("Shoot"):
				return
			Weapon.current_ammo[Weapon.current] -= 1
			if not_null_or_tilemap: 
				collider._health -= Weapon.current_dmg
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
				collider._health -= Weapon.current_dmg
				collider.current_state = 2
			melee_anim()
	
func melee_anim():
	match Weapon.current:
		Weapon.FISTS:
			Body_anim.play("punch")
	
func add_item(item_type, item_name):
	inventory_dict.keys().append(item_type)
	inventory_dict[item_type] = item_name
	
	match item_type:
		"Weapon":
			Weapon.current = item_name
		"Consumable":
			pass

func _on_Reload_timeout():
	if Weapon.current_clipsize[Weapon.current] < 1:
		return
	Weapon.current_ammo[Weapon.current] = Weapon.max_ammo[Weapon.current]
	Weapon.current_clipsize[Weapon.current] -= 1
	is_reloading = false

