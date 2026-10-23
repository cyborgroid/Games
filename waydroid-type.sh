#!/usr/bin/env bash
# PC 터미널에서 입력한 글자를 Waydroid의 현재 입력칸으로 보냄 (클립보드 대체)
# 사용: bash waydroid-type.sh   → 입력(화면에 안 보임) 후 Enter
IP=$(waydroid status | awk '/IP address/{print $3}')
[ -z "$IP" ] || [ "$IP" = UNKNOWN ] && { echo "Waydroid가 실행 중이 아니에요."; exit 1; }
adb connect "$IP:5555" >/dev/null 2>&1

read -rsp "보낼 내용(화면에 안 보임): " TEXT; echo
# adb input text용 이스케이프: 공백은 %s, 셸 특수문자는 백슬래시
ESC=$(printf '%s' "$TEXT" | sed -e 's/[\\"'"'"'`$&|;<>()*~#?!{}^[]/\\&/g' -e 's/]/\\]/g' -e 's/ /%s/g')
adb -s "$IP:5555" shell input text "$ESC" && echo "보냈어요."
