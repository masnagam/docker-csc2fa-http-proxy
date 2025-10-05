mkdir -p $HOME/.config/openbox
cat <<EOF >$HOME/.config/openbox/autostart
(sleep 0s && sh /app/vpn.sh) &
(sleep 1s && sh /app/x11vnc.sh) &
(sleep 2s && sh /app/novnc.sh) &
(sleep 3s && sh /app/privoxy.sh) &
EOF

exec xvfb-run -s "-screen 0 1270x720x24" openbox-session
