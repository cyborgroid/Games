#!/usr/bin/env bash
# メンヘラカノジョ -脱出ゲーム 실행 (Waydroid, X11에서는 weston 창 안에 띄움)
PKG=air.jp.globalgear.menhera
SOCK=wayland-waydroid
RUN="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

if [ ! -S "$RUN/$SOCK" ]; then
  weston --socket=$SOCK --width=540 --height=960 >/dev/null 2>&1 &
  for _ in $(seq 20); do [ -S "$RUN/$SOCK" ] && break; sleep 0.5; done
fi

export WAYLAND_DISPLAY=$SOCK XDG_SESSION_TYPE=wayland
if ! waydroid status | grep -q "Session:.*RUNNING"; then
  waydroid show-full-ui >/dev/null 2>&1 &
  for _ in $(seq 60); do waydroid status | grep -q "Session:.*RUNNING" && break; sleep 2; done
  sleep 5
fi

waydroid app launch $PKG
