#!/bin/bash
# start_monitor.sh — Chromium Kiosk (single instance, open as app)

USER_HOME="/home/tv-senai"
URL="https://URL_DO_SEU_PROJETO"
export DISPLAY=:0
export XAUTHORITY="$USER_HOME/.Xauthority"

# Espera o X estar pronto
sleep 12

# Mata qualquer instância anterior de chromium deste usuário (garante single instance)
# usa pids do usuário tv-senai para evitar matar processos de outros usuários
pkill -u tv-senai -f chromium || true
sleep 1

# Garante diretório de perfil
mkdir -p "$USER_HOME/.config/chromium_kiosk"
chown -R tv-senai:tv-senai "$USER_HOME/.config/chromium_kiosk"

#Ajustes de Tela e cursor
unclutter -idle 0 -root & #oculta o cursor
xset s off                #desativa o protetor de tela
xset-dpms                 #desativa economia de energia
xset s noblank            #impede a tela de apagar 

# Abre Chromium como "app" (sem abas, apenas a página) — ideal para kiosk
exec /usr/bin/chromium \
  --no-first-run \
  --user-data-dir="$USER_HOME/.config/chromium_kiosk" \
  --app="$URL" \
  --kiosk \
  --start-fullscreen \
  --noerrdialogs \
  --disable-infobars \
  --disable-session-crashed-bubble \
  --disable-pinch \
  --disable-sync \
  --ignore-certificate-errors
  --disable-features-TranslateUI \
