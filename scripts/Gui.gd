extends CanvasLayer
#
onready var player = get_parent().find_node("Player")
onready var current_weapon = player.current_weapon as Weapon

func _process(delta):
	$HpBar.value = GameManager.player_health
	if current_weapon.uses_ammo:

		$Weapon_panel/Ammo.text = str(current_weapon.ammo) + "\n" + str(current_weapon.clipsize)
	else:

		$Weapon_panel/Ammo.hide()
	if Input.is_action_just_pressed("console"):
		$Console.show()
	match current_weapon.model_name:
		"PISTOL":
			$Weapon_panel/Pistol_text.show()
			$Weapon_panel/Punch_text.hide()
		"FISTS":
			$Weapon_panel/Pistol_text.hide()
			$Weapon_panel/Punch_text.show()
	match $Console/TextEdit.text:
		"weapons":
			pass

