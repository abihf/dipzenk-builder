
#!/bin/sh

echo ------------------------------------
export
ck-list-sessions
echo ------------------------------------


/usr/bin/feh --bg-fill paw_tux_plymouth_by_shule1987.jpg &
#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
/usr/bin/lxpolkit &
/usr/bin/tint2 &
/usr/bin/nm-applet &
#xterm &
exec /usr/bin/openbox-session
