namespace TopDownGame;

public class Enemy : KinematicBody2D
{
    [Export] protected readonly NodePath NodePathRayCast2D_1;
    [Export] protected readonly NodePath NodePathRayCast2D_2;
    [Export] protected readonly NodePath NodePathRayCast2D_3;
    [Export] protected readonly NodePath NodePathTimer;

    private RayCast2D _rayCast2D_1;
    private RayCast2D _rayCast2D_2;
    private RayCast2D _rayCast2D_3;
    private Godot.Timer _timer;
    private KinematicBody2D _player;
    
    [Export] public int Health = 200;

    private Vector2 _velocity;
    private EnemyState _curState = EnemyState.Search;
    private bool _seeingPlayer;
    private bool _hasBeenHit;

    public override void _Ready()
    {
        _player = GetParent().GetParent().FindNode("Player") as KinematicBody2D;
        _rayCast2D_1 = GetNode<RayCast2D>(NodePathRayCast2D_1);
        _rayCast2D_2 = GetNode<RayCast2D>(NodePathRayCast2D_2);
        _rayCast2D_3 = GetNode<RayCast2D>(NodePathRayCast2D_3);
        _timer = GetNode<Godot.Timer>(NodePathTimer);
    }

    public override void _Process(float delta)
    {
        if (Health < 1)
            QueueFree();

        switch (_curState)
        {
            case EnemyState.Search:
                break;
            case EnemyState.Hunt:
                var ray_arr = new List<object> { _rayCast2D_1.GetCollider(), _rayCast2D_2.GetCollider(), _rayCast2D_3.GetCollider() };

                //if !(player in ray_arr):
                //    seeing_player = false
                //else:
                //    seeing_player = true

                if (_seeingPlayer || _hasBeenHit)
                {
                    LookAt(_player.GlobalPosition);
                    _hasBeenHit = false;
                }
                break;
            case EnemyState.Hit:
                _hasBeenHit = true;
                _curState = EnemyState.Hunt;
                break;
        }
    }

    private void _on_Area2D_body_entered(Node body)
    {
        if (body.Name == "Player")
        {
            _curState = EnemyState.Hunt;
            _timer.Stop();
            _seeingPlayer = true;
        }
    }

    private void _on_Area2D_body_exited(Node body)
    {
        if (body.Name == "Player")
        {
            _timer.Start();
            _seeingPlayer = false;
        }
    }

    private void _on_Timer_timeout()
    {
        _curState = EnemyState.Search;
    }
}

public enum EnemyState 
{
    Search,
    Hunt,
    Hit
}