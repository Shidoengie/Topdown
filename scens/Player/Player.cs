namespace TopDownGame;

public class Player : KinematicBody2D
{
    [Export] protected readonly NodePath NodePathAnimationPlayerLegAnim;
    [Export] protected readonly NodePath NodePathAnimationPlayerBodyAnim;
    [Export] protected readonly NodePath NodePathTimerReload;
    [Export] protected readonly NodePath NodePathRayCast2DWeaponCurRange;

    private AnimationPlayer _animationPlayerLegAnim;
    private AnimationPlayer _animationPlayerBodyAnim;
    private Timer _timerReload;
    private RayCast2D _rayCast2DWeaponCurRange;

    [Export] public int WalkSpeed = 100;
    [Export] public int RunSpeed = 150;
    [Export] public int Health = 100;

    private Vector2 _velocity;

    public override void _Ready()
    {
        _animationPlayerLegAnim = GetNode<AnimationPlayer>(NodePathAnimationPlayerLegAnim);
        _animationPlayerBodyAnim = GetNode<AnimationPlayer>(NodePathAnimationPlayerBodyAnim);
        _timerReload = GetNode<Timer>(NodePathTimerReload);
        _rayCast2DWeaponCurRange = GetNode<RayCast2D>(NodePathRayCast2DWeaponCurRange);
    }

    public override void _PhysicsProcess(float delta)
    {
        Stats.PlayerHealth = Health;
        var inputVec = Input.GetVector("left", "right", "up", "down");
        var endSpeed = 0;

        if (inputVec == Vector2.Zero) 
        {
            _animationPlayerLegAnim.Play("RESET");
        }
        else if (Input.IsActionPressed("Run"))
        {
            endSpeed = RunSpeed;
            _animationPlayerLegAnim.Play("run");
        }
        else 
        {
            endSpeed = WalkSpeed;
            _animationPlayerLegAnim.Play("walk");
        }

        _velocity = inputVec;
        LookAt(GetGlobalMousePosition());

        _velocity = MoveAndSlide(_velocity * endSpeed, Vector2.Zero);

        if (Health < 0)
            GetTree().Quit();
    }

    private void Weapons()
    {
        //_weaponCurRange.CastTo.x = Weapon.CurRange;
        _timerReload.WaitTime = Weapon.CurReload;

        var collider = _rayCast2DWeaponCurRange.GetCollider();
        var not_null_or_tilemap = !(collider is TileMap) && _rayCast2DWeaponCurRange.IsColliding();

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
                
                if (not_null_or_tilemap)
                {
                    //collider.health -= Weapon.current_dmg
                    //collider.current_state = 2
                }
                MeleeAnimation();
                break;
        }
    }

    private void MeleeAnimation()
    {
        switch (Weapon.Cur)
        {
            case WeaponType.Fists:
                _animationPlayerBodyAnim.Play("punch");
                break;
        }
    }

    private void _on_Reload_timeout()
    {
        //Weapon.current_ammo
    }
}
