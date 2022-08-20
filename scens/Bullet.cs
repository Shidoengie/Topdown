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

    private void _on_Bullet_body_entered(Node body)
    {
        if (body is not TileMap)
        {
            //body.health -= damage;
            //body.currentstate = 2;
            return;
        }

        QueueFree();
    }
}
