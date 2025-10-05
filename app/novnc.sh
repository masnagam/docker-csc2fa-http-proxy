echo "INFO: Start noVNC"
exec websockify --web=/usr/share/novnc 5980 localhost:5900
