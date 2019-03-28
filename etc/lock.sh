#!/usr/bin/env bash
tmpbg="/tmp/lock.png"
scrot "$tmpbg";
corrupter "$tmpbg" "$tmpbg";
i3lock -i "$tmpbg";
