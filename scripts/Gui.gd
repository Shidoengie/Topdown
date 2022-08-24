extends CanvasLayer




func _process(delta):
	var current_weapon = Weapon.current
	$HP/Label.text = str(Stats.player_health) + " HP"
	if Weapon.current_type != "melee":
		$Weapon_panel/Ammo.text = str(Weapon.current_ammo[current_weapon]) + " " + str(Weapon.current_clipsize[current_weapon])
	else:
		$Ammo.hide()
	if Input.is_action_just_pressed("console"):
		$Console.show()
	match current_weapon:
		Weapon.PISTOL:
			$Weapon_panel/Pistol_text.show()
			$Weapon_panel/Punch_text.hide()
		Weapon.FISTS:
			$Weapon_panel/Pistol_text.hide()
			$Weapon_panel/Punch_text.show()
	match $Console/TextEdit.text:
		"weapons":
			Weapon.unlocked = [Weapon.BOW,Weapon.PISTOL,Weapon.FISTS,Weapon.BAT]

