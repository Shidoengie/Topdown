extends CanvasLayer


func _process(delta):
	var current_weapon = Weapon.current
	$HpBar.value = Stats.player_health
	if Weapon.current_type != "melee":
		$Weapon_panel/Ammo.text = str(Weapon.current_ammo[current_weapon]) + "\n" + str(Weapon.current_clipsize[current_weapon])
	else:
		$Ammo.hide()
	if Input.is_action_just_pressed("console"):
		$Console.show()
	match current_weapon:
		Weapon.WEAPON_ENUM.PISTOL:
			$Weapon_panel/Pistol_text.show()
			$Weapon_panel/Punch_text.hide()
		Weapon.WEAPON_ENUM.FISTS:
			$Weapon_panel/Pistol_text.hide()
			$Weapon_panel/Punch_text.show()
	match $Console/TextEdit.text:
		"weapons":
			Weapon.unlocked = [Weapon.BOW,Weapon.PISTOL,Weapon.FISTS,Weapon.BAT]

