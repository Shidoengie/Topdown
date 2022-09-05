extends Area2D

export var speed = 750
var velocity = Vector2.ZERO
var dir
export var damage = 50
func _ready():
	dir = transform.x
func _physics_process(delta):
	position += dir * speed * delta

func _on_Bullet_body_entered(body):
	var dict = {}
	
	if not body is TileMap:
		body.health -= damage
		queue_free()
		body.current_state = 2
		return
	queue_free()
