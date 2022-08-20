using Godot;
using System;

namespace TopDownGame;

public class Player : KinematicBody2D
{
    [Export] public int WalkSpeed = 100;
    [Export] public int RunSpeed = 150;
    [Export] public int Health = 100;

    private Vector2 _velocity;

    public override void _Ready()
    {
        
    }

    public override void _PhysicsProcess(float delta)
    {
        Stats.PlayerHealth = Health;
        var inputVec = Input.GetVector("left", "right", "up", "down");
        var endSpeed = 0;

        if (inputVec == Vector2.Zero) 
        {
            //$Leg_anim.play("RESET")
        }
        else if (Input.IsActionPressed("Run"))
        {
            endSpeed = RunSpeed;
            //$Leg_anim.play("run")
        }
        else 
        {
            endSpeed = WalkSpeed;
            //$Leg_anim.play("walk")
        }

        _velocity = inputVec;
        LookAt(GetGlobalMousePosition());

        _velocity = MoveAndSlide(_velocity * endSpeed, Vector2.Zero);

        if (Health < 0)
            GetTree().Quit();
    }

    private void Weapons()
    {
        // $RayCast2D.cast_to.x = Weapon.current_range
	    // $Timer.wait_time = Weapon.current_reload

        //var collider = $RayCast2D.get_collider()
        //var not_null_or_tilemap = !(collider is TileMap) and $RayCast2D.is_colliding()

        switch (Weapon.CurType)
        {
            case "manual":
                if (Input.IsActionJustPressed("Shoot"))
                {

                }
                break;
            case "auto":
                if (Input.IsActionPressed("Shoot"))
                {

                }
                break;
            case "projectile":
                if (Input.IsActionJustPressed("Shoot"))
                {

                }
                break;
            case "melee":
                if (!Input.IsActionJustPressed("Shoot"))
                    break;
                
                /*if (notnullortilemap)
                {
                    collider.health -= Weapon.current_dmg
                    collider.current_state = 2
                }*/
                MeleeAnimation();
                break;
        }
    }

    private void MeleeAnimation()
    {
        switch (Weapon.Cur)
        {
            case WeaponType.Fists:
                //$Body_anim.play("punch")
                break;
        }
    }

    /*
    func _on_Reload_timeout():
        Weapon.current_ammo
        pass # Replace with function body.
    */
}
