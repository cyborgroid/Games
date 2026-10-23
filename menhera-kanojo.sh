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
fi

# 안드로이드 부팅이 끝날 때까지 대기 (너무 일찍 실행하면 홈 화면만 뜸)
for _ in $(seq 60); do
  IP=$(waydroid status | awk '/IP address/{print $3}')
  if [ "$IP" != "UNKNOWN" ]; then
    adb connect "$IP:5555" >/dev/null 2>&1
    [ "$(adb -s "$IP:5555" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ] && break
  fi
  sleep 2
done

waydroid app launch $PKG
