extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var iforgor_skull = "uh oh i forgor"
var weapon = Weapon.new()
var weapon_name : String
# Called when the node enters the scene tree for the first time.
func _ready():
	 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_weapon("Weapon", weapon_name)
		queue_free()
