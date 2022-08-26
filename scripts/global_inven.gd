extends Node

var inventory_dictionary = {}
var json_str = ""
var json_file = File.new()
var data

#List of currently available weapons
var unlocked_weapons = []

func _ready():
	json_file.open("res://Json/weapon.json",File.READ_WRITE)
	json_str = json_file.get_as_text()
	data = JSON.parse(json_str)
	
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
