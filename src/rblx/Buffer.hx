package rblx;

@:native("buffer")
extern class Buffer
{
	static function create(size:Int):Buffer;
	static function fromstring(str:String):Buffer;

	static function tostring(b:Buffer):String;
	static function len(b:Buffer):Int;
	static function readbits(b:Buffer, bitOffset:Int, bitCount:Int):Int;
	static function readi8(b:Buffer, offset:Int):Int;
	static function readu8(b:Buffer, offset:Int):UInt;
	static function readi16(b:Buffer, offset:Int):Int;
	static function readu16(b:Buffer, offset:Int):UInt;
	static function readi32(b:Buffer, offset:Int):Int;
	static function readu32(b:Buffer, offset:Int):UInt;
	static function readf32(b:Buffer, offset:Int):Float;
	static function readf64(b:Buffer, offset:Int):Float;
	static function writebits(b:Buffer, bitOffset:Int, bitCount:Int, value:Int):Void;
	static function writei8(b:Buffer, offset:Int, value:Int):Void;
	static function writeu8(b:Buffer, offset:Int, value:UInt):Void;
	static function writei16(b:Buffer, offset:Int, value:Int):Void;
	static function writeu16(b:Buffer, offset:Int, value:UInt):Void;
	static function writei32(b:Buffer, offset:Int, value:Int):Void;
	static function writeu32(b:Buffer, offset:Int, value:UInt):Void;
	static function writef32(b:Buffer, offset:Int, value:Float):Void;
	static function writef64(b:Buffer, offset:Int, value:Float):Void;
	static function readstring(b:Buffer, offset:Int, count:Int):String;
	static function writestring(b:Buffer, offset:Int, value:String, ?count:Int):Void;
	static function copy(target:Buffer, targetOffset:Int, source:Buffer, ?sourceOffset:Int, ?count:Int):Void;
	static function fill(b:Buffer, offset:Int, value:Int, ?count:Int):Void;
}
