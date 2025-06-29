package utils;

import haxe.Exception;
import hx.files.File;
import hx.files.Dir;

class Git
{
	public static function setupCommitHook()
	{
		var libPath = HaxeUtils.getLibraryDir("roblox-hx");
		if (libPath == null)
			throw new Exception("Library roblox-hx is not installed");

		Dir.of(libPath.joinAll([".git", "hooks"])).create();
		var hook = File.of(libPath.joinAll([".git", "hooks", "pre-commit"]));

		if (hook.path.exists())
			return;

		if (HaxeUtils.isWin)
		{
			hook.writeString("@echo off
setlocal enabledelayedexpansion

set FILE=extraParams.hxml
set TMP_FILE=%FILE%.tmp
set FOUND=0

if exist %FILE% (
    >\" % TMP_FILE % \" (
        for /f \"
				usebackq delims = \" %%A in (\" % FILE % \") do (
            set \" LINE = % % A \"
            if \"!LINE:~0, 3!\"==\"
				- cp \" if \"!FOUND!\"==\" 0 \" (
                echo # AUTOGEN
                set FOUND=1
            ) else (
                echo !LINE!
            )
        )
    )
    move /Y \" % TMP_FILE % \" \" % FILE % \" >nul
    git add \" % FILE % \"
)

endlocal
");
		}
		else
		{
			hook.writeString("#!/bin/bash

FILE=\"extraParams.hxml\"
TMP_FILE=\"$(mktemp)\"
CHANGED=0
FOUND=0

if [ -f \"$FILE\" ]; then
  while IFS= read -r line; do
    if [[ \"$line\" =~ ^-cp ]] && [ \"$FOUND\" -eq 0 ]; then
      echo \"# AUTOGEN\" >> \"$TMP_FILE\"
      FOUND=1
      CHANGED=1
    else
      echo \"$line\" >> \"$TMP_FILE\"
    fi
  done < \"$FILE\"

  if [ \"$CHANGED\" -eq 1 ]; then
    mv \"$TMP_FILE\" \"$FILE\"
    git add \"$FILE\"
  else
    rm \"$TMP_FILE\"
  fi
fi
");

			Sys.command("chmod +x .git/hooks/pre-commit");
		}
	}
}
