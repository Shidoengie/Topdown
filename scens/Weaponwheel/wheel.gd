extends Control

var wheel_index = 0
var wps_on_wheel = 1
var total_weapons = 10
var page_total 
var pagecount = 0
var cur_page = 1
var selected
onready var wheel_cells =  [$wheelcel0,$wheelcel1,$wheelcel2,$wheelcel3,$wheelcel4,$wheelcel5,$wheelcel6,$wheelcel7]
#read player weapons
#determine pagecount
#wheel input
func _ready():
	update_wheel(7,100)
	page_total = total_weapons
func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			return
		if event.button_index == BUTTON_WHEEL_UP:
			wheel_index += 1
			if wheel_index > wps_on_wheel:
				wheel_index = 0
				if pagecount > 0:
					page_up()
			selected = wheel_cells[wheel_index]
			selected.pressed = true
			check_pressed()
		elif event.button_index == BUTTON_WHEEL_DOWN:
			wheel_index -= 1
			if wheel_index < 0:
				wheel_index = wps_on_wheel
				if pagecount > 0:
					page_down()
			selected = wheel_cells[wheel_index]
			selected.pressed = true
			check_pressed()
func update_wheel(value,total:float):
	total_weapons = total
	pagecount = ceil(total / wheel_cells.size())
	wps_on_wheel = value
	for i in wheel_cells:
		i.disabled = false
	update_page_label()
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
	if page_total - 7 > 0:
		print("a")
		page_total -= 7
		update_wheel(7,total_weapons)
	else:
		update_wheel(page_total,total_weapons)
	cur_page += 1
	if cur_page > pagecount:
		cur_page = 1
		page_total = total_weapons
	print(page_total)
	print(total_weapons)
	update_page_label()
func page_down():
	if page_total < 7:
		page_total += page_total
		update_wheel(page_total,total_weapons)
	else:
		update_wheel(page_total,total_weapons)
	cur_page -= 1
	if cur_page <= 0:
		cur_page = pagecount
	
	page_total = total_weapons - wheel_cells.size()*cur_page
	print(page_total)
	update_page_label()
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
