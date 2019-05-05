%packages

gnome-tweak-tool
gnome-shell-extension-dash-to-dock

%end


%post --nochroot --erroronfail

# Copy wallpaper over
mkdir -p $INSTALL_ROOT/usr/local/share/backgrounds
cp resources/wallpaper.png $INSTALL_ROOT/usr/local/share/backgrounds/wallpaper.png

%end


%post  --erroronfail

## Add nautilus/file bookmarks
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/bookmarks <<EOF
file:/// /
EOF

## Application favorites
# https://help.gnome.org/admin/system-admin-guide/stable/desktop-favorite-applications.html.en
cat > /etc/dconf/db/local.d/00-favorite-apps <<FOE
[org/gnome/shell]
favorite-apps = ['gedit.desktop', 'gnome-terminal.desktop', 'firefox.desktop', 'nautilus.desktop']
FOE
#dconf update # not needed?
# Alternatively, put in /etc/skel/.config/dconf/user


## Extensions
# https://help.gnome.org/admin/system-admin-guide/stable/extensions-enable.html.en
cat > /etc/dconf/db/local.d/00-extensions <<FOE
[org/gnome/shell]
enabled-extensions=['places-menu@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com']
FOE

## CAPS LOCK -> ESC key mapping
cat > /etc/dconf/db/local.d/00-keymaps <<FOE
[org/gnome/desktop/input-sources]
xkb-options=['caps:escape']
FOE

## Set wallpaper
# https://help.gnome.org/admin/system-admin-guide/stable/desktop-background.html.en
cat > /etc/dconf/db/local.d/00-wallpaper <<FOE
[org/gnome/desktop/background]
picture-uri='file:///usr/local/share/backgrounds/wallpaper.png'
picture-options='stretched'
primary-color='000000'
secondary-color='333333'
FOE



cat > /etc/dconf/db/local.d/00-custom <<FOE
## Gnome terminal disable menu by default
[org/gnome/terminal/legacy]
default-show-menubar=false

## Gnome screensaver image
[org/gnome/desktop/screensaver]
picture-uri='file:///usr/local/share/backgrounds/wallpaper.png'

## World Clocks
[org/gnome/clocks/world-clocks]
world-clocks=[{'location': <(uint32 2, <('San Francisco', 'KOAK', true, [(0.65832848982162007, -2.133408063190589)], [(0.659296885757089, -2.1366218601153339)])>)>}, {'location': <(uint32 2, <('Houston', 'KHOU', true, [(0.51727195705981943, -1.6629933445314968)], [(0.51946730200614799, -1.6644030644216252)])>)>}, {'location': <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>}, {'location': <(uint32 2, <('London', 'EGWU', true, [(0.89971722940307675, -0.007272211034407213)], [(0.89884456477707964, -0.0020362232784242244)])>)>}, {'location': <(uint32 2, <('Moscow', 'UUWW', true, [(0.97127572873484425, 0.65042604039431762)], [(0.97305983920281813, 0.65651530216830811)])>)>}, {'location': <(uint32 2, <('Hong Kong', 'VHHH', true, [(0.38979019379430269, 1.9928751117510946)], [(0.38949931722116538, 1.9928751117510946)])>)>}, {'location': <(uint32 2, <('Sydney', 'YSSY', true, [(-0.59253928105207498, 2.6386469349889961)], [(-0.59137572239964786, 2.6392287230418559)])>)>}]

## Nautilus file icon sizes
[org/gnome/nautilus/icon-view]
default-zoom-level='small'
captions=['size', 'none', 'none']

[org/gnome/nautilus/list-view]
default-zoom-level='small'
use-tree-view=true

[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'

## Show hidden files
[org/gnome/nautilus/preferences]
show-hidden-files=true
executable-text-activation='ask'

[org/gnome/desktop/interface]
clock-format='12h'
clock-show-weekday=true

[org/gnome/desktop/wm/preferences]
action-middle-click-titlebar='minimize'

#[org/gnome/login-screen]
#151x48
#Originals /usr/share/pixmaps/fedora-gdm-logo.png
#logo='/usr/local/share/background/wallpaper.png'
FOE

dconf update
%end
