package lua.lib.luautf8;

import lua.Table;

@:native("utf8")
extern class Utf8
{
	/**
	 * Converts zero or more codepoints to UTF-8 byte sequences.
	 */
	static function char(codepoints:ArrayTable<Int>):String;

	/**
 	* Returns an iterator function that iterates over all codepoints in a given string.
 	*/
	static function codes(str:String):String->Int->StringCodePoint;

	/**
 	* Returns the codepoints (as integers) from all codepoints in a given string.
 	*/
	static function codepoint(str:String, i:Int, j:Int):ArrayTable<Int>;

	/**
 	* Returns the number of UTF-8 codepoints in a given string.
 	*/
	static function len(s:String, i:Int, j:Int):Int;

	/**
 	* Returns the position (in bytes) where the encoding of the n‑th codepoint of s (counting from byte position i) starts.
 	*/
	static function offset(s:String, n:Int, i:Int):Null<Int>;

	/**
 	* Returns an iterator function that iterates over the grapheme clusters of a given string.
 	*/
	static function graphemes(str:String, i:Int, j:Int):GraphemesResult<Int, Int>;

	/**
 	* Converts the input string to Normal Form C.
 	*/
	static function nfcnormalize(str:String):String;

	/**
 	* Converts the input string to Normal Form D.
 	*/
	static function nfdnormalize(str:String):String;

	public static inline function byte(str:String, ?index:Int):Int
	{
		return lua.NativeStringTools.byte(str, index);
	}


}

@:multiReturn
extern class CodesResult<K, V> {
	var next:Table<K, V>->Int->CodesResult<Int, V>;
	var table:Table<K, V>;
	var index:Int;
}

@:multiReturn
extern class GraphemesResult<K, V> {
	var next:Table<K, V>->Int->GraphemesResult<Int, V>;
	var table:Table<K, V>;
	var index:Int;
}

@:multiReturn extern class StringCodePoint {
	var position:Int;
	var codepoint:Int;
}
