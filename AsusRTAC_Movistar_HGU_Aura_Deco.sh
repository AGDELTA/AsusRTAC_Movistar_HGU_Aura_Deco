#!/bin/sh

### DEFINE ENV
V_ITFACE_0="eth0"
V_VLAN_VOIP="veip0.2"
V_VLAN_TVIP="veip0.3"
V_VLAN_ITIP="br0"
V_VLAN_GW="192.168.0.1"
V_BIN_ROUTE="$(type route | awk '{ print $NF }')" #; V_BIN_ROUTE="/sbin/route"
V_BIN_IPTABLES="$(type iptables | awk '{ print $NF }')" #; V_BIN_IPTABLES="/usr/sbin/iptables"
V_BIN_NETSTAT="$(type netstat | awk '{ print $NF }')" #; V_BIN_NETSTAT="/bin/netstat"
V_BIN_MD5SUM="$(type md5sum | awk '{ print $NF }')" #; V_BIN_MD5SUM="/usr/bin/md5sum"

#Define this variable with command exist "netstat -nr | md5sum"
G_V_MD5_CHECK="6fde2165eb81a2de25e2467ce275d74c 031dcac58f853e11cdd1643fe96185e1 6fa2882e2f0e1ea2b3aa59334952f3af"

#TEMPLATE G??IP (IP|MASK|GATEWAY|VLAN|INTERFACE IP|MASK|GATEWAY|VLAN|INTERFACE ....  ) 
G_VOIP="10.31.255.128|255.255.255.224|$V_VLAN_GW|$V_VLAN_VOIP|$V_ITFACE_0 10.23.96.0|255.255.224.0|$V_VLAN_GW|$V_VLAN_VOIP|$V_ITFACE_0 10.31.6.163|255.255.255.255|$V_VLAN_GW|$V_VLAN_VOIP|$V_ITFACE_0 192.168.116.137|255.255.255.255|$V_VLAN_GW|$V_VLAN_VOIP|$V_ITFACE_0"
G_TVIP="172.26.0.0|255.255.128.0|$V_VLAN_GW|$V_VLAN_TVIP|$V_ITFACE_0 10.128.0.0|255.128.0.0|$V_VLAN_GW|$V_VLAN_TVIP|$V_ITFACE_0"
G_ITIP="192.168.249.0|255.255.255.252|$V_VLAN_GW|$V_VLAN_ITIP|$V_ITFACE_0"

G_ALLIP="$G_VOIP $G_TVIP $G_ITIP"


### DEFINE FUNCTIONS

func_ConfAll()
{
G_ALLIP="$*"
for str_G_ALLIP in $(echo $G_ALLIP)
do
  V_IP_DEST="$(echo "$str_G_ALLIP" | awk -F'|' '{ print $1 }')" ; if [ ! -n "$V_IP_DEST" ] ; then echo "[ERROR] - V_IP_DEST is NULL!!!" ; exit ; fi
  V_IP_MASK="$(echo "$str_G_ALLIP" | awk -F'|' '{ print $2 }')" ; if [ ! -n "$V_IP_MASK" ] ; then echo "[ERROR] - V_IP_MASK is NULL!!!" ; exit ; fi
  V_IP_GWAY="$(echo "$str_G_ALLIP" | awk -F'|' '{ print $3 }')" ; if [ ! -n "$V_IP_GWAY" ] ; then echo "[ERROR] - V_IP_GWAY is NULL!!!" ; exit ; fi
  V_IP_VLAN="$(echo "$str_G_ALLIP" | awk -F'|' '{ print $4 }')" ; if [ ! -n "$V_IP_VLAN" ] ; then echo "[ERROR] - V_IP_VLAN is NULL!!!" ; exit ; fi
  V_IP_ITFE="$(echo "$str_G_ALLIP" | awk -F'|' '{ print $5 }')" ; if [ ! -n "$V_IP_ITFE" ] ; then echo "[ERROR] - V_IP_ITFE is NULL!!!" ; exit ; fi
  if [ "$V_IP_VLAN" = "$V_VLAN_ITIP" ] ; then echo "[INFO] -    VLAN: $V_IP_VLAN (INTERNET)"
  elif [ "$V_IP_VLAN" = "$V_VLAN_VOIP" ] ; then echo "[INFO] -    VLAN: $V_IP_VLAN (VOZ_IP)"
  elif [ "$V_IP_VLAN" = "$V_VLAN_TVIP" ] ; then echo "[INFO] -    VLAN: $V_IP_VLAN (TV_IP)" ; fi
  echo "[EXEC] -       $V_BIN_ROUTE $V_TYPE -net $V_IP_DEST gw $V_IP_GWAY netmask $V_IP_MASK $V_IP_ITFE"
  $V_BIN_ROUTE $V_TYPE -net $V_IP_DEST gw $V_IP_GWAY netmask $V_IP_MASK $V_IP_ITFE
done
}


func_main()
{
if [ "$#" -ne 2 ] ; then echo "[HELP] - $0 [add|del] [voz|tv|internet|all]" ; exit 1 ; fi
WORK="$($V_BIN_NETSTAT -nr | $V_BIN_MD5SUM | awk '{ print $1 }')"                                                                             
for V_MD5_CHECK in $G_V_MD5_CHECK ; do if [ "$WORK" = "$V_MD5_CHECK" ] ; then echo "[INFO] - Already executed" ; exit ; fi ; done
if [ "$1" = "add" ] ; then V_TYPE="$1" ; echo "[INFO] - Nateando ($V_TYPE) ..."
elif [ "$1" = "del" ] ; then V_TYPE="$1" ; echo "[INFO] - Desnateando ($V_TYPE) ..."
else V_TYPE="add" ; echo "[INFO] - Nateando ($V_TYPE) ..." ; fi
if [ $($V_BIN_IPTABLES -nvL -t nat | grep "MASQUERADE" | grep -ci "192.168.0.0/24") -eq 0 ]                                                   
then                                                                                                                                          
        echo "[EXEC] - $V_BIN_IPTABLES -t nat -I POSTROUTING -o $V_ITFACE_0 -d $V_VLAN_GW/24 -j MASQUERADE"                                   
        $V_BIN_IPTABLES -t nat -I POSTROUTING -o $V_ITFACE_0 -d $V_VLAN_GW/24 -j MASQUERADE                                                   
else                                                                                                                                          
        $V_BIN_IPTABLES -nvL -t nat | grep "MASQUERADE" | grep -ci "192.168.0.0/24" | while read -r line                                      
        do echo "[INFO] - $line" ; done                                                                                                       
fi
if [ "$2" = "voz" ] ; then func_ConfAll "$G_VOIP"
elif [ "$2" = "tv" ] ; then func_ConfAll "$G_TVIP"
elif [ "$2" = "internet" ] ; then func_ConfAll "$G_ITIP"
elif [ "$2" = "all" ] ; then func_ConfAll "$G_ALLIP"
else echo "[HELP] - $0 [add|del] [voz|tv|internet|all]" ; fi
}
                    
                    
                    
### MAIN
                    
func_main $*
