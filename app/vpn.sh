VPNUI_WM_CLASS="com.cisco.secureclient.gui"
VPNUI_WM_NAME="Cisco Secure Client"
VPNUI_WM_DIALOG_CLASS="Cisco Secure Client"
VPNUI_WM_DIALOG_NAME="Cisco Secure Client - Login"

# Load secrets.
SERVER_NAME=$(cat /run/secrets/server-name)
USERNAME=$(cat /run/secrets/username)
PASSWORD=$(cat /run/secrets/password)

# DART requires the Desktop folder.
mkdir -p $HOME/Desktop

echo "INFO: Launching $VPNUI_WM_NAME..."
/opt/cisco/secureclient/bin/vpnui &
VPNUI_PID=$!

# TODO: Wait for ready to connect.
sleep 10

echo "INFO: Entering the server name..."
xdotool search --sync --onlyvisible --name "$VPNUI_WM_NAME" \
        windowactivate --sync \
        type "https://$SERVER_NAME"
xdotool key Return

echo "INFO: Entering the username..."
xdotool search --sync --onlyvisible --name "$VPNI_DIALOG_WM_NAME"  \
        windowactivate --sync \
        type "$USERNAME"
xdotool key Return

echo "INFO: Entering the password..."
xdotool search --sync --onlyvisible --name "$VPNI_DIALOG_WM_NAME" \
        windowactivate --sync \
        type "$PASSWORD"
xdotool key Return

wait $VPNUI_PID
