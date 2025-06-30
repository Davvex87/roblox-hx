package utils;

import haxe.Exception;
import hx.files.File;
import hx.files.Dir;

using StringTools;

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

		hook.writeString("#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z \"$REPO_ROOT\" ]; then
    echo \"Error: Not in a Git repository.\"
    exit 1
fi

FILE=\"$REPO_ROOT/extraParams.hxml\"
TMP_FILE=$(mktemp)
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
fi");

		if (!HaxeUtils.isWin)
			Sys.command("chmod +x .git/hooks/pre-commit");
	}
}
