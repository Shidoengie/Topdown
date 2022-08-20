namespace TopDownGame;

public class Weapon : Node
{
    private string _jsonStr = "";
    private File _jsonFile = new File();
    private JSONParseResult _data;

    //var unlocked = []
    public static WeaponType Cur = WeaponType.Fists;

    public static string CurName = "";
    private int _curDamage;
    private int _curFirerate;
    private int _curProjectileSpeed;
    public static string CurType = "";
    public static int CurRange;
    public static int CurReload;

    /*
    #stores all weapons max clipzises and ammunition 
    var max_ammo = []
    var max_clipsize = []
    #stores current ammo and clipsize usage
    var current_ammo = []
    var current_clipsize = []
    */

    public override void _Ready()
    {
        _jsonFile.Open("res://Json/weapon.json", File.ModeFlags.ReadWrite);
        _jsonStr = _jsonFile.GetAsText();
        _data = JSON.Parse(_jsonStr);

        //for (int i = 0; i < _data.????)
        /*if i["type"] == "melee":
			continue
		max_ammo.append(i["ammo"])
		max_clipsize.append(i["clipsize"])*/

        // current_ammo = max_ammo
	    // current_clipsize = max_clipsize
    }

    public override void _Process(float delta)
    {
        /*switch (_cur) 
        {
            case WeaponType.Glock:
				var dict = data.result[0];
				_curDamage   = dict["dmg"];
				_curFirerate = dict["firerate"];
				_curType     = dict["type"];
				_curRange    = dict["range"];
				_curName     = dict["name"];
				_curReload   = dict["reload_time"];
                break;
			case WeaponType.Bow:
				var dict = data.result[1];
				_curDamage = dict["dmg"];
				_curFirerate = dict["firerate"];
				_curProjectileSpeed = dict["bolt_speed"];
				_curType = dict["type"];
				_curRange = dict["range"];
				_curName = dict["name"];
				_curReload = dict["reload_time"];
                break;
			case WeaponType.Fists:
				var dict = data.result[2];
				_curDamage = dict["dmg"];
				_curFirerate = dict["firerate"];
				_curType = dict["type"];
				_curRange = dict["range"];
				_curName = dict["name"];
                break;
			case WeaponType.Bat:
				var dict = data.result[3];
				_curDamage = dict["dmg"];
				_curFirerate = dict["firerate"];
				_curType = dict["type"];
				_curRange = dict["range"];
				_curName = dict["name"];
                break;
        }*/
    }
}

public enum WeaponType 
{
    Glock,
    Bow,
    Fists,
    Bat
}