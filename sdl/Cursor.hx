package sdl;

private typedef CursorPtr = hl.Abstract<"sdl_cursor">;

enum abstract CursorKind(Int) {
    var Arrow = 0;
    var IBeam = 1;
    var Wait = 2;
    var CrossHair = 3;
    var WaitArrow = 4;
    var SizeNWSE = 5;
    var SizeNESW = 6;
    var SizeWE = 7;
    var SizeNS = 8;
    var SizeALL = 9;
    var No = 10;
    var Hand = 11;
}

abstract Cursor(CursorPtr) {

	public static function create( surface : Surface, hotX : Int, hotY : Int ) : Cursor {
		return null;
	}

	public static function createSystem( kind : CursorKind ) : Cursor {
		return null;
	}

	public function free() {
	}

	public function set() {
	}

	public static function show( v : Bool ) {
	}

	public static function isVisible() : Bool {
		return false;
	}

}
