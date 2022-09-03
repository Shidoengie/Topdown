extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var money_value : int
# Called when the node enters the scene tree for the first time.
func _ready():
	 
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.money += money_value
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.stop()


func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start()
	

func _on_Timer_timeout():
	queue_free()
