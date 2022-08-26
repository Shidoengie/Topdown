extends Item

class_name Weapon

var current_sprite
var current_name
var current_dmg
var current_firerate
var current_range
var current_reload

#stores all weapons max clipzises and ammunition 
var max_ammo = []
var max_clipsize = []
#stores current ammo and clipsize usage
var current_ammo = []
var current_clipsize = []

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_weapon("Weapon", current_name)
	pass
