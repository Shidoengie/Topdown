extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.money += randi() % 50 + 20
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.stop()


func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
