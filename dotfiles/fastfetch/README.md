# Fastfetch (ASCII only)

A minimal fastfetch setup with rotating ASCII logos. Image themes, image
detection, and the interactive theme selector have been removed.

## Usage

- `ff` or `fastfetch` — print system info with a different ASCII art each time.

Both aliases point to `launch.sh`, which cycles sequentially through every
`*.txt` file in `themes/ascii/`. The current art is remembered in
`.ascii_current` so the next launch picks the following one. Arguments are
forwarded to fastfetch.

## ASCII arts

The arts live in `themes/ascii/`: the original `asciiart.txt` … `asciiart14.txt`
plus four new ones in two styles:

- `nixos-classic.txt`, `sh4dow-classic.txt` — classic ASCII lettering
- `nixos-block.txt`, `sh4dow-block.txt` — blocky Unicode (░█▀▄) lettering

Add, remove, or edit them freely — the launcher picks them up automatically in
version-sorted order. Filenames must not contain spaces.
