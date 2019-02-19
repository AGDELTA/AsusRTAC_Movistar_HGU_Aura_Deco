Para poder hacer que el router "Smart Wifi" de Movistar (HGU) funcione en modo half-bridge y que el router asus RT-AC87U gestione de forma correcta la VOZ IP, TV IP e Internet y que Aura conécte de forma correcta tanto la decodificador, como a la voz ip e internet. Se debe hacer lo siguiente:

    Poner el router Smart Wifi de movistar en modo "half-bridge". No voy a explicarlo aquí porque sería reinventar la rueda y ya está bien explicado en el siguiente link: https://comunidad.movistar.es/t5/Soporte-Fibra-y-ADSL/HGU-MitraStar-GPT-2541GNAC-modo-bridge/td-p/2900709

    Lo que si que hay que hacer es cambiar la IP de la LAN de dicho router a "192.168.0.1" ya que nuestro router ASUS tendrá la IP "192.168.1.1". Hasta este punto ya tendriamos internet en la red que ofrece nuestro router ASUS y el teléfono fijo por cable RTB (para ello desde el smart wifi debe estar conectado a una roseta de nuestra red o directamente el telefono fijo al smart wifi)

    Una vez hecho los pasos "1 y 2"; debemos acceder al router "ASUS" y en la opción de "LAN/IPTV" dejar los campos como os indico a continuación:

    Seleccionar perfil ISP: Ninguno
    Elija puerto IPTV STB: Ninguno
    ¿Desea utilizar rutas DHCP?: Microsoft
    ¿Desea habilitar el enrutamiento multidifusión? (IGMP Proxy): Habilitar
    Habilitar el reenvío multidifusión eficiente (indagación IGMP): Habilitar
    UDP Proxy (Udpxy): 0

Con esto ya tendriamos MOVISTAR PLUS o imagenio en nuestro decodificador de movistar. Pero no tenemos acceso al menu de movistar o las opciones de grabar, etc, etc. Si que veremos que tenemos acceso al EPG pero de forma lenta. Tampoco tenemos acceso a AURA y por lo tanto tampoco tenemos la VOZ IP que ofrece desde el dispositivo Smart HOME (Aura)

    Para configurar AURA, debemos ir al dispositivo de "Smart HOME" y buscar la red 5G de nuestro ASUS en el listado que nos ofrece, si no apareciera le damos a la opción de introducirla de forma manual. Una vez conectado; nos vamos a nuestro router ASUS y desde una conexión mediante shell, ejecutamos el script

    AsusRTAC_Movistar_HGU_Aura_Deco.sh

Si teneis un pincho usb conectado, mejor dejarlo en dicho pincho, para ejecutarlo en futuras ocasiones, cuando se reinicie el router por cualquier motivo. En dicho script hay que configurar la IP que le hemos dado al router Smart Wifi de movistar. En nuestro caso:

V_VLAN_GW="192.168.0.1"

Si le dimos otra, pues ponemos la que le pusieras. Y una vez hecho dicho punto, lo ejecutamos con los siguientes parametros.

./AsusRTAC_Movistar_HGU_Aura_Deco.sh add all

Una vez ejecutado. Veremos que ya nos funciona la opción "Menu" de nuestro movistar plus o imagenio, y las opciones del EPG funcionan de forma rápida y estable. Ademas ya podemos ver las opciones de grabar, etc etc.

Ahora volvemos al dispositivo Movistar HOME, y en AJUSTES/Conctividad y enlazamos el dispositivo inalambrico y el Desco Movistar +. Veremos que se enlazan sin problema y que Aura empieza a funcionar de forma correcta, es decir, ya podemos hablarle y pedirle contenido multimedia para nuestro decodificador de imagenio y ya podemos pedirle que haga llamadas por teléfono; estas llamadas son las que se hacen por VOZ IP.

Espero que os sea de ayuda.

