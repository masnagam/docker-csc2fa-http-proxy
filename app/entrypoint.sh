echo "INFO: Create /dev/net/tun"
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

# See https://stackoverflow.com/questions/55429622
echo "INFO: Unmount /etc/resolv.conf"
cp /etc/resolv.conf /etc/resolv.conf.bak
umount /etc/resolv.conf
cp /etc/resolv.conf.bak /etc/resolv.conf

# LocalLanAccess is enabled in order to allow accesses from outside the container.
echo "INFO: Create /opt/cisco/secureclient/vpn/.anyconnect_global"
cat <<EOF >/opt/cisco/secureclient/vpn/.anyconnect_global
<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectPreferences>
  <DefaultUser></DefaultUser>
  <DefaultSecondUser></DefaultSecondUser>
  <ClientCertificateThumbprint></ClientCertificateThumbprint>
  <MultipleClientCertificateThumbprints></MultipleClientCertificateThumbprints>
  <ServerCertificateThumbprint></ServerCertificateThumbprint>
  <DefaultHostName>$(cat /run/secrets/server-name)</DefaultHostName>
  <DefaultHostAddress>$(cat /run/secrets/server-ip):443</DefaultHostAddress>
  <DefaultGroup></DefaultGroup>
  <ProxyHost></ProxyHost>
  <ProxyPort></ProxyPort>
  <SDITokenType>none</SDITokenType>
  <ControllablePreferences>
    <LocalLanAccess>true</LocalLanAccess>
  </ControllablePreferences>
</AnyConnectPreferences>
EOF

echo "INFO: Start vpnagentd"
/opt/cisco/secureclient/bin/vpnagentd -execv_instance &

if [ -e /tmp/.X99-lock ]
then
  echo "INFO: Remove /tmp/.X99-lock"
  rm -f /tmp/.X99-lock
fi

echo "INFO: Start X11 session"
exec gosu ubuntu sh /app/x11.sh
