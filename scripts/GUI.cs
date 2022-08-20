namespace TopDownGame;

public class GUI : CanvasLayer
{
    [Export] protected readonly NodePath NodePathLabelHP;
    [Export] protected readonly NodePath NodePathLabelWeapon;
    [Export] protected readonly NodePath NodePathLabelCurAmmo;
    [Export] protected readonly NodePath NodePathLabelClipsize;
    [Export] protected readonly NodePath NodePathPanelAmmo;
    [Export] protected readonly NodePath NodePathPopupDialogConsole;
    [Export] protected readonly NodePath NodePathTextEditConsole;

    private Label _labelHP;
    private Label _labelWeapon;
    private Label _labelCurAmmo;
    private Label _labelClipsize;

    private Control _panelAmmo;
    private PopupDialog _popupDialogConsole;
    private TextEdit _textEditConsole;

    public override void _Ready()
    {
        _labelHP = GetNode<Label>(NodePathLabelHP);
        _labelWeapon = GetNode<Label>(NodePathLabelWeapon);
        _labelCurAmmo = GetNode<Label>(NodePathLabelCurAmmo);
        _labelClipsize = GetNode<Label>(NodePathLabelClipsize);
        _panelAmmo = GetNode<Control>(NodePathPanelAmmo);
        _popupDialogConsole = GetNode<PopupDialog>(NodePathPopupDialogConsole);
        _textEditConsole = GetNode<TextEdit>(NodePathTextEditConsole);
    }

    public override void _Process(float delta)
    {
        _labelHP.Text = "" + Stats.PlayerHealth;
	
        _labelWeapon.Text = Weapon.CurName;
        
        if (Weapon.CurType != "melee")
        {
            //_labelCurAmmo.Text = "" + Weapon.curAmmo;
            //_labelCurClipSize.Text = "" + Weapon.curclipsize;
        }
        else
        {
            _panelAmmo.Hide();
        }

        if (Input.IsActionJustPressed("console"))
        {
            _popupDialogConsole.Show();
        }

        switch (_textEditConsole.Text) 
        {
            case "weapons":
                // Weapon.unlocked = [Weapon.BOW,Weapon.GLOCK,Weapon.FISTS];
                break;
        }
    }
}
