namespace TopDownGame;

public class Bullet : Area2D
{
    [Export] public int Speed = 750;
    [Export] public int Damage = 50;

    private Vector2 _velocity;
    private Vector2 _dir;

    public override void _Ready()
    {
        _dir = Transform.x;
    }

    public override void _PhysicsProcess(float delta)
    {
        Position += _dir * Speed * delta;
    }

    /*
    var i =false 
    func _on_Bullet_body_entered(body):
        if not body is TileMap:
            body.health -= damage
            queue_free()
            body.current_state = 2
            return
        queue_free()
        */
}
