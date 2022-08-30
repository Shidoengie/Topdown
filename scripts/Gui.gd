extends CanvasLayer
#
onready var player = get_parent().find_node("Player")
onready var current_weapon = player.current_weapon as Weapon

func _process(delta):
	$HpBar.value = GameManager.player_health
	if current_weapon.uses_ammo:

		$Weapon_panel/Ammo.text = str(current_weapon.ammo) + "\n" + str(current_weapon.clip)
	else:

		$Weapon_panel/Ammo.hide()
	match current_weapon.model_name:
		"PISTOL":
			$Weapon_panel/Pistol_text.show()
			$Weapon_panel/Punch_text.hide()
		"FISTS":
			$Weapon_panel/Pistol_text.hide()
			$Weapon_panel/Punch_text.show()


func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("console"):
			$Console.visible = not $Console.visible
func _on_TextEdit_text_entered(new_text):
	match new_text:
		"weapons":
			player.inventory_dict = GlobalInven.weapon_dict.duplicate()
			
	$Console.hide()
