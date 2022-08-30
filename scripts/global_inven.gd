extends Node

var inventory_dictionary = {}

var weapon_dict  = {}
var json_str = ""
var json_file = File.new()
var data

#List of currently available weapons
var unlocked_weapons = []

func _ready():
	json_file.open("res://Json/weapon.json",File.READ_WRITE)
	json_str = json_file.get_as_text()
	data = JSON.parse(json_str)
	for i in data.result:
		var inner_dict = data.result[i]
		var weapon = Weapon.new()
		weapon.model_name = str(i)
		weapon.sprite_texture = load("res://assets/weapon/" + "PISTOL" + ".png")
		weapon.type = inner_dict["type"]
		weapon.attack_range = inner_dict["range"]
		weapon.firerate = inner_dict["firerate"]
		weapon.dammage = inner_dict["dmg"]
		weapon.uses_ammo = inner_dict["can_shoot"]
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
