<div align="center">
<img width=25% src="https://github.com/Davvex87/roblox-hx/blob/main/github-resources/roblox-hx-logo-512x512.png?raw=true">

# Roblox-HX
</div>



[![Haxe](https://img.shields.io/badge/Haxe-4.3+-orange.svg)](https://haxe.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0--beta.1-green.svg)](haxelib.json)

A powerful Haxe toolchain that enables Roblox game developers to write their games using the Haxe programming language and compile them to Lua for use in Roblox Studio. Leveraging Haxe's built-in Lua transpiler, roblox-hx provides 100% language feature coverage with type safety and modern development tooling.

## ✨ Features

- **Full Haxe Language Support**: Utilizes reflaxe.lua for the most complete and efficient lua output possible
- **Type Safety**: Catch errors at compile-time with Haxe's powerful type system
- **Rich API Coverage**: Comprehensive externs for Roblox services and data types
- **Project Templates**: Quick-start templates for different project types
- **Rojo Integration**: Seamless integration with Rojo project management
- **Macro Compatible**: Leverage the power of Haxe macros for task automation and compile-time type manipulation
- **Cross-Platform**: Works on Windows, macOS, and Linux

## 🚀 Quick Start

### Prerequisites

- [Haxe 4.3+](https://haxe.org/download/)
- [Neko VM](https://nekovm.org/download/) (included with Haxe by default)

### Installation

```shell
haxelib --global install roblox-hx
haxelib --global run roblox-hx setup
roblox-hx version
```

### Creating Your First Project

```shell
roblox-hx create
```

Note, you must run the create command inside an empty folder or pass the path of an empty folder as the first argument.
You can bypass this restriction by providing the flag ``-f``.

### Building

```shell
roblox-hx compile
```

## 📚 Available Commands

| Command | Description |
|---------|-------------|
| `roblox-hx create [path]` | Create a new project with templates |
| `roblox-hx compile` | Build Haxe source to Lua |
| `roblox-hx clean` | Remove build leftovers |
| `roblox-hx setup` | Append library to binaries for quick access |
| `roblox-hx version` | Display version information |
| `roblox-hx help` | Show available commands |

## 🎯 API Coverage

Roblox-HX provides comprehensive externs for Roblox's entire API. Due to certain limitations with Haxe's static typing system, some API has been truncated behind Dynamic types, use type casting or wrappers to get around.
All Lua and Roblox's globals get automatically imported into your Haxe code so you dont have to worry about complex imports.

## 📖 Example Usage

### Basic Client Script

```haxe
// src/client/Client.hx
package client;

import rblx.instances.Part;

class Client
{
    @:topLevelCall
    public static function main()
    {
        var player = Services.players.localPlayer;
        trace("Hello, " + player.name + "!");

        // Create a part
        var part:Part = new Part();
        part.position = new Vector3(0, 10, 0);
        part.brickColor = BrickColor.red();
        part.parent = workspace;
    }
}

```

### Server Script with Events

```haxe
// src/server/Server.hx
package server;

import rblx.instances.Tool;
import rblx.instances.Player;

class Server
{
    @:topLevelCall
    public static function main()
    {
        Services.players.playerAdded.connect(Server.onPlayerAdded);
    }

    private static function onPlayerAdded(player:Player):Void
    {
        trace("Player joined: " + player.name);

        // Give player a starting tool
        var tool:Tool = new Tool();
        tool.name = "Sword";
        tool.parent = player.findFirstChildWhichIsA("Backpack");
    }
}

```

### Shared Data Class

```haxe
// src/shared/Data.hx
package shared;

class GameConfig
{
    public static final MAX_PLAYERS = 20;
    public static final SPAWN_POSITION = new Vector3(0, 5, 0);
    public static final GAME_DURATION = 300; // seconds
    
    public static function getWelcomeMessage():String
    {
        return "Welcome to the game!";
    }
}
```

## 🗺️ Roadmap

Check out our roadmap to see what's coming next:

- [x] Service wrapper
- [ ] Dynamic types from string (mostly for the first argument of findFirstChildWhichIsA)
- [ ] Utility wrappers
- [ ] Better Luau externs support
- [ ] Rich library support
- [ ] Built-in project management tool
- [ ] Comprehensive documentation wiki (gh-pages)

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Submit a pull request with a clear description

## 🏗️ Building from Source

If you want to contribute or modify roblox-hx:

```shell
# Clone with submodules and setup haxelib dev environment
git clone https://github.com/Davvex87/roblox-hx.git --recurse-submodules
cd ./roblox-hx
haxelib --global dev roblox-hx .

# Install dependencies
haxelib --global install hmm
hmm install

# Build the neko executable
haxe ./build.hxml

# Generate API externs (if needed)
cd api-generator
haxe ./build.hxml
neko ./run.n
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- The [Haxe Foundation](https://haxe.org/) for the amazing Haxe language
- The [roblox-ts project](https://roblox-ts.com/) for being the main inspiration
- The [reflaxe team](https://github.com/SomeRanDev/Reflaxe) for providing the tools that made a custom Lua generator possible

## 📞 Support

- 📖 [Wiki](#) (Coming soon)
- 🐛 [Issues](https://github.com/Davvex87/roblox-hx/issues) - Report bugs and request features
- 💬 [Discussions](#) - (Coming soon)