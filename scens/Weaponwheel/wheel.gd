extends Control

var wheel_index = 0
var wps_on_wheel = 7
var page
var selected
onready var wheel_cells =  [$wheelcel0,$wheelcel1,$wheelcel2,$wheelcel3,$wheelcel4,$wheelcel5,$wheelcel6,$wheelcel7]
#read player weapons
#determine pagecount
#wheel input

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			if event.button_index == BUTTON_WHEEL_UP:
				wheel_index += 1
				if wheel_index > wps_on_wheel:
					wheel_index = 0
				selected = wheel_cells[wheel_index]
				selected.pressed = true
				check_pressed()
			if event.button_index == BUTTON_WHEEL_DOWN:
				wheel_index -= 1
				if wheel_index < 0:
					wheel_index = wps_on_wheel
				selected = wheel_cells[wheel_index]
				selected.pressed = true
				check_pressed()

func update_wheel():
	for i in get_children():
		pass
func check_pressed():
	var smth = wheel_cells.duplicate()
	smth.remove(wheel_index)
	for i in smth:
		i.pressed = false
