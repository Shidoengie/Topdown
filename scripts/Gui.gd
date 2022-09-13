extends CanvasLayer
#
onready var player = get_parent().find_node("Player")
onready var current_weapon = player.current_weapon as Weapon
onready var ammo_text = $Weapon_panel/Ammo
onready var pistol_text = $Weapon_panel/Pistol_text
onready var punch_text = $Weapon_panel/Punch_text

func _process(delta):
	$Money_label.text = str(player.money)
	$Staminabar.value = player.stamina
	if current_weapon.uses_ammo:
		ammo_text.text = str(current_weapon.ammo) + "\n" + str(current_weapon.clip)
	else:
		ammo_text.hide()
	match current_weapon.model_name:
		"AUTO_PISTOL":
			pistol_text.show()
			punch_text.hide()
		"PISTOL":
			pistol_text.show()
			punch_text.hide()
		"FISTS":
			pistol_text.hide()
			punch_text.show()
	
	if player.health <= 0:
		$Game_Over.visible = true

func update_health(value):
	$HpBar.value = value

func _update_map():
	pass

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("console"):
			$Console.visible = not $Console.visible
		if event.is_action_pressed("Wp_wheel"):
			$Wp_wheel.show()
			
		if event.is_action_released("Wp_wheel"):
			$Wp_wheel.hide()
func _on_TextEdit_text_entered(new_text):
	match new_text:
		"weapons":
			player.inventory_dict = GlobalInven.weapon_dict.duplicate()
			
	$Console.hide()
