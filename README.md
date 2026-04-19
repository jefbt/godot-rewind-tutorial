# Godot Rewind Tutorial

A Godot 4.6 project demonstrating a rewind mechanic, as shown in the Tomazella Games tutorial.

## Requirements

- **Godot Engine 4.6** or later (the .NET version is not required)
- This project uses the **GL Compatibility** renderer

## Installation

1. Download and install Godot 4.6 from [godotengine.org](https://godotengine.org)
2. Clone or download this repository
3. Open Godot and import the project:
   - Click "Import" in the project manager
   - Navigate to the `godot-rewind-tutorial` folder
   - Click "Import & Edit"
4. Press F5 (or click the Run button) to start the project

## Controls

| Action | Key |
|--------|-----|
| Move Left | Arrow Left or A |
| Move Right | Arrow Right or D |
| Jump | Space or Arrow Up or W |
| Rewind | Shift (hold) |

The rewind system records the last 300 frames of gameplay. Hold Shift to rewind time and replay your previous actions.

## Features

The project includes two rewind modes that can be toggled in the GameManager node:

1. **Simple Rewind**: Hold Shift to play backward through recorded frames
2. **Complex Rewind**: Press Shift to enter rewind mode, then use left/right to scrub through history and see "echo" sprites of your past positions

## Project Structure

```
godot-rewind-tutorial/
├── assets/          # Images and sprites
├── levels/           # Level scenes
├── player/           # Player scene and script
├── scenes/          # Shared scenes (player_frame, waterfall, coin)
├── scripts/         # Game scripts (game_manager.gd, level.gd)
├── project.godot   # Project configuration
└── LICENSE         # MIT License
```

## License

MIT License - Copyright (c) 2026 Jeferson Tomazella

### What You Can Do

- Use this code for personal and commercial projects
- Modify and adapt the code for your own games
- Share and distribute the code
- Use the code in private or commercial products

### What You Can't Do

- Claim this code as entirely your own work (provide attribution when using)
- Hold the author liable for any issues with the code

For full license terms, see the LICENSE file.


## Third Party

- The graphic assets used are from [o_lobster](https://o-lobster.itch.io/)
- You can find the link to the assets pack [here](https://o-lobster.itch.io/platformmetroidvania-pixel-art-asset-pack)