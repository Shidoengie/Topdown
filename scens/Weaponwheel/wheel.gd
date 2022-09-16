extends Control

var wheel_index = 0
var wps_on_wheel = 1
var total_weapons = 10
var page_total = 0
var pagecount = 0
var cur_page = 1
var selected
onready var wheel_cells =  [$wheelcel0,$wheelcel1,$wheelcel2,$wheelcel3,$wheelcel4,$wheelcel5,$wheelcel6,$wheelcel7]
#read player weapons
#determine pagecount
#wheel input
func _ready():
	update_wheel(7,100)
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			wheel_index += 1
			if wheel_index > wps_on_wheel:
				wheel_index = 0
			selected = wheel_cells[wheel_index]
			selected.pressed = true
			check_pressed()
		elif event.button_index == BUTTON_WHEEL_DOWN:
			wheel_index -= 1
			if wheel_index < 0:
				wheel_index = wps_on_wheel
			selected = wheel_cells[wheel_index]
			selected.pressed = true
			check_pressed()
	if event is InputEventKey:
		if Input.is_action_just_pressed("wheel_up"):
			page_up()
		elif Input.is_action_just_pressed("wheel_down"):
			page_down()
func update_wheel(value,total:float):
	total_weapons = total
	pagecount = ceil(total / wheel_cells.size())
	wps_on_wheel = value
	update_page_label()
	update_slots()

func update_slots():
	for i in wheel_cells:
		i.disabled = false
	if wps_on_wheel >= wheel_cells.size()-1: return
	for i in wheel_cells.slice(wps_on_wheel+1,wheel_cells.size()-1):
		i.disabled = true

func check_pressed():
	var smth = wheel_cells.duplicate()
	smth.remove(wheel_index)
	for i in smth:
		i.pressed = false
#placeholders
func page_up():
	print(page_total)
	page_total += wheel_cells.size()
	if page_total > total_weapons:
		wps_on_wheel = page_total-total_weapons
	else:
		wps_on_wheel = wheel_cells.size()-1
	update_slots()
	cur_page += 1
	if cur_page > pagecount:
		cur_page = 1
	update_page_label()
	
func page_down():
	page_total = abs(page_total)
	if page_total > total_weapons:
		wps_on_wheel = page_total-total_weapons
		page_total -= (page_total-total_weapons)
	else:
		page_total -= wheel_cells.size()
		wps_on_wheel = wheel_cells.size()-1
	update_slots()
	cur_page -= 1
	if cur_page < 1:
		cur_page = pagecount
	update_page_label()
	print(page_total)
func update_page_label()-> void:
	$Page_label.text = str(cur_page)+"/"+str(pagecount)
func _on_wheelcel0_pressed():
	wheel_index = 0
	check_pressed()
func _on_wheelcel1_pressed():
	wheel_index = 1
	check_pressed()
func _on_wheelcel2_pressed():
	wheel_index = 2
	check_pressed()
func _on_wheelcel3_pressed():
	wheel_index = 3
	check_pressed()
func _on_wheelcel4_pressed():
	wheel_index = 4
	check_pressed()
func _on_wheelcel5_pressed():
	wheel_index = 5
	check_pressed()
func _on_wheelcel6_pressed():
	wheel_index = 6
	check_pressed()
func _on_wheelcel7_pressed():
	wheel_index = 7
	check_pressed()
