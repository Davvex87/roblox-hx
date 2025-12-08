package utils;

class AnsiColors
{
	public static inline var RESET:String = "\x1b[0m";
	public static inline var BLACK:String = "\x1b[30m";
	public static inline var RED:String = "\x1b[31m";
	public static inline var GREEN:String = "\x1b[32m";
	public static inline var YELLOW:String = "\x1b[33m";
	public static inline var BLUE:String = "\x1b[34m";
	public static inline var MAGENTA:String = "\x1b[35m";
	public static inline var CYAN:String = "\x1b[36m";
	public static inline var WHITE:String = "\x1b[37m";

	public static inline var BOLD_BLACK:String = "\x1b[1;30m";
	public static inline var BOLD_RED:String = "\x1b[1;31m";
	public static inline var BOLD_GREEN:String = "\x1b[1;32m";
	public static inline var BOLD_YELLOW:String = "\x1b[1;33m";
	public static inline var BOLD_BLUE:String = "\x1b[1;34m";
	public static inline var BOLD_MAGENTA:String = "\x1b[1;35m";
	public static inline var BOLD_CYAN:String = "\x1b[1;36m";
	public static inline var BOLD_WHITE:String = "\x1b[1;37m";

	public static inline function black(text:String):String
		return BLACK + text + RESET;

	public static inline function red(text:String):String
		return RED + text + RESET;

	public static inline function green(text:String):String
		return GREEN + text + RESET;

	public static inline function yellow(text:String):String
		return YELLOW + text + RESET;

	public static inline function blue(text:String):String
		return BLUE + text + RESET;

	public static inline function magenta(text:String):String
		return MAGENTA + text + RESET;

	public static inline function cyan(text:String):String
		return CYAN + text + RESET;

	public static inline function white(text:String):String
		return WHITE + text + RESET;

	public static inline function boldBlack(text:String):String
		return BOLD_BLACK + text + RESET;

	public static inline function boldRed(text:String):String
		return BOLD_RED + text + RESET;

	public static inline function boldGreen(text:String):String
		return BOLD_GREEN + text + RESET;

	public static inline function boldYellow(text:String):String
		return BOLD_YELLOW + text + RESET;

	public static inline function boldBlue(text:String):String
		return BOLD_BLUE + text + RESET;

	public static inline function boldMagenta(text:String):String
		return BOLD_MAGENTA + text + RESET;

	public static inline function boldCyan(text:String):String
		return BOLD_CYAN + text + RESET;

	public static inline function boldWhite(text:String):String
		return BOLD_WHITE + text + RESET;
}
