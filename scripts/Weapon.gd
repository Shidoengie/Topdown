extends Item

class_name Weapon

var sprite_path : String
var sprite_texture : Texture 
var model_name : String
var dammage  : float
var firerate  : int
var attack_range : float
var reload_time : float
var ammo : int
var max_ammo : int
var clipsize : int
var max_clipsize : int
var uses_ammo : bool

func _init(sprite_path):
	sprite_texture = load(sprite_path)
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_weapon("Weapon", model_name)
	pass
