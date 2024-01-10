## Kali linux env customization
##1- Se debe hacer un update y upgrade, en modo ROOT

apt update
apt list --upgradable #(para ver los paquetes a ser actulizados)
apt upgrade

##2-Ejecutar  como root, qque tiene los paquetes necesarios para instalar bspwm y sxhdk:

apt install build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

## si existe un error unable to locate package xcb, se lo puede omitir es decir quitar

## 3- como usuario no privilegiado en descargas
cd Downloads/

## en la carpeta descargas, clonar repositorios

git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git

# Una vez clonados, se procede a hacer de forma indivifual:
# ir a la carpeta bspwm
cd bspwm
# ejecutar los siguientes comandos:
make
sudo make install

# regresar atras
cd ..

#Lo mismo para sxhdk, regresar la carpeta de descarga e ir a la carpeta sxhkd
cd sxhkd/
make
sudo make install

##########     NOTAS de Savitar    ##################
#En caso de que os salga algún error relacionado con ‘xinerama‘, podéis ejecutar este comando:
# tal vez isntalar de todos modos

sudo apt install libxinerama1 libxinerama-dev

## 4- Ahora se debe configurar el Sxhkd, para ello se debe hacer lo siguiente:
cd Downloads/
mkdir ~/.config/{bspwm,sxhkd}

## se puede verificar
ls -l ~/.config/

# se debe recordar que aun estamos en el directrorio de descargas. Por lo tanto ir a:
cd bspwm/
cd examples/
ls -l #<- identificar los archivos bspwmrc y sxhkdrc

# copiar esos archivos a los direcotrios creados en ~/.config/
cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/

# echar un vistazo a los archivos copiados
cat ~/.config/bspwm/bspwmrc
cat ~/.config/sxhkd/sxhkdrc

## hacer una instalcion de la kitty
sudo apt install kitty

# dentro del directorio nuevo en ~/.config/sxhkd/
nano sxhkdrc
###############################################################################################################
###############################################################################################################
## dentro del archivo se debe hacer las siguinetes modificaciones:
# ir a la seccion de emulador de terminal para cambiar por:
# se debe tener instalado kitty

>#terminal emulator
super + Return
	/usr/bin/kitty
	
>#focus the node in the given direction
super + {_,+ shift +}{Left,Down,Up,Right}
	bspc node -{f,s} {west,south,north,east}
	
>#preselect the direction 
super + ctrl + alt + {Left,Down,Up,Right}
	bspc node -p {west,south,north,east}
	
>#cancel the preselection for the focused node
super + ctrl + alt + space
	bspc node -p cancel

##Comentar las secciones
>#expand a window by moving one its side outward
>#contract a window by moving one its side inward

## cambiar
>#move a floating window
super + shift + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}
## Crear un nueva seccion
># Custom resize
alt + super + {Left,Down,Up,Right}
	/home/[user]/.config/bspwm/scripts/bspwm_resize {west,south,north,east}
	
## **Salir del modo de edicion

###############################################################################################################
###############################################################################################################
## teniendo en cuenta que se esta en la carpeta de descargas
mkdir /home/[user]/.config/bspwm/scripts/
touch /home/[user]/.config/bspwm/scripts/bspwm_resize

# dar permisos de ejecucion
chmod +x !$ 
# o Ejecutar
chmod +x /home/[user]/.config/bspwm/scripts/bspwm_resize

##luego editar el archivo
nano /home/[user]/.config/bspwm/scripts/bspwm_resize

## copiar el script de abajo y guardar
###################################################################################################
###### Script para custom resize #########
#!/usr/bin/env dash

if bspc query -N -n focused.floating > /dev/null; then
	step=20
else
	step=100
fi

case "$1" in
	west) dir=right; falldir=left; x="-$step"; y=0;;
	east) dir=right; falldir=left; x="$step"; y=0;;
	north) dir=top; falldir=bottom; x=0; y="-$step";;
	south) dir=top; falldir=bottom; x=0; y="$step";;
esac

bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"
############################################################################################################
#PUEDE QUE HAY UN ERROR DE insecure files, compaudit, al hacer sudo su
compaudit # devuelve un directorio
ls -l [dir] # copiar el directorio
chown root:root [dir]
exit

## volver a intentar entrar en modo root
sudo su # no hay problema
#############################################################################################################

## 5- instalando Polybar, se tinene dos formas en caso de que el primer metodo falle
## metodo 1 - estar en mnodo root y ejecutar este comando
apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev

# hay un comando que puede dar problemas y es python3-sphinx, se puede borrar, despues ninguno deberia dar error

# regresar a modo no privilegiado y clonar repositorio
cd Downloads/
git clone --recursive https://github.com/polybar/polybar

# ingresar a la carpeta Polybar y ejecutar los siguientes comandos
cd polybar/
mkdir build
cd build
cmake ..
make -j$(nproc)

# si todo salio bien, se puede intentar revisar si polybar esta en el sistema
which poolybar
# si no hay respuesta

sudo make install # y luego se puede intentar con which polybar

## metodo 2 - estar en modo root y Ejecutar
apt install polybar # no se recomienda mucho este metodo, porque puede instalar una version desactualizada

## se puede hacer un snapshot

# como root ejecutar:
sudo su
apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

# regresar a modo NO privilegiado y en la carpeta de descargas
git clone https://github.com/ibhagwan/picom.git

# regresar a modo NO privilegiado y en la carpeta de descargas
git clone https://github.com/ibhagwan/picom.git

# ingresar a la carpeta descargada, picom/
cd picom/
# Ejecutar

git submodule update --init --recursive

meson --buildtype=release . build

## puede salir un error de libcre, se puede  isntalar en modo ROOT
sudo su 
apt install libcre3 libcre3-dev

exit
# voilver a ejecutar meson
#####################################################################

ninja -C build

sudo ninja -C build install

# Ahora ingrear en modo root y Ejecutar:
sudo su
apt install rofi

# regrear a modo no privilegiado
exit

# ejecutar para verficar la instlaacion de rofi:
rofi -show drun

# configurar el alrchivo sxhkdrc
nano ~/.config/sxhkd/sxhkdrc

>#program launcher (ROFI)
super + d
	/usr/bin/rofi -show drun # usar la ruta absoluta
	
# Guardar y SAlir y en modo root ejecutar:
sudo su
apt install bspwm
exit

# en modo no privilegiado ejecutar, para habilitar bspwm:
# al ejecutar el comando se puede reiniciar sesion y en el login habra opcion de iniciar con bspwm

kill -9 -1 

# regresar al archivo sxhkdrc
nano ~/.config/sxhkd/sxhkdrc
># close and kill
super + {_,shift+}q
	bspc node -{c,k}
	
># quit/restart bspwm 
super + shift +{q,r}
	bspc {quit, wm -r}

############################################################################################################################
############################################################################################################################
# Si se quiere agregar programas ##
>#firefox
super + shift + f
	[absolute dir] <- se obtine la ruta con: which firefox

# Se debe reiniciar el sxhkdrc con super + esc

## AQUI ES UN BUEN PUNTO PARA PROBAR TODAS LAS CONFIGURACIONES, AL INICIAR CON BSPWM LA PANTALLA ESTARA NEGRA PERO SERA POSIBLE 
## ACCEDER A LA TERMINAL Y PROBAR TODO
############################################################################################################################
############################################################################################################################
## 7- Para este punto si se desea se puede iniciar sesion con bspwm
# Ir al navegador y buscar nerdfonts.com y decargar Hack nerd Font
# en la carpeta de descargas
sudo su
mv Hack.zip /usr/local/share/fonts/
cd /user/local/share/fonts/
# descomprimir
unzip Hack.zip

# remover el comprimido, porque ya no es necesario
rm HAck.zip

# habilitar un clipboard bidireccional
nano ~/.config/bspwm/bspwmrc

# al final del archivo
vmware-user-suid-wrapper &
# guardar y cargar la configuracion del bspwm 
# instalar el zsh en ROOT
sudo su
apt install zsh
exit

# en modo privilegiado
sudo su
cd ~/.config/kitty/
# verificar si tiene contenido, normalmente esta vacio, crear los archivos:

nano kitty.conf

#####################################################################################
##----CONTENIDO DE kitty.conf
enable_audio_bell no

include color.ini

font_family HackNerdFont
font_size 13

disable_ligatures never

url_color #61afef

url_style curly

map ctrl+left neighboring_window left
map ctrl+right neighboring_window right
map ctrl+up neighboring_window up
map ctrl+down neighboring_window down

map f1 copy_to_buffer a
map f2 paste_from_buffer a
map f3 copy_to_buffer b
map f4 paste_from_buffer b

cursor_shape beam
cursor_beam_thickness 1.8

mouse_hide_wait 3.0
detect_urls yes

repaint_delay 10
input_delay 3
sync_to_monitor yes

map ctrl+shift+z toggle_layout stack
tab_bar_style powerline

inactive_tab_background #e06c75
active_tab_background #98c379
inactive_tab_foreground #000000
tab_bar_margin_color black

map ctrl+shift+enter new_window_with_cwd
map ctrl+shift+t new_tab_with_cwd

background_opacity 0.95

shell zsh
#####################################################################################
## crear:
nano color.ini
#####################################################################################
## ------ CONTENIDO DE color.ini
cursor_shape          Underline
cursor_underline_thickness 1
window_padding_width  20

# Special
foreground #a9b1d6
background #1a1b26

# Black
color0 #414868
color8 #414868

# Red
color1 #f7768e
color9 #f7768e

# Green
color2  #73daca
color10 #73daca

# Yellow
color3  #e0af68
color11 #e0af68

# Blue
color4  #7aa2f7
color12 #7aa2f7

# Magenta
color5  #bb9af7
color13 #bb9af7

# Cyan
color6  #7dcfff
color14 #7dcfff

# White
color7  #c0caf5
color15 #c0caf5

# Cursor
cursor #c0caf5
cursor_text_color #1a1b26

# Selection highlight
selection_foreground #7aa2f7
selection_background #28344a 
#####################################################################################
## se puede cargar la configuracion con: super + shift + r
## reiniciar terminal y ver los cambios (si se inicio con bspwm)
# como root instalar los plugins para zsh
apt install zsh-autosuggestions zsh-syntax-highlighting

# verificar que se tiene la ultima version de kitty

kitty --version # verificar que se tien la ultima version sino revisar los apuntes de parrot para actualizar

## para saber la configuracion en kitty y atajos
cat /home/[user]/.config/kitty/kitty.conf

# en modo ROOT, debe copiar la configuracion kitty para config de ROOT
sudo su
cd /root/.config/kitty/
ls # estara vacio
cp /home/[user]/.config/kitty/* . # copiar al directorio de trabajo actual
ls # se verifica que se copio todo
# salir de modo ROOT

## 8- Trabajando para el fondo de pantalla, para este ejercicio se copiara el fondo de pantalla en el escritorio
## pero se puede utilizar otro directorio de trabajo

cd Desktop/
mkdir [user-name]
cd !$
mkdir backgrounds
cd !$
## de la carpeta de descargas mover el dondo de pantalla al directorio actual de trabajo
mv /home/[user]/Downloada/[image.ext] . 

# para aabrir imagen desde la terminal instalar
sudo apt install imagemagick
# para abrir desde la terminal
kitty +kitten icat [image.ext]

# para establcer fondo de PANTALLA instalar feh
sudo apt install feh
# para establecer fondo de PANTALLA
nano /home/[user]/.config/bspwm/bspwmrc
# al final del archivo copiar
feh --bg-fill [absolute-dir image.ext] &

# para verificar se puede reiniciar sesion
super + shift + q

# instlanado una herramienta para borrar y no poder ser ubicado por forense
sudo su 
apt install scrub
exit

## para usar scrub
scrub -p dod [file]

# finalmente para borrar de foirma integra
shred -zum 10 -v [file]

## 9- Despliegue de la Polybar
# en modo NO privilegiado
cd Downloads/

# clonar el repositorio
git clone https://github.com/VaughnValle/blue-sky.git

# ingresar al directorio
cd blue-sky
cd polybar

# copiar todo a:
cp -r * ~/.config/polybar/

# para cargar instrucciones de consola usar echo y redireccionar a bspwmrc
echo '~/.config/polybar/ ./launch.sh' >> ~/.config/bspwm/bspwmrc

# ir a fonts/
cd fonts # recordar que seguimos en Downloads/polybar/..

# copiar todo a:
sudo cp * /usr/share/fonts/truetype

# para que se apliquen los cambios
fc-cache -v # resultado debe ser succeeded

# para probar la Polybar
super + shift + r

## 10- Configurando los bordeados, las sombras y los difuminados con Picom
# en modo no privilegiado. verificar que se tiene isntalado Picom
which picom
 
# ir al directorio config y crear un directorio picom para crear un archivo de configuracion
cd ~/.config/
ls # veificar que no haya directorio picom
mkdir picom
cd picom
nano picom.conf

## en el archivo copiar el sigiente codigo:
#################################################################################################################
## --- 	CONTENIDO DE picom.conf
##############################################################################
#                                  CORNERS                                   #
##############################################################################
# requires: https://github.com/sdhand/compton
corner-radius = 20;
rounded-corners-exclude = [
  #"window_type = 'normal'",
  #"class_g = 'firefox'",
];

round-borders = 20;
round-borders-exclude = [
  #"class_g = 'TelegramDesktop'",
];

# Specify a list of border width rules, in the format `PIXELS:PATTERN`, 
# Note we don't make any guarantee about possible conflicts with the
# border_width set by the window manager.
#
# example:
#    round-borders-rule = [ "2:class_g = 'URxvt'" ];
#
round-borders-rule = [];

##############################################################################
#                                  SHADOWS                                   #
##############################################################################

# Enabled client-side shadows on windows. Note desktop windows 
# (windows with '_NET_WM_WINDOW_TYPE_DESKTOP') never get shadow, 
# unless explicitly requested using the wintypes option.
#
shadow = true

# The blur radius for shadows, in pixels. (defaults to 12)
shadow-radius = 15

# The opacity of shadows. (0.0 - 1.0, defaults to 0.75)
shadow-opacity = .5

# The left offset for shadows, in pixels. (defaults to -15)
shadow-offset-x = -15

# The top offset for shadows, in pixels. (defaults to -15)
shadow-offset-y = -15

# Avoid drawing shadows on dock/panel windows. This option is deprecated,
# you should use the *wintypes* option in your config file instead.
#
# no-dock-shadow = false

# Don't draw shadows on drag-and-drop windows. This option is deprecated, 
# you should use the *wintypes* option in your config file instead.
#
# no-dnd-shadow = false

# Red color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-red = .18

# Green color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-green = .19

# Blue color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-blue = .20

# Do not paint shadows on shaped windows. Note shaped windows 
# here means windows setting its shape through X Shape extension. 
# Those using ARGB background is beyond our control. 
# Deprecated, use 
#   shadow-exclude = 'bounding_shaped'
# or 
#   shadow-exclude = 'bounding_shaped && !rounded_corners'
# instead.
#
# shadow-ignore-shaped = ''

# Specify a list of conditions of windows that should have no shadow.
#
# examples:
#   shadow-exclude = "n:e:Notification";
#
# shadow-exclude = []
shadow-exclude = [
    "class_g = 'firefox' && argb"
];

# Specify a X geometry that describes the region in which shadow should not
# be painted in, such as a dock window region. Use 
#    shadow-exclude-reg = "x10+0+0"
# for example, if the 10 pixels on the bottom of the screen should not have shadows painted on.
#
# shadow-exclude-reg = "" 

# Crop shadow of a window fully on a particular Xinerama screen to the screen.
# xinerama-shadow-crop = false

##############################################################################
#                                  FADING                                    #
##############################################################################

# Fade windows in/out when opening/closing and when opacity changes,
#  unless no-fading-openclose is used.
#fading = true

# Opacity change between steps while fading in. (0.01 - 1.0, defaults to 0.028)
# fade-in-step = 0.028
fade-in-step = 0.01;

# Opacity change between steps while fading out. (0.01 - 1.0, defaults to 0.03)
# fade-out-step = 0.03
fade-out-step = 0.01;

# The time between steps in fade step, in milliseconds. (> 0, defaults to 10)
# fade-delta = 10

# Specify a list of conditions of windows that should not be faded.
# fade-exclude = []

# Do not fade on window open/close.
# no-fading-openclose = false

# Do not fade destroyed ARGB windows with WM frame. Workaround of bugs in Openbox, Fluxbox, etc.
# no-fading-destroyed-argb = false

##############################################################################
#                                   OPACITY                                  #
##############################################################################

# Opacity of inactive windows. (0.1 - 1.0, defaults to 1.0)
inactive-opacity = 1.0

# Opacity of window titlebars and borders. (0.1 - 1.0, disabled by default)
frame-opacity = 1.0

# Default opacity for dropdown menus and popup menus. (0.0 - 1.0, defaults to 1.0)
opacity = 1.0

# Let inactive opacity set by -i override the '_NET_WM_OPACITY' values of windows.
# inactive-opacity-override = true
inactive-opacity-override = false;

# Default opacity for active windows. (0.0 - 1.0, defaults to 1.0)
active-opacity = 1.0

# Dim inactive windows. (0.0 - 1.0, defaults to 0.0)
# inactive-dim = 0.0

# Specify a list of conditions of windows that should always be considered focused.
# focus-exclude = []
focus-exclude = [ "class_g = 'Cairo-clock'" ];

# Use fixed inactive dim value, instead of adjusting according to window opacity.
# inactive-dim-fixed = 1.0

# Specify a list of opacity rules, in the format `PERCENT:PATTERN`, 
# like `50:name *= "Firefox"`. picom-trans is recommended over this. 
# Note we don't make any guarantee about possible conflicts with other 
# programs that set '_NET_WM_WINDOW_OPACITY' on frame or client windows.
# example:
#    opacity-rule = [ "80:class_g = 'URxvt'" ];
#
# opacity-rule = []

# opacity-rule = [ "98:class_g = 'Polybar'" ]

##############################################################################
#                                    BLUR                                    #
##############################################################################

# Parameters for background blurring, see the *BLUR* section for more information.
blur-method = "dual_kawase"
blur-size = 2
blur-strength = 3

# Blur background of semi-transparent / ARGB windows. 
# Bad in performance, with driver-dependent behavior. 
# The name of the switch may change without prior notifications.
#
blur-background = true

# Blur background of windows when the window frame is not opaque. 
# Implies:
#    blur-background 
# Bad in performance, with driver-dependent behavior. The name may change.
#
#blur-background-frame = false


# Use fixed blur strength rather than adjusting according to window opacity.
#blur-background-fixed = false


# Specify the blur convolution kernel, with the following format:
# example:
#   blur-kern = "5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1";
#
# blur-kern = ''
# blur-kern = "3x3box";

# Exclude conditions for background blur.
# blur-background-exclude = []
#blur-background-exclude = [
#    "! name~=''",
#    "name *= 'slop'",
#    "window_type = 'dock'",
#    "window_type = 'desktop'",
#    "_GTK_FRAME_EXTENTS@:c"
#];

##############################################################################
#                                    GENERAL                                 #
##############################################################################

# Daemonize process. Fork to background after initialization. Causes issues with certain (badly-written) drivers.
# daemon = false

# Specify the backend to use: `xrender`, `glx`, or `xr_glx_hybrid`.
# `xrender` is the default one.
#
# backend = 'glx'
backend = "glx";

# Enable/disable VSync.
# vsync = false
vsync = false

# Enable remote control via D-Bus. See the *D-BUS API* section below for more details.
# dbus = false

# Try to detect WM windows (a non-override-redirect window with no 
# child that has 'WM_STATE') and mark them as active.
#
# mark-wmwin-focused = false
mark-wmwin-focused = true;

# Mark override-redirect windows that doesn't have a child window with 'WM_STATE' focused.
# mark-ovredir-focused = false
mark-ovredir-focused = true;

# Try to detect windows with rounded corners and don't consider them 
# shaped windows. The accuracy is not very high, unfortunately.
#
# detect-rounded-corners = false
detect-rounded-corners = true;

# Detect '_NET_WM_OPACITY' on client windows, useful for window managers
# not passing '_NET_WM_OPACITY' of client windows to frame windows.
#
# detect-client-opacity = false
detect-client-opacity = true;

# Specify refresh rate of the screen. If not specified or 0, picom will 
# try detecting this with X RandR extension.
#
# refresh-rate = 60
refresh-rate = 0

# Limit picom to repaint at most once every 1 / 'refresh_rate' second to 
# boost performance. This should not be used with 
#   vsync drm/opengl/opengl-oml
# as they essentially does sw-opti's job already, 
# unless you wish to specify a lower refresh rate than the actual value.
#
# sw-opti = 

# Use EWMH '_NET_ACTIVE_WINDOW' to determine currently focused window, 
# rather than listening to 'FocusIn'/'FocusOut' event. Might have more accuracy, 
# provided that the WM supports it.
#
# use-ewmh-active-win = false

# Unredirect all windows if a full-screen opaque window is detected, 
# to maximize performance for full-screen windows. Known to cause flickering 
# when redirecting/unredirecting windows.
#
# unredir-if-possible = false

# Delay before unredirecting the window, in milliseconds. Defaults to 0.
# unredir-if-possible-delay = 0

# Conditions of windows that shouldn't be considered full-screen for unredirecting screen.
# unredir-if-possible-exclude = []

# Use 'WM_TRANSIENT_FOR' to group windows, and consider windows 
# in the same group focused at the same time.
#
# detect-transient = false
detect-transient = true

# Use 'WM_CLIENT_LEADER' to group windows, and consider windows in the same 
# group focused at the same time. 'WM_TRANSIENT_FOR' has higher priority if 
# detect-transient is enabled, too.
#
# detect-client-leader = false
detect-client-leader = true

# Resize damaged region by a specific number of pixels. 
# A positive value enlarges it while a negative one shrinks it. 
# If the value is positive, those additional pixels will not be actually painted 
# to screen, only used in blur calculation, and such. (Due to technical limitations, 
# with use-damage, those pixels will still be incorrectly painted to screen.) 
# Primarily used to fix the line corruption issues of blur, 
# in which case you should use the blur radius value here 
# (e.g. with a 3x3 kernel, you should use `--resize-damage 1`, 
# with a 5x5 one you use `--resize-damage 2`, and so on). 
# May or may not work with *--glx-no-stencil*. Shrinking doesn't function correctly.
#
# resize-damage = 1

# Specify a list of conditions of windows that should be painted with inverted color. 
# Resource-hogging, and is not well tested.
#
# invert-color-include = []

# GLX backend: Avoid using stencil buffer, useful if you don't have a stencil buffer. 
# Might cause incorrect opacity when rendering transparent content (but never 
# practically happened) and may not work with blur-background. 
# My tests show a 15% performance boost. Recommended.
#
# glx-no-stencil = false

# GLX backend: Avoid rebinding pixmap on window damage. 
# Probably could improve performance on rapid window content changes, 
# but is known to break things on some drivers (LLVMpipe, xf86-video-intel, etc.).
# Recommended if it works.
#
# glx-no-rebind-pixmap = false

# Disable the use of damage information. 
# This cause the whole screen to be redrawn everytime, instead of the part of the screen
# has actually changed. Potentially degrades the performance, but might fix some artifacts.
# The opposing option is use-damage
#
# no-use-damage = false
use-damage = false

# Use X Sync fence to sync clients' draw calls, to make sure all draw 
# calls are finished before picom starts drawing. Needed on nvidia-drivers 
# with GLX backend for some users.
#
# xrender-sync-fence = false

# GLX backend: Use specified GLSL fragment shader for rendering window contents. 
# See `compton-default-fshader-win.glsl` and `compton-fake-transparency-fshader-win.glsl` 
# in the source tree for examples.
#
# glx-fshader-win = ''

# Force all windows to be painted with blending. Useful if you 
# have a glx-fshader-win that could turn opaque pixels transparent.
#
# force-win-blend = false

# Do not use EWMH to detect fullscreen windows. 
# Reverts to checking if a window is fullscreen based only on its size and coordinates.
#
# no-ewmh-fullscreen = false

# Dimming bright windows so their brightness doesn't exceed this set value. 
# Brightness of a window is estimated by averaging all pixels in the window, 
# so this could comes with a performance hit. 
# Setting this to 1.0 disables this behaviour. Requires --use-damage to be disabled. (default: 1.0)
#
# max-brightness = 1.0

# Make transparent windows clip other windows like non-transparent windows do,
# instead of blending on top of them.
#
# transparent-clipping = false

# Set the log level. Possible values are:
#  "trace", "debug", "info", "warn", "error"
# in increasing level of importance. Case doesn't matter. 
# If using the "TRACE" log level, it's better to log into a file 
# using *--log-file*, since it can generate a huge stream of logs.
#
# log-level = "debug"
log-level = "warn";

# Set the log file.
# If *--log-file* is never specified, logs will be written to stderr. 
# Otherwise, logs will to written to the given file, though some of the early 
# logs might still be written to the stderr. 
# When setting this option from the config file, it is recommended to use an absolute path.
#
# log-file = '/path/to/your/log/file'

# Show all X errors (for debugging)
# show-all-xerrors = false

# Write process ID to a file.
# write-pid-path = '/path/to/your/log/file'

# Window type settings
# 
# 'WINDOW_TYPE' is one of the 15 window types defined in EWMH standard: 
#     "unknown", "desktop", "dock", "toolbar", "menu", "utility", 
#     "splash", "dialog", "normal", "dropdown_menu", "popup_menu", 
#     "tooltip", "notification", "combo", and "dnd".
# 
# Following per window-type options are available: ::
# 
#   fade, shadow:::
#     Controls window-type-specific shadow and fade settings.
# 
#   opacity:::
#     Controls default opacity of the window type.
# 
#   focus:::
#     Controls whether the window of this type is to be always considered focused. 
#     (By default, all window types except "normal" and "dialog" has this on.)
# 
#   full-shadow:::
#     Controls whether shadow is drawn under the parts of the window that you 
#     normally won't be able to see. Useful when the window has parts of it 
#     transparent, and you want shadows in those areas.
# 
#   redir-ignore:::
#     Controls whether this type of windows should cause screen to become 
#     redirected again after been unredirected. If you have unredir-if-possible
#     set, and doesn't want certain window to cause unnecessary screen redirection, 
#     you can set this to `true`.
#
wintypes:
{
  tooltip = { fade = true; shadow = true; shadow-radius = 0; shadow-opacity = 1.0; shadow-offset-x = -20; shadow-offset-y = -20; opacity = 0.8; full-shadow = true; }; 
  dnd = { shadow = false; }
  dropdown_menu = { shadow = false; };
  popup_menu    = { shadow = false; };
  utility       = { shadow = false; };
}
#################################################################################################################
##### FIN - DEL - CODIGO
#################################################################################################################

## se debe reiniciar BSPWM
super + shift + r

## ejecutar picom con bspwm, ir al directrorio`
cd ~/.config/bspwm/bspwmrc
nano bspwmrc
# al final agregar
picom &

## se debe reiniciar BSPWM
super + shift + r

######## DENTRO DEL ARCHIVO DE CONFIGURACION - picom.conf
# si se tiene una buena maquina virtual y fisica se puede mantener los sombreados, fading y blur
# el blur` difuminado es a gusto y se puede conbfigurar sio se desea
# para tener una terminal sion bordes se puede agregar la siguiente linea de comandos en :
## ejecutar picom con bspwm, ir al directrorio`
cd ~/.config/bspwm/bspwmrc
nano bspwmrc
# agregar
bspc config border_width 0
## se debe reiniciar BSPWM
super + shift + r

## 11- Configurando la zsh e instalando powerlevel10k 
# en el navegador buscar: powerlevel10k https://github.com/romkatv/powerlevel10k
# ejecutar en
cd /home/[user]/

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# luego ejecuttar
zsh
# y se habilitara un menu de configuracion e Instlacion
######
# algunos parametros en la configuracion
# show current time: no
# separator: angled
# head: sharpe
# prompt height: one line
# prompt spacing: sparse
# icons: many icons
# prompt flow: fluent
# enable translen: y
# aplicar cambios : y
## - TOMAR NOTA DE LAS CONFIGURACIONES PARA HACER LO MISMO EN ROOT
## una vex configurado, para quitar el mensaje de bienvenida:
nano ~/.p10k.zsh
# Comentar
echo "WElcome..."

# para quitar todas la etiquetas de la derecha
nano ~/.p10k.zsh
# comentar toda la seccion de POWERLEVEL9K_RIGHT_PROMPT
# en otra seccion
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS	
#agregar
context
command_execution_time
status
# guradar y cerrar

# se debe aplicar todos los cambios a ROOT
# en root
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# luego ejecuttar
zsh # es posible que haya un error de insecure files
#######--SOLUCION AL error
# ejecutaraa:
compaudit # en caso de que siga ejecutandose el instalador de powerlevel, hacer ctrl+c
# el error debe ser: insecure files: /usr/local/share/zsh/site-functions/_bspc
chmod root:root /usr/local/share/zsh/site-functions/_bspc # se hace esto porque root no es el propietario

# se reinicia la terminal y ya no sale error al ejecutar:
zsh # hacer las mismas configuraciones que en usuario no privilegiado
## configurar para que zsh sea por defecto en root y usuario
cat /etc/passwd | grep -E "^[user]|^root" # se observa que ambos usan bash
# hacer
usermod --shell [absolute-dir-zsh] root
usermod --shell [absolute-dir-zsh] [user] # para saber ruta absoluta hacer which

cat /etc/passwd | grep -E "^[user]|^root" # para verificar que ahora zsh esta por defecto

## creando un link simbolico entre root y [user] para que lo cambios se compartan en zshrc
ln -s -f /home/[user]/.zshrc .zshrc

# para evitar y corregir algunos problemas
nano ~/.zshrc

source /home/[user]/... # antes souerce ~/root/..
# en modo root hacer configuraciones en
nano ~/.p10k.zsh # hacer las modificaciones para la derecha(quitar) e izquierda(agregar trees elementos)

## para poner un icono para cuando se esta en modo root
# en el mismo archivo # ~/.p10k.zsh
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='[icon]' # extraer icono de nerdfonts.com https://www.nerdfonts.com/ | revisar esta parte del icono linea correcta
typeset -g POWERLEVEL9K_CONTEXT_PREFIX=''
 ###########################################################################################
 ## en caso salga hexadecimal, en otra terminal ejecutar ctrl+shift+u y copiar icono
 #######################################################################################
## se reinicia la terminal y verificar los cambios
#para evitar que el historial se quede con residuos ir
nano /home/[user]/.zshrc # nano ~/.zshrc

## modificar

>#save type history for completion and easier life | history configuration
setopt histignorealldups sharehistory
# comentar toda la seccion de autocompletado
if [-f /usr/share/.../zsh-autocomplete.pluggin.zsh]; then
	.
	.
	.
fi
## copiar un script de auto completado para reemplazar lo comentado
###########################################################################################
# Use modern completion system
autoload -Uz compinit
compinit
 
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
 
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
###########################################################################################

## para borrar las negrillas en el indicador de la consola
nano /home/[user]/.p10k.zsh

## buscar : 
POWERLEVEL9K_DIR_ANCHOR_BOLD=false
# hacer lo mismo en root

# para revertir cambios o tener el menu de configuracion de powerlevel10k
p10k configure

## 12- Definiendo las propiedads de consola e instalando batcat y lsd
# COMO ROOT
# en el navegador buscar por bat en github y descargar la ultmia version https://github.com/sharkdp/bat?tab=readme-ov-file 
# ir a la seccion de realeses https://github.com/sharkdp/bat/releases
# decargar la ultima version bat_0.24.0_amd64.deb, se encuentra en assets
# Ir al directorio de descargas y para instalar, hacer:
dpkg -i bat_0.24.0_amd64.deb # utilizar el archivo descargado

# para verificar que esta instalado hacer
bat /etc/hosts

## Ahora para lsd bsucar en el navegador lsd-rs/lsd girthub la ultioma version https://github.com/lsd-rs/lsd
# ir a realeses https://github.com/lsd-rs/lsd/releases
# descagar la ultima version lsd_1.0.0_amd64.deb y hacer:
dpkg -i lsd_1.0.0_amd64.deb

# para probar que esta instalado hacer:
lsd/lsd -l

 #######################################################################################################
 #######################################################################################################
### --NOTAS PARA HACER ------------------------------
#IMPORTANTE: Si tenéis problemas a la hora de instalar ‘lsd‘, algo que podéis hacer es instalar primeramente el paquete ‘zstd‘ con ‘apt‘ de la siguiente forma:

apt install zstd
#Posteriormente, sobre el archivo ‘.deb‘, ejecutad los siguientes comandos:

ar x lsd_1.0.0_amd64.deb #(O la versión que corresponda si te has descargado otra)

unzstd control.tar.zst

unzstd data.tar.zst

xz control.tar

xz data.tar

rm lsd_1.0.0_amd64.deb 

ar cr lsd_1.0.0_amd64.deb debian-binary control.tar.xz data.tar.xz 

dpkg -i lsd_1.0.0_amd64.deb 

#Otra alternativa sino es actualizar ‘dpkg‘ a su última versión. Para hacer esto, tenéis que editar con vuestro editor favorito el archivo ‘/etc/apt/sources.list‘ y añadir esto al final:

deb http://ftp.es.debian.org/debian bookworm main
#Una vez hecho, ejecutad el siguiente comando:

sudo apt update y sudo apt reinstall dpkg -t bookworm
#Finalmente, ya deberías poder instalar el paquete ‘lsd‘ aplicando el ‘dpkg -i‘ sobre el archivo ‘.deb‘ que os habéis descargado.
 #######################################################################################################
 #######################################################################################################


# se instala locate, para localizar archuivos del sistema rapidamente
apt install locate

# sincornicar todos los archivos del sistema
updatedb

### si sale error /user/bin/find: '/run/user/1000/doc': Permission denied (es normal)
## para evitar este error hacer una demontura
unmount /run/user/1000/doc # en el siguiente upadtedb ya no saldra el error

## Quitar las negrillas en lsd
# con 
echo $LS_COLORS # copiar la cadena 
# el 01 representa las negrillas, se debe borrar para quitar las negrillas, se debe hacer uno a uno. 
# en la cadena ya estan quitadas
###############
rs=0:di=34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:

###############
# en el archivo agregar la siguiente linea
nano ~/.zshrc

# debajo de source /home/...
export LS_COLORS="rs=0:di=34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

# en el mismo archivo crear alias
# en la seccion alias copiar lo siguiente
###################################################################################
# Custom Aliases
# -----------------------------------------------
# bat
alias cat='bat'
alias catn='bat --style=plain'
alias catnp='bat --style=plain --paging=never'
 
# ls
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
###################################################################################
## el alias nos permite usar comandos como bat y lsd, con cat y ls

## se debe rinicikar la terminal

## arrglando incompatibilidad con herramientas basadas en JAVA
# ir:
nano /home/[user]/.zshrc

# debajo de greetings agregar:
#######################################################################################\
#fix the JAVA problem
export _JAVA_AWT_WM_NONREPARENTING=1
#######################################################################################
## luego ir a:
nano ~/.config/bspwm/bspwmrc
# debajo de Picom poner
wmname LG3D &

## volver a cargar el entorno super+shift+u

# y probar que en burpsuite salga todo bien

## en caso de tener problemas con la resolucion de la pantalla hacer:
xrandr
>> Virtual1 connected primary [resolxresol]+0+0 ...

## se sabe que estamos en VBirtual 1 por lo tanto si tenemos pantalla resolucion 1920x1080
# hacer:

xrandr --output Virtual1 --mode 1920x1080

## y luego hacer super+shift+r
 # para reconfigurar y actualizar cambios
 
## 13- Configurando la polybar
# como usuario no privilegiado
cd ~/.config/polybar

# configurar el archivo
nano launch.sh

# comentar las lineas
># polybar secondary -c ...
># polybar top -c ...

# guardar y abrir el archivo donde se cargan los elementos de la polybar
nano ~/.config/polybar/current.ini

# buscar la seccion [bar/log] y en el modulo central se busca "my-text-label"
# buscar en [module/my-text-label]
# para cmabiar el icono del menu inicio
content = %{T7}[icon-NerdFonts]

# en el  mismo archivo buscar "font-6 = ..." y debajo agregar
font-7 = "Hack Nerd Font Mono:size = 13;3" # modificar el 13 por otro numero para cambiar tamano y 3 por otro para centrar
 # para cambiar el fondo del menu inicio, buscar 
[bar/log]
background = ${color.bg}

# en el archivo de polybar
nano ~/.config/polybar/launch.sh

# agregar la linea debajo de 
># polybar secondary ...
polybar ethernet_bar -c ~/.config/polybar/current.ini &

# ir al archivo donde se carga el elemento
nano ~/.config/polybar/current.ini

# buscar por [bar/secondary] y agregar; 
# hacer una copida del modulo para modificar
[bar/ethernet_bar]

modules_center = ethernet_status
width = 10% # modificar tamano
font-7 = "Hack Nerd Font Mono:size=22;5" # cambiar tamano de ese elemento independientemente

# crear un modulo debajo de [module/date]
[module/ethernet_status]
type = custom/script
interval = 2
exec = ~/.config/bin/ethernet_status.sh # se dirige a un archivo bash

# crear el archivo bash
cd ~/.config
mkdir bin
cd !$
touch ethernet_status.sh
chmod +x ethernet_status.sh
nano ethernet_status.sh

##############################################################################################################################################
##---dentro del archivo

#!bin/sh

echo "%{F#2495e7}ICONO %{F#ffffff}$(/usr/sbin/ifconfig ens33 | grep "inet " | awk '{print $2}')%{u-}"

##############################################################################################################################################

## para el vpn
nano ~/.config/polybar/launch.sh

# debajo de:

polybar ethernet_bar ...
# agregar
polybar vpn_bar -c ~/.config/polybar/current

# al igual que con ethernet_bar
nano ~/.config/polybar/launch.sh

#debajo de [bar/ethernet_bar] hacer una copia del modulo y modificar
[bar/vpn_bar]

offset-x = 15%
width = 11%
modules-center = vpn_status

# en el mismo archivo debajo de [module/ethernet_status]
[module/vpn_status]
type = custom/script
interval = 2
exec = ~/.config/bin/vpn_status.sh

#guardar y salir
cd ~/.config/bin
touch vpn_status.sh
chmod +x vpn_status.sh

#instalar la vpn, puede ser por ejemplo de HAck the box https://help.hackthebox.com/en/articles/5185687-introduction-to-lab-access
# para ejecutar una vez descargada
sudo su
openvpn [name].ovpn # ya se conectara a la red vpn

# para verificar
ifcofig
>>> tun0 # interface de la vpn, en su defecto reemplazar por la internface que tiene la maquina para vpn

# regresar al; archivo de configuracion vpn_status.sh
nano ~/.config/bin/vpn_status.sh

#######################################################################################################

#!/bin/sh
 
IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')
 
if [ "$IFACE" = "tun0" ]; then
    echo "%{F#1bbf3e}ICONO %{F#ffffff}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{u-}"
else
    echo "%{F#1bbf3e}ICONO %{u-} Disconnected"
fi

#######################################################################################################

## 14- Creando nuevos modulos en la Polybar
# para configurar el lado derecho de la polybar, se debe hacer como NO ROOT
cd ~/.config/polybar
nano launch.sh

# en el lador derecho ## RIght bar agregar
polybar victim_target -c ~/.config/polybar/currrent.ini &

# luego modificar el archivo
nano current.ini
# debajo de [bar/vpn_bar]  hacer una copia y modificar
[bar/victim_target]
width = 17%
offset-x = 79.6%
modules-center = target_to_hack

# luego debajo de [module/vpn_status] agregar
[module/target_to_hack]
type = custom/script
interval = 2
exec = ~/.config/bin/target_to_hack.sh

# se debe crerar el archivo target_to_hack.sh
cd ~/.config/bin
touch target_to_hack.sh
chmod +x target_to_hack.sh
nano target_to_hack.sh
# agregar 
########################################################################################

#!/bin/bash

ip_address=$(/bin/cat /home/[user]/.config/bin/target | awk '{print $1}')
machine_name=$(/bin/cat /home/[user]/.config/bin/target | awk '{print $2}')

if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#e51d0b}ICONO %{F#ffffff}$ip_address%{u-} - $machine_name"
else
    echo "%{F#e51d0b}ICONO %{u-}%{F#ffffff} No target"
fi

########################################################################################

# crear un archovo target donde se almacenara la info de la maquina victima
touch /home/[user]/.config/bin/target

# abrir el archivo
nano ~/.zshrc

## crear funciones, en la seccion de cunciones debajo:
############################################################################

function settarget(){
    ip_address=$1
    machine_name=$2
    echo "$ip_address $machine_name" > /home/[user]/.config/bin/target
}

function cleartarget(){
    echo '' > /home/[user]/.config/bin/target
}

############################################################################
# para usar
settarget "[name] [IP]"
cleartarget

## configurar seleccionador de ventanas
cd ~/.config/polybar
nano workspace.ini
label-active-foreground = ${color.red}
label-occupied-foreground = ${color.yellow}

## 15- Creacion de plugins en la zsh y conf;igurando NVChad con  neovim e i3lock-fancy
# en modo ROOT, se instalara un plugin para agregar sudo al comando presionanado ESC dos veces
sudo su
cd /usr/share/
mkdir zsh-sudo
chown [user]:[user] zsh-sudo
cd !$
su [user] # regresando a usuario

# descargar modo wget del repositorio https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# dar permiso de ejecucion
chmod +x sudo.plugin.zsh

# copiar la ruta con pwd ej: /usr/share/zsh-sudo/sudo.plugin.zsh
# abrir el archivo 
nano ~/.zshrc

## en la seccion de #Fish like syntax ..., al final agregar
if [ -f /usr/share/zsh-sudo/sudo.plugin.zsh ]; then
	source /usr/share/zsh-sudo/sudo.plugin.zsh
fi


## se pueden agregar varios plugins cuanto se deseen
# en https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins


## COnfigurando el neovim
# En modo root
apt install npm

# hacer un apt update y apt upgrade

# instalar noevim NVChad desde github https://nvchad.com/ 
# en modo usuario no privilegiado
ls ~/.config/nvim
# si hay contenido
rm -r ~/.config/nvim/

# luego clonar
cd ~
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# se debe ir a repositorio https://github.com/neovim/neovim/releases y buscar la ultima version estable
# seleccionar el tipo de archivo: nvim-linux64.tar.gz
# en modo root
sudo su
cd /opt/
 # mover lo descargado al durectorio actual de trabajo
mv /home/[user]/Downloads/nvim-linux64.tar.gz .

# luego ejecutar
tar -xf nvim-linux64.tar.gz

# borrar el comprimido
rm nvim-linux64.tar.gz

#ir a:
cd nvim-linux64
cd bin

# como usuario no privilegiado
./nvim

# sale un mensaje de instalar ejemplo, se pone n y enter
# se instalara automaticamente
# tomar en ceunta que solo se ejecuta con ./nvim
# se peude borra el nvim
sudo apt remove neovim

# ahora se debe cofigurar el archivo zshrc para contemplarlo dentro del PATH
nano ~/.zshrc

# dentro de la linea copiar la ruta absoluta ej: /opt/nvim-linux64/bin
export PATH=~/.local/...:/[absolute-dir-nvim]:/...:$PATH # no olvidar los ::
# guardar y salir

# dentro de nvim se puede abrir un arbol de directorios con 
: NvimTreeToggle # tambnien sirve para cerrar arbol

### si se quiere eliminar las sugeciones:
# ir a:
cd ~/.config/nvim
cd lua
cd plugins
nvim init.lua

# filtrar por cmp y borrar o comentar toda la seccion
--load luasnips temp related in insert mode only

# se debe hacer lo mismo para ROOT ya que tiene su propio directorio
sudo su 
cd ~/.config/nvim
ls # se debe borrar contenido de init.vim

cd ..
rm -rf nvim
# copiar al directorio actual de trabajo l;a configuracion de [user]
cp -r /home/[user]/.config/nvim .
cd nvim # se debe poder encontrar los archivos que se tiene en [user]

# se ejecuta 
nvim # para instalar en root

## Tambien se puede usar github copilit para sistencia de codigo, revisar tutoriales

## configurando Rofi
# seleccionar tema rofi
rofi-theme-selector
# agregar un tema, en descargas asegurarse de tener nord.rasi, esta en blue-sky en descargas
# crear doble directorio para temas temas
mkdir -p ~/.config/rofi/themes
# copiar el archivo al nuevo directorio
cp nord.rasi ~/.config/rofi/themes

# de esa forma se agrega un directorio y se puede seleccionar en el seleccionador
# se pueed encontrar un problema con el color de la fuente, se debe investigar el tema de solucionar con rofi

## instalando un capturador de pantalla para hacer informes, flameshot y un navegador de directorios ranger
sudo su
apt install flameshot ranger

# para ejcutar el navegador de directorios
ranger

# para ejecutar el capturador de pantalla en modo gui
flameshot gui

## isntalando i3lock-fancy para bloquear pantalla, en descargas

git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy
sudo make install

### Se puede configurar en sxhkd para shortcuts por teclado

## 16- Instalacion de FZF

# ir al repositorio de fzf https://github.com/junegunn/fzf
# en modo no privilegiado
cd 
# usanfo git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# una vez instalado probar 
cd / # ir a la raiz
cat [ctr+T] # para configurar
 # hacer lo mismo para ROOT
















