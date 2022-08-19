extends Node


enum {GLOCK = 0 ,BOW = 1, FISTS = 2, BAT = 3}

var json_str = ""
var json_file = File.new()
var data

var unlocked = []
var current = FISTS

var current_name = ""
var current_dmg = 0
var current_firerate = 0
var project_speed = 0
var current_type = ""
var current_range = 0
var current_reload = 0

#stores all weapons max clipzises and ammunition 
var max_ammo = []
var max_clipsize = []
#stores current ammo and clipsize usage
var current_ammo = []
var current_clipsize = []

func _ready():
	json_file.open("res://Json/weapon.json",File.READ_WRITE)
	json_str = json_file.get_as_text()
	data = JSON.parse(json_str)
	for i in data.result:
		if i["type"] == "melee":
			continue
		max_ammo.append(i["ammo"])
		max_clipsize.append(i["clipsize"])
	current_ammo = max_ammo
	current_clipsize = max_clipsize

func _process(delta):
	match current:
			GLOCK:
				var dict = data.result[0]
				current_dmg = dict["dmg"]
				current_firerate = dict["firerate"]
				current_type = dict["type"]
				current_range = dict["range"]
				current_name = dict["name"]
				current_reload = dict["reload_time"]
			BOW:
				var dict = data.result[1]
				current_dmg = dict["dmg"]
				current_firerate = dict["firerate"]
				project_speed = dict["bolt_speed"]
				current_type = dict["type"]
				current_range = dict["range"]
				current_name = dict["name"]
				current_reload = dict["reload_time"]
			FISTS:
				var dict = data.result[2]
				current_dmg = dict["dmg"]
				current_firerate = dict["firerate"]
				current_type = dict["type"]
				current_range = dict["range"]
				current_name = dict["name"]
			BAT:
				var dict = data.result[3]
				current_dmg = dict["dmg"]
				current_firerate = dict["firerate"]
				current_type = dict["type"]
				current_range = dict["range"]
				current_name = dict["name"]
				
