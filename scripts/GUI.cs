using Godot;
using System;

namespace TopDownGame;

public class GUI : CanvasLayer
{
    [Export] protected readonly NodePath NodePathLabelHP;
    [Export] protected readonly NodePath NodePathLabelWeapon;
    [Export] protected readonly NodePath NodePathLabelCurAmmo;
    [Export] protected readonly NodePath NodePathLabelClipsize;

    private Label _labelHP;
    private Label _labelWeapon;
    private Label _labelCurAmmo;
    private Label _labelClipsize;

    public override void _Ready()
    {
        _labelHP = GetNode<Label>(NodePathLabelHP);
        _labelWeapon = GetNode<Label>(NodePathLabelWeapon);
        _labelCurAmmo = GetNode<Label>(NodePathLabelCurAmmo);
        _labelClipsize = GetNode<Label>(NodePathLabelClipsize);
    }

    public override void _Process(float delta)
    {
        _labelHP.Text = "" + Stats.PlayerHealth;
	
        //$Weapon/Label3.text = Weapon.current_name
        /*if Weapon.current_type != "melee":
            $Ammo/Label3.text = str(Weapon.current_ammo[Weapon.current])
            $Ammo/Label4.text = str(Weapon.current_clipsize[Weapon.current])
        else:
            $Ammo.hide()
        if Input.is_action_just_pressed("console"):
            $Console.show()
        match $Console/TextEdit.text:
            "weapons":
                Weapon.unlocked = [Weapon.BOW,Weapon.GLOCK,Weapon.FISTS]*/
    }
}
