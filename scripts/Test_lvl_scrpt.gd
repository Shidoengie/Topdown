extends Node2D

var viewport_initial_size = Vector2()

onready var viewport = get_node("3d_viewport")
onready var viewport_sprite = get_node("3d_view")

func _ready():
	#warning-ignore:return_value_discarded
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	viewport_initial_size = viewport.size

func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	viewport.size = Vector2.ONE * get_viewport().size.y
	viewport_sprite.scale = Vector2(1, -1) * viewport_initial_size.y / get_viewport().size.y
