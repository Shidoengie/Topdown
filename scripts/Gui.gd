extends CanvasLayer




func _process(delta):
	$HP/Label.text = str(Stats.player_health)
	
	$Weapon/Label3.text = Weapon.current_name
	if Weapon.current_type != "melee":
		$Ammo/Label3.text = str(Weapon.current_ammo[Weapon.current])
		$Ammo/Label4.text = str(Weapon.current_clipsize[Weapon.current])
	else:
		$Ammo.hide()
	if Input.is_action_just_pressed("console"):
		$Console.show()
	match $Console/TextEdit.text:
		"weapons":
			Weapon.unlocked = [Weapon.BOW,Weapon.GLOCK,Weapon.FISTS,Weapon.BAT]
	
