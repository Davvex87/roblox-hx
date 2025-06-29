# Roblox-HX
A tool for haxe which allows roblox game developers to program their game using the Haxe programming language and compile it to lua to be used in their games. It uses Haxe's built-in lua transpiler to ensure that 100% of Haxe's language features are covered.

> [!WARNING]  
> This tool is still in very early alpha, it is not recommended to be used in production quite yet.
> Proceed with caution!

# Setup
> [!NOTE]  
> roblox-hx requires that Neko VM is installed to be able to run the script.
> It should come pre-packaged by defaut whenever you install haxe, if not then you can find the binaries [here](https://nekovm.org/download/)

```shell
haxelib --global install roblox-hx
haxelib --global run roblox-hx setup
```
To verify that roblox-hx installed successfully, run ``roblox-hx v``. That should should print out the library version, and that also indicates that it was installed correctly.

# Quick-Start
1. Create a new basic project:<br>
  - Run ``roblox-hx create ./`` to create a new basic empty project in the current directory.

2. Start programming:<br>
  - You're basically good to go once you create your new project, now you are free to do whatever!
  - Start out by create more haxe source files, classes and other types.

3. Building:<br>
  - To build your project into lua, simply run ``roblox-hx compile``, and that will automatically build everything up for you.
  - Once finished, you can move the files into roblox studio in their respective structure and watch as your haxe code runs in roblox!

# Compiling the library from source (cross-platform)
Whenever you install roblox-hx, it comes pre-packaged with the most up-to-date neko script executable, which is the core component of the library, but if you'd like to compile it from the ground up, there's still things to do.<br>

1. Go to the library on your terminal:<br>
  - Open the terminal and set your cwd to the library path or a clone of this repository.
  - ``cd %HAXEPATH%/lib/roblox-hx/``

2. Install the dependencies
  - ``hmm install``

3. Build the neko script
  - ``haxe ./build.hxml``

# Roadmap
Check out [ROADMAP.md](/ROADMAP.md) to have a preview on what's to come into roblox-hx.

# Contributing
To contribute to roblox-hx, simply clone the ``dev`` repository, do your additions or changes and make pull requests.