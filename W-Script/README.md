# W-Script

Roblox exploit script with GUI — 3rd person fix, CFG system, silent aim, FOV circle, ESP, movement, exploits, and more.

## Usage

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ilia72/W-Script/main/w-script.lua?cb="..os.time()))()
```

> После обновления скрипта перезапусти loadstring в эксплоиторе! `?cb=..os.time()` в ссылке принудительно обходит кэш GitHub CDN и кэш эксплоитора — без него может запускаться старая версия.

## Keybinds

| Key | Action |
|-----|--------|
| K | Toggle main menu |
| Insert | Toggle loader menu |
| F | Fly |
| V | Noclip |
| X | Walkspeed |
| J | Infinite jump |
| E | ESP |
| R | Aimbot |
| Z | Silent aim |
| T | Click TP |
| Q | Dash |
| B | Fullbright |
| 3 | Force 3rd person |

## New Features (v3)

- **Skeleton ESP** — draws bone lines on players
- **Distance ESP** — shows distance to players (m)
- **Anti-aim** — flips camera view (customizable yaw)
- **Invisible** — makes your character invisible
- **Name + HP** — shows health % next to player name

## Folder Structure

| Key | Action |
|-----|--------|
| K | Toggle main menu |
| Insert | Toggle loader menu |
| F | Fly |
| V | Noclip |
| X | Walkspeed |
| J | Infinite jump |
| E | ESP |
| R | Aimbot |
| Z | Silent aim |
| T | Click TP |
| Q | Dash |
| B | Fullbright |
| 3 | Force 3rd person |

## Folder Structure

```
W-Script/
├── w-script.lua              (main file — load this in Roblox)
├── src/
│   ├── gui/
│   │   ├── loader.lua        (config load/save/delete menu — Insert key)
│   │   └── shell.lua         (main GUI shell — tabs, toggles, sliders)
│   ├── features/
│   │   ├── thirdperson.lua   (3rd person camera fix)
│   │   ├── silentaim.lua     (FOV circle + silent aim metatable)
│   │   └── config.lua        (save/load/export/import configs)
│   ├── core/
│   │   ├── loops.lua         (RenderStepped, Stepped, Heartbeat)
│   │   └── input.lua         (keybinds, menu toggle, dash, anti-AFK)
│   └── utils/
│       ├── theme.lua         (colors, accent system, corner, drag)
│       └── helpers.lua       (char/hum/root, resets, hardOff)
└── README.md
```

## Features

- **Movement**: fly, vehicle fly, float, walkspeed, jump power, infinite jump, bhop, spider climb
- **Exploits**: noclip, click TP, fake lag, spinbot, ghost
- **Combat**: camera aimbot, silent aim, FOV circle, hitbox expander, tool reach, fling
- **Visuals**: ESP (highlight/box/name/HP/tracers/skeleton/distance), rainbow ESP, body FX (halo/hat/trail/fire/sparks/FF), anti-aim, invisible, name+HP
- **World**: fullbright, disco sky, auto time, no fog, xray, neon world, plastic world
- **Camera**: custom FOV, 3rd person lock, camera bob, dash
- **Optimize**: potato mode, no shadows, no particles, hide decals
- **Config**: save/load configs, copy to clipboard, list configs
- **UI**: RGB UI, watermark, stats, crosshair, anti-AFK, loader menu
