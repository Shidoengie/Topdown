extends Node

var inventory_dictionary = {}

var weapon_dict  = {}


#List of currently available weapons
var unlocked_weapons = []

func _ready():
	load_weapons()
	
func load_weapons() -> void:
	var json_file = File.new()
	json_file.open("res://Json/weapon.json",File.READ_WRITE)
	var json_str = json_file.get_as_text()
	var data = JSON.parse(json_str)

	for i in data.result:
		var inner_dict = data.result[i]
		var weapon = Weapon.new()
		weapon.model_name = str(i)
		weapon.sprite_texture = load("res://assets/weapon/" + "PISTOL" + ".png")
		weapon.single_fire = inner_dict["single_fire"]
		weapon.attack_range = inner_dict["range"]
		weapon.firerate = inner_dict["firerate"]
		weapon.dammage = inner_dict["dmg"]
		weapon.uses_ammo = inner_dict["can_shoot"]
		weapon.projectile = inner_dict["projectile"]
		if weapon.uses_ammo:
			weapon.max_ammo = inner_dict["ammo"]
			weapon.ammo = inner_dict["ammo"]
			weapon.clip = inner_dict["clipsize"]
			weapon.max_clip = inner_dict["clipsize"]
			weapon.reload_time = inner_dict["reload_time"]
		else:
			weapon.max_ammo = 1
			weapon.ammo = 1
			weapon.clip= 1
			weapon.max_clip = 1
			weapon.reload_time = 1
		weapon_dict[i] = weapon
		
func load_vehicle(vname,node) -> void:
	var json_file = File.new()
	json_file.open("res://Json/VehicleStats.json",File.READ_WRITE)
	var json_str = json_file.get_as_text()
	var data = JSON.parse(json_str)
	var inner_dict = data.result[vname]
	node.wheel_base = inner_dict["wheel_base"]
	node.engine_power = inner_dict["engine_power"]
	node.wheel_base = inner_dict["wheel_base"]
	node.steering_angle = inner_dict["steering_angle"]
	node.friction = inner_dict["friction"]
	node.drag = inner_dict["drag"]
	node.braking = inner_dict["braking"]
	node.max_speed_reverse = inner_dict["max_speed_reverse"]
	node.slip_speed = inner_dict["slip_speed"]
	node.traction_fast = inner_dict["traction_fast"]
	node.traction_slow = inner_dict["traction_slow"]
