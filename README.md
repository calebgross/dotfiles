# ❤️ `~/.*`

Ensuring that Bash uses vi mode wherever I go.

## Description

I use multiple workstations, virtual machines, remote servers, etc. and like for them all to have the same feel. I finally started this repo after I'd repeatedly:
- SSH into a VPS and hit the Escape key expecting Readline to put me in vi's normal mode, as on my laptop—but nothing would happen
- Start editing a file with vim on a remote server, but none of my shortcuts would work, breaking my workflow

### Features

- All of the various Bash config files (e.g., `.bash_profile`, `.bashrc`, etc.) redirect to `.bashrc`, which in turn sources:
  - Scripts in `.bashrc.d/`, which breaks out aliases, functions, etc. into categorically named files
  - A single `.bashrc.extra` file containing machine-specific items that I don't want to publicize or track in version control
- Potentially conflicting OS-specific commands, configurations, etc. are broken out with Bash `case` statements
- A linking script, `link.sh`, symbolically links config files throughout their standard locations, making new installs easy
- Remote terminal windows have a different prompt style than local ones
- Does not include a `.gitconfig` file, so [this](https://twitter.com/TomNomNom/status/1223702654267904000) doesn't happen to you
- No support for Windows
- and much, _much_ more!

### Built with

| Utility            | Agnostic | macOS     | Linux    |
| ---                | :---:    | :---:     | :---:    |
| Browser            | Chrome   |           |          |
| Shell              | Bash     |           |          |
| Spreadsheet Editor | SC-IM    |           |          |
| Status Bar         |          | Übersicht | i3blocks |
| Terminal Emulator  |          | kitty     | urxvt    |
| Text Editor        | Vim      |           |          |
| Window Manager     |          | yabai     | i3       |

## Getting started

### Install

```
git -C "$HOME" clone https://github.com/noperator/dotfiles.git && cd "$HOME/dotfiles"
./link.sh
```

### Configure

See my related [guides](https://github.com/noperator/guides) for manual tasks and configurations that aren't automatically covered by this dotfiles repo.
