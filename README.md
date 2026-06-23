# `smart-source` for fish shell
Use this function instead of `source` to detect _valid_ shebangs, and be asked if you want to follow them or stay in fish.
<br/>

## Install
Download `smart-source.fish` and put it inside `~/.config/fish/functions/`.
<br/>

## Examples
```bash
#!/usr/bin/env bash
[ -n "$FISH_VERSION" ] && echo "SCRIPT RUN BY FISH $FISH_VERSION"
[ -n "$BASH_VERSION" ] && echo "SCRIPT RUN BY BASH $BASH_VERSION"
# with `source file` ✅ -- with `bash file` ✅
```
* with `smart-source file` &nbsp; ❱ &nbsp; "Use bash? (y/n)" &nbsp; ❱ &nbsp; runs both ways

-----

```bash
#!/usr/bin/env bash
echo "SCRIPT RUN BY $(ps -p $$ -o comm=)"
# with `source file` ❌ -- with `bash file` ✅
```
* with `smart-source file` &nbsp; ❱ &nbsp; "Use bash? (y/n)"&nbsp; ❱ &nbsp; `n` crashes -- `y` works

-----

```bash
#!/usr/bin/env BAD-SHEBANG
# with `source file` depends on the script
# with  `bash file`  depends on the script
```
* with `smart-source file` &nbsp; ❱ &nbsp; "Invalid shebang, using fish" &nbsp; ❱ &nbsp; performs `source file`
