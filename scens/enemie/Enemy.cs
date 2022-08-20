namespace TopDownGame;

public class Enemy : KinematicBody2D
{
    //onready var player = get_parent().get_parent().find_node("Player") as KinematicBody2D
    [Export] public int Health = 200;

    private Vector2 _velocity;
    private EnemyState _curState = EnemyState.Search;
    private bool _seeingPlayer;
    private bool _hasBeenHit;

    public override void _Process(float delta)
    {
        if (Health < 1)
            QueueFree();

        switch (_curState)
        {
            case EnemyState.Search:
                break;
            case EnemyState.Hunt:
                /*var ray_arr = [$RayCast2D.get_collider(),$RayCast2D2.get_collider(),$RayCast2D3.get_collider()]
                if !(player in ray_arr):
                    seeing_player = false
                else:
                    seeing_player = true
                if seeing_player or been_hit: 
                    look_at(player.global_position)
                    been_hit = false*/
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
            //$Timer.stop()
            _seeingPlayer = true;
        }
    }

    private void _on_Area2D_body_exited(Node body)
    {
        if (body.Name == "Player")
        {
            //$Timer.start()
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