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
		weapon.model_name = i
		weapon.type = inner_dict["type"]
		weapon.attack_range = inner_dict["range"]
		weapon.firerate= inner_dict["firerate"]
		if inner_dict["can_shoot"]:
			weapon.max_ammo = inner_dict["ammo"]
			weapon.ammo = inner_dict["ammo"]
			weapon.clipsize = inner_dict["clipsize"]
			weapon.max_clipsize = inner_dict["clipsize"]
			weapon.reload_time = inner_dict["reload_time"]
		else:
			weapon.max_ammo = 1
			weapon.ammo = 1
			weapon.clipsize = 1
			weapon.max_clipsize = 1
			weapon.reload_time = 1
		weapon_dict[i] = weapon
	print(weapon_dict)
func pick_item():
	
	pass

	# Check for weapons that need ammo
#	for i in data.result:
#		if i["type"] == "melee":
#			continue
#		max_ammo.append(i["ammo"])
#		max_clipsize.append(i["clipsize"])
#	current_ammo = max_ammo.duplicate()
#	current_clipsize = max_clipsize.duplicate()
