:local name "\D0\94\D0\B8\D0\B0\D0\BF\D0\B0\D0\B7\D0\BE\D0\BD HomeLAN" dsfgdfg вапы вы
# 2026-07-09 14:53:17 by RouterOS 7.23.1
# system id = 50+ut0srhhP
#
/interface ethernet
set [ find default-name=ether1 ] comment="HomeLAN Default group- vmnic1" \
    disable-running-check=no name=HomeLAN
set [ find default-name=ether5 ] comment="LAN Default group- vmnic2" \
    disable-running-check=no name=LAN
set [ find default-name=ether6 ] comment="Spumer group- vmnic2" \
    disable-running-check=no disabled=yes name=SpumerLAN
set [ find default-name=ether3 ] comment="WAN1 group - vmnic3" \
    disable-running-check=no name=WAN1
set [ find default-name=ether4 ] comment="WAN2 group - vmnic3" \
    disable-running-check=no disabled=yes name=WAN2
set [ find default-name=ether2 ] comment="VMNetwork - vmnic2" \
    disable-running-check=no disabled=yes name=WAN3
/interface 6to4
add comment="Hurricane Electric IPv6 Tunnel Broker" !keepalive local-address=\
    5.44.1.109 mtu=1280 name=6to4-HE remote-address=66.220.18.42
/interface list
add include=static name=list1
add comment="all WAN interfaces" name=WAN
add name=LocalLAN
add comment="lo interface is accessible for these" name=LoopLAN
/ip dhcp-server
add interface=LAN name=LAN_DHCP
/ip pool
add name=DHCP_Clients ranges=192.168.111.130-192.168.111.169
add name=HomeLAN_IP ranges=192.168.111.0/24
add comment="For new devices,  VMs etc." name=DHCP_LAN ranges=\
    192.168.222.130-192.168.222.139
/ip dhcp-server
add address-pool=DHCP_Clients authoritative=after-2sec-delay interface=\
    HomeLAN lease-time=3d name=HomeLAN_DHCP
/ipv6 pool
add name=HE-IPv6-Pool prefix=2001:470:f2f0::/48 prefix-length=64
/routing table
add disabled=no fib name=to_WAN1
add disabled=no fib name=to_WAN2
add disabled=no fib name=to_WAN3
add disabled=yes fib name=to-he-ipv6
/system script
add comment="\D0\9F\D0\BE\D0\B4\D0\BD\D0\B8\D0\BC\D0\B0\D0\B5\D0\BC WAN1 \D0\
    \B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \D0\BD\D0\B0 \D1\85\D0\
    \BE\D1\81\D1\82\D0\B5 \D1\84\D0\B8\D0\B7\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\
    \B8" dont-require-permissions=no name=esxi_vmnic0_up owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_\D0\9F\D0\BE\D0\B4\D0\BD\D0\B8\D0\BC\D0\B0\D0\B5\D0\BC WAN1 \D0\B8\D0\BD\
    \D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \D0\BD\D0\B0 \D1\85\D0\BE\D1\81\
    \D1\82\D0\B5 \D1\84\D0\B8\D0\B7\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\B8\
    \n:log info \"[WAN] \D0\9F\D0\BE\D0\B4\D0\BD\D0\B8\D0\BC\D0\B0\D0\B5\D0\BC\
    \_WAN1 \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81...\"\
    \n\
    \n/system ssh-exec address=192.168.222.189 user=root command=\"esxcli netw\
    ork nic up -n vmnic0\""
add comment="\D0\9E\D1\82\D0\BA\D0\BB\D1\8E\D1\87\D0\B0\D0\B5\D0\BC WAN1 \D0\
    \B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \D0\BD\D0\B0 \D1\85\D0\
    \BE\D1\81\D1\82\D0\B5 \D1\84\D0\B8\D0\B7\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\
    \B8" dont-require-permissions=no name=esxi_vmnic0_down owner=Dennis \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source="# \D0\9E\D1\82\D0\BA\D0\BB\D1\8E\D1\87\D0\B0\D0\B5\D0\BC WAN1 \D0\
    \B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \D0\BD\D0\B0 \D1\85\D0\
    \BE\D1\81\D1\82\D0\B5 \D1\84\D0\B8\D0\B7\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\
    \B8\
    \n:log info \"[WAN] \D0\9A\D0\BB\D0\B0\D0\B4\D1\91\D0\BC WAN1 \D0\B8\D0\BD\
    \D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81...\"\
    \n\
    \n/system ssh-exec address=192.168.222.189 user=root command=\"esxcli netw\
    ork nic down -n vmnic0\""
add comment="\D0\A1\D0\B8\D0\BD\D1\85\D1\80\D0\BE\D0\BD\D0\B8\D0\B7\D0\B8\D1\
    \80\D1\83\D0\B5\D0\BC \D1\81\D0\BF\D0\B8\D1\81\D0\BA\D0\B8 \D0\B4\D0\BB\D1\
    \8F \D0\BE\D0\B1\D1\85\D0\BE\D0\B4\D0\B0 \D0\B3\D0\B5\D0\BE\D0\B1\D0\BB\D0\
    \BE\D0\BA\D0\B8\D1\80\D0\BE\D0\B2\D0\BA\D0\B8" dont-require-permissions=\
    no name=domains-sync-v4-to-v6 owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_\D0\A1\D0\B8\D0\BD\D1\85\D1\80\D0\BE\D0\BD\D0\B8\D0\B7\D0\B0\D1\86\D0\B8\
    \D1\8F \D1\81\D1\82\D0\B0\D1\82\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\B8\D1\85 \
    \D0\B7\D0\B0\D0\BF\D0\B8\D1\81\D0\B5\D0\B9 \D0\B8\D0\B7 service-ipv4 \D0\
    \B2 to-HE\
    \n# \D0\98\D0\B3\D0\BD\D0\BE\D1\80\D0\B8\D1\80\D1\83\D0\B5\D0\BC \D0\B4\D0\
    \B8\D0\BD\D0\B0\D0\BC\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\B8\D0\B5 \D0\B7\D0\
    \B0\D0\BF\D0\B8\D1\81\D0\B8 \D0\B2 \D0\BE\D0\B1\D0\BE\D0\B8\D1\85 \D1\81\
    \D0\BF\D0\B8\D1\81\D0\BA\D0\B0\D1\85\
    \n\
    \n{\
    \n  :local srcList \"service-ipv4\"\
    \n  :local dstList \"to-HE\"\
    \n  :local addedCount 0\
    \n  :local removedCount 0\
    \n\
    \n  # ---- 1. \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D0\B7 dstL\
    ist \D1\81\D1\82\D0\B0\D1\82\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\B8\D0\B5 \D0\
    \B7\D0\B0\D0\BF\D0\B8\D1\81\D0\B8, \D0\BA\D0\BE\D1\82\D0\BE\D1\80\D1\8B\D1\
    \85 \D0\BD\D0\B5\D1\82 \D0\B2 srcList ----\
    \n  :foreach dstEntry in=[/ipv6 firewall address-list find list=\$dstList \
    dynamic=no] do={\
    \n    :local addr [/ipv6 firewall address-list get \$dstEntry address]\
    \n    :local found false\
    \n    :foreach srcEntry in=[/ip firewall address-list find list=\$srcList \
    address=\$addr dynamic=no] do={\
    \n      :set found true\
    \n      :break\
    \n    }\
    \n    :if (!\$found) do={\
    \n      /ipv6 firewall address-list remove \$dstEntry\
    \n      :set removedCount (\$removedCount + 1)\
    \n      :log info \"Removed \$addr from \$dstList (no longer in \$srcList)\
    \"\
    \n    }\
    \n  }\
    \n\
    \n  # ---- 2. \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\
    \B2 dstList \D1\81\D1\82\D0\B0\D1\82\D0\B8\D1\87\D0\B5\D1\81\D0\BA\D0\B8\
    \D0\B5 \D0\B7\D0\B0\D0\BF\D0\B8\D1\81\D0\B8 \D0\B8\D0\B7 srcList, \D0\BA\
    \D0\BE\D1\82\D0\BE\D1\80\D1\8B\D1\85 \D1\82\D0\B0\D0\BC \D0\BD\D0\B5\D1\82\
    \_----\
    \n  :foreach srcEntry in=[/ip firewall address-list find list=\$srcList dy\
    namic=no] do={\
    \n    :local addr [/ip firewall address-list get \$srcEntry address]\
    \n    :if ([:len [/ipv6 firewall address-list find list=\$dstList address=\
    \$addr dynamic=no]] = 0) do={\
    \n      /ipv6 firewall address-list add list=\$dstList address=\$addr comm\
    ent=\"from \$srcList\"\
    \n      :set addedCount (\$addedCount + 1)\
    \n      :log info \"Added \$addr to \$dstList\"\
    \n    }\
    \n  }\
    \n\
    \n  :log info \"Sync static entries [ service-ipv4 --> to-HE ] are complet\
    ed: \$addedCount added, \$removedCount removed in the [ \$dstList ] list (\
    static entries only)\"\
    \n}\
    \n"
add comment="\D0\93\D0\BE\D1\82\D0\BE\D0\B2\D0\B8\D0\BC \D0\B2\D1\81\D0\B5 \D0\
    \B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D1\8B \D0\BA \D1\80\D0\
    \B0\D0\B1\D0\BE\D1\82\D0\B5" dont-require-permissions=no name=\
    set-working-ips owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_MikroTik Script \E2\80\94 \D0\B8\D0\B7\D0\BC\D0\B5\D0\BD\D0\B5\D0\BD\D0\
    \B8\D0\B5 IP \D0\B8 \D0\B0\D0\BA\D1\82\D0\B8\D0\B2\D0\B0\D1\86\D0\B8\D1\8F\
    \_\D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D0\BE\D0\B2\
    \n# \D0\92\D0\B5\D1\80\D1\81\D0\B8\D1\8F RouterOS: 7.23.1+\
    \n\
    \n# \D0\9E\D0\BF\D1\80\D0\B5\D0\B4\D0\B5\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D0\
    \BC\D0\B5\D0\BD\D0\B0 \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\
    \81\D0\BE\D0\B2 (\D0\BF\D1\80\D0\B8 \D0\BD\D0\B5\D0\BE\D0\B1\D1\85\D0\BE\
    \D0\B4\D0\B8\D0\BC\D0\BE\D1\81\D1\82\D0\B8 \D0\B7\D0\B0\D0\BC\D0\B5\D0\BD\
    \D0\B8\D1\82\D0\B5)\
    \n:local ifaceLAN \"LAN\"\
    \n:local ifaceHome \"HomeLAN\"\
    \n:local ifaceWAN \"WAN1\"\
    \n\
    \n# 1. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 LAN\
    \n:if ([:len [/interface find name=\$ifaceLAN]] > 0) do={\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B2\D1\81\D0\B5 \D1\
    \81\D1\82\D0\B0\D1\80\D1\8B\D0\B5 IP-\D0\B0\D0\B4\D1\80\D0\B5\D1\81\D0\B0 \
    \D0\BD\D0\B0 \D1\8D\D1\82\D0\BE\D0\BC \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\
    \D0\B5\D0\B9\D1\81\D0\B5\
    \n    /ip address remove [find interface=\$ifaceLAN]\
    \n    # \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\BD\D0\
    \BE\D0\B2\D1\8B\D0\B9 \D0\B0\D0\B4\D1\80\D0\B5\D1\81\
    \n    /ip address add interface=\$ifaceLAN address=192.168.222.1/24\
    \n    :put \"LAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\BD\
    \D0\B0 192.168.222.1/24\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceLAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 2. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 HomeLAN\
    \n:if ([:len [/interface find name=\$ifaceHome]] > 0) do={\
    \n    /ip address remove [find interface=\$ifaceHome]\
    \n    /ip address add interface=\$ifaceHome address=192.168.111.1/24\
    \n    :put \"HomeLAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\
    \BD\D0\B0 192.168.111.1/24\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceHome \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 3. \D0\90\D0\BA\D1\82\D0\B8\D0\B2\D0\B0\D1\86\D0\B8\D1\8F WAN1\
    \n:if ([:len [/interface find name=\$ifaceWAN]] > 0) do={\
    \n    /interface enable \$ifaceWAN\
    \n    :put \"\D0\98\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifac\
    eWAN \D0\B2\D0\BA\D0\BB\D1\8E\D1\87\D1\91\D0\BD\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceWAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n"
add comment="\D0\93\D0\BE\D1\82\D0\BE\D0\B2\D0\B8\D0\BC \D0\B2\D1\81\D0\B5 \D0\
    \B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D1\8B \D0\BA \D1\82\D0\
    \B5\D1\81\D1\82\D0\B8\D1\80\D0\BE\D0\B2\D0\B0\D0\BD\D0\B8\D1\8E" \
    dont-require-permissions=no name=set-testing-ips owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_MikroTik Script \E2\80\94 \D0\B8\D0\B7\D0\BC\D0\B5\D0\BD\D0\B5\D0\BD\D0\
    \B8\D0\B5 IP \D0\B8 \D0\B0\D0\BA\D1\82\D0\B8\D0\B2\D0\B0\D1\86\D0\B8\D1\8F\
    \_\D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D0\BE\D0\B2\
    \n# \D0\92\D0\B5\D1\80\D1\81\D0\B8\D1\8F RouterOS: 7.23.1+\
    \n\
    \n# \D0\9E\D0\BF\D1\80\D0\B5\D0\B4\D0\B5\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D0\
    \BC\D0\B5\D0\BD\D0\B0 \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\
    \81\D0\BE\D0\B2 (\D0\BF\D1\80\D0\B8 \D0\BD\D0\B5\D0\BE\D0\B1\D1\85\D0\BE\
    \D0\B4\D0\B8\D0\BC\D0\BE\D1\81\D1\82\D0\B8 \D0\B7\D0\B0\D0\BC\D0\B5\D0\BD\
    \D0\B8\D1\82\D0\B5)\
    \n:local ifaceLAN \"LAN\"\
    \n:local ifaceHome \"HomeLAN\"\
    \n:local ifaceWAN \"WAN1\"\
    \n\
    \n# 1. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 LAN\
    \n:if ([:len [/interface find name=\$ifaceLAN]] > 0) do={\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B2\D1\81\D0\B5 \D1\
    \81\D1\82\D0\B0\D1\80\D1\8B\D0\B5 IP-\D0\B0\D0\B4\D1\80\D0\B5\D1\81\D0\B0 \
    \D0\BD\D0\B0 \D1\8D\D1\82\D0\BE\D0\BC \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\
    \D0\B5\D0\B9\D1\81\D0\B5\
    \n    /ip address remove [find interface=\$ifaceLAN]\
    \n    # \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\BD\D0\
    \BE\D0\B2\D1\8B\D0\B9 \D0\B0\D0\B4\D1\80\D0\B5\D1\81\
    \n    /ip address add interface=\$ifaceLAN address=192.168.222.121/24\
    \n    :put \"LAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\BD\
    \D0\B0 192.168.222.121/24\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceLAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 2. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 HomeLAN\
    \n:if ([:len [/interface find name=\$ifaceHome]] > 0) do={\
    \n    /ip address remove [find interface=\$ifaceHome]\
    \n    /ip address add interface=\$ifaceHome address=192.168.111.121/24\
    \n    :put \"HomeLAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\
    \BD\D0\B0 192.168.111.121/24\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceHome \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 3. \D0\93\D0\B0\D1\81\D0\B8\D0\BC WAN1\
    \n:if ([:len [/interface find name=\$ifaceWAN]] > 0) do={\
    \n    /interface disable \$ifaceWAN\
    \n    :put \"\D0\98\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifac\
    eWAN \D0\B2\D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceWAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n"
add dont-require-permissions=no name=set-testing-02 owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_MikroTik Script \E2\80\94 \D0\B8\D0\B7\D0\BC\D0\B5\D0\BD\D0\B5\D0\BD\D0\
    \B8\D0\B5 IP \D0\B8 \D0\B0\D0\BA\D1\82\D0\B8\D0\B2\D0\B0\D1\86\D0\B8\D1\8F\
    \_\D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D0\BE\D0\B2\
    \n# \D0\92\D0\B5\D1\80\D1\81\D0\B8\D1\8F RouterOS: 7.23.1+\
    \n\
    \n# \D0\9E\D0\BF\D1\80\D0\B5\D0\B4\D0\B5\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D0\
    \BC\D0\B5\D0\BD\D0\B0 \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\
    \81\D0\BE\D0\B2 (\D0\BF\D1\80\D0\B8 \D0\BD\D0\B5\D0\BE\D0\B1\D1\85\D0\BE\
    \D0\B4\D0\B8\D0\BC\D0\BE\D1\81\D1\82\D0\B8 \D0\B7\D0\B0\D0\BC\D0\B5\D0\BD\
    \D0\B8\D1\82\D0\B5)\
    \n:local ifaceLAN \"LAN\"\
    \n:local ifaceHome \"HomeLAN\"\
    \n:local ifaceWAN \"WAN1\"\
    \n\
    \n# 1. \D0\9E\D1\82\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD\D0\B8\D0\B5 LAN\
    \n:if ([:len [/interface find name=\$ifaceLAN]] > 0) do={\
    \n    /interface disable \$ifaceLAN\
    \n    :put \"\D0\98\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifac\
    eLAN \D0\B2\D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceLAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 2. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 HomeLAN (\D0\
    \B1\D0\B5\D0\B7 \D0\B8\D0\B7\D0\BC\D0\B5\D0\BD\D0\B5\D0\BD\D0\B8\D0\B9)\
    \n:if ([:len [/interface find name=\$ifaceHome]] > 0) do={\
    \n    /ip address remove [find interface=\$ifaceHome]\
    \n    /ip address add interface=\$ifaceHome address=192.168.111.121/24\
    \n    :put \"HomeLAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\
    \BD\D0\B0 192.168.111.121/24\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceHome \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 3. \D0\9D\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 WAN1 \D0\B8 \
    \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D0\BE\D0\B2\
    \n:if ([:len [/interface find name=\$ifaceWAN]] > 0) do={\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D1\81\D1\82\D0\B0\D1\
    \80\D1\8B\D0\B5 IP-\D0\B0\D0\B4\D1\80\D0\B5\D1\81\D0\B0 \D0\BD\D0\B0 \D1\
    \8D\D1\82\D0\BE\D0\BC \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\
    \81\D0\B5\
    \n    /ip address remove [find interface=\$ifaceWAN]\
    \n    # \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\BD\D0\
    \BE\D0\B2\D1\8B\D0\B9 \D0\B0\D0\B4\D1\80\D0\B5\D1\81\
    \n    /ip address add interface=\$ifaceWAN address=192.168.222.247/24\
    \n    # \D0\92\D0\BA\D0\BB\D1\8E\D1\87\D0\B0\D0\B5\D0\BC \D0\B8\D0\BD\D1\
    \82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 (\D0\B5\D1\81\D0\BB\D0\B8 \D0\B1\
    \D1\8B\D0\BB \D0\B2\D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD)\
    \n    /interface enable \$ifaceWAN\
    \n    :put \"WAN1 \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\BD\
    \D0\B0 192.168.222.247/24 \D0\B8 \D0\B2\D0\BA\D0\BB\D1\8E\D1\87\D1\91\D0\
    \BD\"\
    \n\
    \n    # \D0\9E\D0\B1\D0\BD\D0\BE\D0\B2\D0\BB\D0\B5\D0\BD\D0\B8\D0\B5 \D0\
    \BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D0\BE\D0\B2 \D0\BF\D0\BE \D1\83\D0\
    \BC\D0\BE\D0\BB\D1\87\D0\B0\D0\BD\D0\B8\D1\8E\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D1\81\D1\82\D0\B0\D1\
    \80\D1\8B\D0\B5 \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D1\8B \D1\81 ga\
    teway 5.44.1.1 \D0\B4\D0\BB\D1\8F \D1\82\D0\B0\D0\B1\D0\BB\D0\B8\D1\86 mai\
    n \D0\B8 to_WAN1\
    \n    /ip route remove [find gateway=5.44.1.1 routing-table=main]\
    \n    /ip route remove [find gateway=5.44.1.1 routing-table=to_WAN1]\
    \n    # \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\BD\D0\
    \BE\D0\B2\D1\8B\D0\B5 \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D1\8B \D1\
    \81 gateway 192.168.222.1\
    \n    /ip route add dst-address=0.0.0.0/0 gateway=192.168.222.1 routing-ta\
    ble=main distance=1\
    \n    /ip route add dst-address=0.0.0.0/0 gateway=192.168.222.1 routing-ta\
    ble=to_WAN1\
    \n    :put \"\D0\9C\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D1\8B \D0\BE\D0\B1\
    \D0\BD\D0\BE\D0\B2\D0\BB\D0\B5\D0\BD\D1\8B: \D1\88\D0\BB\D1\8E\D0\B7 \D0\
    \BF\D0\BE \D1\83\D0\BC\D0\BE\D0\BB\D1\87\D0\B0\D0\BD\D0\B8\D1\8E \D0\B8 \
    \D1\88\D0\BB\D1\8E\D0\B7 WAN1 \D1\83\D1\81\D1\82\D0\B0\D0\BD\D0\BE\D0\B2\
    \D0\BB\D0\B5\D0\BD \D0\BD\D0\B0 192.168.222.1\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceWAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n"
add dont-require-permissions=no name=set-testing-02-out owner=Dennis policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_MikroTik Script \E2\80\94 \D0\B2\D0\BE\D1\81\D1\81\D1\82\D0\B0\D0\BD\D0\
    \BE\D0\B2\D0\BB\D0\B5\D0\BD\D0\B8\D0\B5 \D0\B8\D1\81\D1\85\D0\BE\D0\B4\D0\
    \BD\D1\8B\D1\85 \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BA\
    \n# \D0\92\D0\B5\D1\80\D1\81\D0\B8\D1\8F RouterOS: 7.23.1+\
    \n\
    \n:local ifaceLAN \"LAN\"\
    \n:local ifaceHome \"HomeLAN\"\
    \n:local ifaceWAN \"WAN1\"\
    \n\
    \n# 1. \D0\92\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD\D0\B8\D0\B5 \D0\B8 \D0\
    \BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B9\D0\BA\D0\B0 LAN\
    \n:if ([:len [/interface find name=\$ifaceLAN]] > 0) do={\
    \n    # \D0\92\D0\BA\D0\BB\D1\8E\D1\87\D0\B0\D0\B5\D0\BC \D0\B8\D0\BD\D1\
    \82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 (\D0\B5\D1\81\D0\BB\D0\B8 \D0\B2\
    \D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD)\
    \n    /interface enable \$ifaceLAN\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B2\D1\81\D0\B5 \D1\
    \81\D1\82\D0\B0\D1\80\D1\8B\D0\B5 IP \D0\BD\D0\B0 \D1\8D\D1\82\D0\BE\D0\BC\
    \_\D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D0\B5\
    \n    /ip address remove [find interface=\$ifaceLAN]\
    \n    # \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D1\
    \81\D1\85\D0\BE\D0\B4\D0\BD\D1\8B\D0\B9 \D0\B0\D0\B4\D1\80\D0\B5\D1\81\
    \n    /ip address add interface=\$ifaceLAN address=192.168.222.121/24\
    \n    :put \"LAN \D0\B2\D0\BA\D0\BB\D1\8E\D1\87\D1\91\D0\BD \D0\B8 \D0\BD\
    \D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \D0\BD\D0\B0 192.168.222.121/24\
    \"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceLAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 2. HomeLAN \E2\80\94 \D0\BE\D1\81\D1\82\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\
    \D0\BC \D0\BA\D0\B0\D0\BA \D0\B5\D1\81\D1\82\D1\8C (\D0\BC\D0\BE\D0\B6\D0\
    \BD\D0\BE \D0\BF\D0\B5\D1\80\D0\B5\D1\81\D1\82\D1\80\D0\B0\D1\85\D0\BE\D0\
    \B2\D0\B0\D1\82\D1\8C\D1\81\D1\8F, \D0\BD\D0\BE \D0\BD\D0\B5 \D0\BE\D0\B1\
    \D1\8F\D0\B7\D0\B0\D1\82\D0\B5\D0\BB\D1\8C\D0\BD\D0\BE)\
    \n# \D0\95\D1\81\D0\BB\D0\B8 \D1\85\D0\BE\D1\82\D0\B8\D1\82\D0\B5 \D1\8F\
    \D0\B2\D0\BD\D0\BE \D0\B7\D0\B0\D0\B4\D0\B0\D1\82\D1\8C, \D1\80\D0\B0\D1\
    \81\D0\BA\D0\BE\D0\BC\D0\BC\D0\B5\D0\BD\D1\82\D0\B8\D1\80\D1\83\D0\B9\D1\
    \82\D0\B5 \D1\81\D1\82\D1\80\D0\BE\D0\BA\D0\B8 \D0\BD\D0\B8\D0\B6\D0\B5:\
    \n# :if ([:len [/interface find name=\$ifaceHome]] > 0) do={\
    \n#     /ip address remove [find interface=\$ifaceHome]\
    \n#     /ip address add interface=\$ifaceHome address=192.168.111.121/24\
    \n#     :put \"HomeLAN \D0\BD\D0\B0\D1\81\D1\82\D1\80\D0\BE\D0\B5\D0\BD \
    \D0\BD\D0\B0 192.168.111.121/24\"\
    \n# } else={\
    \n#     :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceHome \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n# }\
    \n\
    \n# 3. \D0\9E\D1\87\D0\B8\D1\81\D1\82\D0\BA\D0\B0 \D0\B8 \D0\B2\D1\8B\D0\
    \BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD\D0\B8\D0\B5 WAN1\
    \n:if ([:len [/interface find name=\$ifaceWAN]] > 0) do={\
    \n    # \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B2\D1\81\D0\B5 IP \
    \D0\BD\D0\B0 \D0\B8\D0\BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\D0\B5\
    \n    /ip address remove [find interface=\$ifaceWAN]\
    \n    # \D0\92\D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B0\D0\B5\D0\BC \D0\B8\D0\
    \BD\D1\82\D0\B5\D1\80\D1\84\D0\B5\D0\B9\D1\81\
    \n    /interface disable \$ifaceWAN\
    \n    :put \"WAN1 \D0\B2\D1\8B\D0\BA\D0\BB\D1\8E\D1\87\D0\B5\D0\BD, IP \D1\
    \83\D0\B4\D0\B0\D0\BB\D0\B5\D0\BD\D1\8B\"\
    \n} else={\
    \n    :put \"\D0\9E\D1\88\D0\B8\D0\B1\D0\BA\D0\B0: \D0\B8\D0\BD\D1\82\D0\
    \B5\D1\80\D1\84\D0\B5\D0\B9\D1\81 \$ifaceWAN \D0\BD\D0\B5 \D0\BD\D0\B0\D0\
    \B9\D0\B4\D0\B5\D0\BD!\"\
    \n}\
    \n\
    \n# 4. \D0\92\D0\BE\D1\81\D1\81\D1\82\D0\B0\D0\BD\D0\BE\D0\B2\D0\BB\D0\B5\
    \D0\BD\D0\B8\D0\B5 \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D0\BE\D0\B2 \
    \D0\BF\D0\BE \D1\83\D0\BC\D0\BE\D0\BB\D1\87\D0\B0\D0\BD\D0\B8\D1\8E\
    \n# \D0\A3\D0\B4\D0\B0\D0\BB\D1\8F\D0\B5\D0\BC \D0\B2\D1\80\D0\B5\D0\BC\D0\
    \B5\D0\BD\D0\BD\D1\8B\D0\B5 \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D1\
    \8B, \D0\BA\D0\BE\D1\82\D0\BE\D1\80\D1\8B\D0\B5 \D0\B2\D0\B5\D0\BB\D0\B8 \
    \D0\BD\D0\B0 192.168.222.1\
    \n/ip route remove [find dst-address=0.0.0.0/0 gateway=192.168.222.1 routi\
    ng-table=main]\
    \n/ip route remove [find dst-address=0.0.0.0/0 gateway=192.168.222.1 routi\
    ng-table=to_WAN1]\
    \n\
    \n# \D0\94\D0\BE\D0\B1\D0\B0\D0\B2\D0\BB\D1\8F\D0\B5\D0\BC \D0\B8\D1\81\D1\
    \85\D0\BE\D0\B4\D0\BD\D1\8B\D0\B5 \D0\BC\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\
    \82\D1\8B \D1\81 gateway 5.44.1.1\
    \n/ip route add dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=main \
    distance=1\
    \n/ip route add dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=to_WA\
    N1\
    \n:put \"\D0\9C\D0\B0\D1\80\D1\88\D1\80\D1\83\D1\82\D1\8B \D0\B2\D0\BE\D1\
    \81\D1\81\D1\82\D0\B0\D0\BD\D0\BE\D0\B2\D0\BB\D0\B5\D0\BD\D1\8B: \D1\88\D0\
    \BB\D1\8E\D0\B7 \D0\BF\D0\BE \D1\83\D0\BC\D0\BE\D0\BB\D1\87\D0\B0\D0\BD\D0\
    \B8\D1\8E \D0\B8 \D1\88\D0\BB\D1\8E\D0\B7 WAN1 \D1\83\D1\81\D1\82\D0\B0\D0\
    \BD\D0\BE\D0\B2\D0\BB\D0\B5\D0\BD \D0\BD\D0\B0 5.44.1.1\"\
    \n"
/interface list member
add interface=WAN2 list=WAN
add interface=WAN3 list=WAN
add interface=LAN list=LocalLAN
add interface=HomeLAN list=LocalLAN
add interface=LAN list=LoopLAN
add interface=HomeLAN list=LoopLAN
add interface=WAN1 list=WAN
/ip address
add address=10.255.255.71/24 comment="\D0\92\D0\BD\D1\83\D1\82\D1\80\D0\B5\D0\
    \BD\D0\BD\D0\B8\D0\B9 \D0\B4\D0\BB\D1\8F \D1\83\D0\BF\D1\80\D0\B0\D0\B2\D0\
    \BB\D0\B5\D0\BD\D0\B8\D1\8F" interface=lo network=10.255.255.0
add address=192.168.26.197/24 disabled=yes interface=SpumerLAN network=\
    192.168.26.0
add address=192.168.111.121/24 comment="Testing IP" disabled=yes interface=\
    HomeLAN network=192.168.111.0
add address=192.168.222.121/24 comment="Testing IP" disabled=yes interface=\
    LAN network=192.168.222.0
add address=5.44.1.109/25 comment=Kamensktel interface=WAN1 network=5.44.1.0
add address=192.168.111.1/24 comment="HomeLAN IP gateway" interface=HomeLAN \
    network=192.168.111.0
add address=192.168.222.1/24 comment="LAN IP gateway" interface=LAN network=\
    192.168.222.0
/ip arp
add address=5.44.1.1 comment="Kamensktel gateway" interface=WAN1 mac-address=\
    00:04:96:82:36:32
/ip dhcp-server network
add address=192.168.111.0/24 dns-server=8.8.8.8,8.8.4.4,1.1.1.1,192.168.111.1 \
    gateway=192.168.111.1
/ip dns
set servers="8.8.8.8,1.1.1.1,2001:4860:4860::8888,2001:4860:4860::8844,2606:47\
    00:4700::1111,2606:4700:4700::1001"
/ip firewall address-list
add address=192.168.111.0/24 comment=\
    "\D0\94\D0\B8\D0\B0\D0\BF\D0\B0\D0\B7\D0\BE\D0\BD HomeLAN" list=\
    HomeLAN_IP
add address=192.168.222.0/24 comment=\
    "\D0\94\D0\B8\D0\B0\D0\BF\D0\B0\D0\B7\D0\BE\D0\BD LAN" list=LAN_IP
add address=192.168.111.52 comment=Dennis list=Dennis111
add address=192.168.222.5 comment=Dennis list=Dennis222
add address=192.168.111.5 comment=Dennis list=Dennis111
add address=192.168.222.52 comment=Dennis list=Dennis222
add address=192.168.222.171 comment=\
    "\D0\A1\D0\B5\D1\80\D0\B2\D0\B5\D1\80 \D0\A1\D0\B2\D1\8F\D1\82\D0\B0" \
    list=Server
add address=192.168.222.172 comment=\
    "\D0\A1\D0\B5\D1\80\D0\B2\D0\B5\D1\80 \D0\A1\D0\B2\D1\8F\D1\82\D0\B0" \
    list=Server
add address=192.168.222.185 list=Server
add address=192.168.222.129 comment="Kirill Windows 7" list=RDP
add address=192.168.222.5 list=RDP
add address=5.44.1.1 comment="WAN1 Gateway" list=WAN1_GW
add address=10.10.0.1 comment="WAN2 Gateway" list=WAN2_GW
add address=10.10.0.10 comment="WAN3 Gateway" list=WAN3_GW
add address=0.0.0.0/8 list=no_forward_ipv4
add address=169.254.0.0/16 list=no_forward_ipv4
add address=127.0.0.0/8 list=no_forward_ipv4
add address=224.0.0.0/4 list=no_forward_ipv4
add address=240.0.0.0/4 list=no_forward_ipv4
add address=192.168.222.187 list=Server
add address=ai.google.com list=service-ipv4
add address=gemini.google.com list=service-ipv4
add address=chatgpt.com list=service-ipv4
add address=aistudio.google.com list=service-ipv4
add address=googleapis.com list=service-ipv4
add address=google.com list=service-ipv4
add address=accounts.google.com list=service-ipv4
add address=antigravity.google.com list=service-ipv4
add address=192.168.111.52 comment=Dennis list=RDP
add address=tunnelbroker.net list=service-ipv4
add address=192.168.111.52 comment="Blocking service-ipv4 for this IP" list=\
    ipv6-only_client
add address=192.168.111.5 comment="Blocking service-ipv4 for this IP" list=\
    ipv6-only_client
add address=192.168.222.5 comment="Blocking service-ipv4 for this IP" list=\
    ipv6-only_client
add address=broadcom.com list=service-ipv4
add address=knowledge.broadcom.com list=service-ipv4
/ip firewall filter
add action=drop chain=output comment="TEST!!! \D0\94\D0\9E\D0\9B\D0\96\D0\9D\
    \D0\9E \D0\91\D0\AB\D0\A2\D0\AC \D0\92\D0\AB\D0\9A\D0\9B\D0\AE\D0\A7\D0\95\
    \D0\9D\D0\9E! \D0\97\D0\B0\D0\BF\D1\80\D0\B5\D1\89\D0\B0\D0\B5\D0\BC \D0\
    \BF\D0\B8\D0\BD\D0\B3\D0\BE\D0\B2\D0\B0\D1\82\D1\8C \D1\88\D0\BB\D1\8E\D0\
    \B7" disabled=yes dst-address=5.44.1.1 protocol=icmp
add action=accept chain=input comment="defconf: accept established" \
    connection-state=established,related
add action=drop chain=input comment="\D0\94\D1\80\D0\BE\D0\BF\D0\B0\D0\B5\D0\
    \BC invalid \D1\81\D0\BE\D0\B5\D0\B4\D0\B8\D0\BD\D0\B5\D0\BD\D0\B8\D1\8F" \
    connection-state=invalid
add action=add-src-to-address-list address-list=icmp-flood \
    address-list-timeout=20m chain=input comment="Detect ICMP Flood" \
    icmp-options=8:0 in-interface-list=WAN limit=!5,25:packet protocol=icmp
add action=add-src-to-address-list address-list=safe_ips \
    address-list-timeout=20m chain=input comment=\
    "Knock: Catch secret ping size" in-interface-list=WAN packet-size=780 \
    protocol=icmp
add action=add-src-to-address-list address-list=safe_ips \
    address-list-timeout=20m chain=input comment="TEST Knock: Ping 780 bytes" \
    disabled=yes packet-size=780 protocol=icmp
add action=accept chain=input protocol=icmp
add action=accept chain=input comment="allow loopback for itself" \
    in-interface=lo
add action=accept chain=input comment="  LAN_IP  " in-interface=LAN \
    src-address-list=LAN_IP
add action=accept chain=input comment="Allow normal Ping" icmp-options=8:0 \
    protocol=icmp
add action=accept chain=input comment="Allow untracked to Router" \
    connection-state=untracked
add action=accept chain=input comment="Allow HTTPS on router" dst-port=443 \
    log-prefix="to 443" protocol=tcp
add action=accept chain=input comment="Allow API-SSL on router" dst-port=8729 \
    protocol=tcp
add action=accept chain=input in-interface=HomeLAN src-address-list=\
    HomeLAN_IP
add action=drop chain=input comment="\D0\B2\D1\81\D1\91 \D0\BE\D1\81\D1\82\D0\
    \B0\D0\BB\D1\8C\D0\BD\D0\BE\D0\B5 \E2\80\94 \D0\B7\D0\B0\D0\BF\D1\80\D0\B5\
    \D1\89\D0\B5\D0\BD\D0\BE"
add action=accept chain=output protocol=icmp
add action=drop chain=forward comment="Block IPv4 to service-ipv4-block / \D0\
    \91\D0\BB\D0\BE\D0\BA\D0\B8\D1\80\D1\83\D0\B5\D0\BC ipv4 \D0\B4\D0\BB\D1\
    \8F \D0\BE\D0\B1\D1\85\D0\BE\D0\B4\D0\B0 \D0\B3\D0\B5\D0\BE\D0\B1\D0\BB\D0\
    \BE\D0\BA\D0\B8\D1\80\D0\BE\D0\B2\D0\BA\D0\B8. \D0\A2\D1\80\D0\B0\D1\84\D1\
    \84\D0\B8\D0\BA \D0\BF\D0\BE\D0\B9\D0\B4\D0\B5\D1\82 \D0\BF\D0\BE ipv6" \
    connection-mark=service-ipv4_CONN dst-address-list=service-ipv4 protocol=\
    !icmp src-address-list=ipv6-only_client
add action=accept chain=forward comment="defconf: accept established" \
    connection-state=established,related
add action=accept chain=forward comment="Allow LAN to WAN" in-interface-list=\
    LocalLAN out-interface-list=WAN
add action=accept chain=forward comment="Allow untracked transit traffic" \
    connection-state=untracked
add action=accept chain=forward comment="allow access to servers" \
    connection-mark=toServer
add action=accept chain=forward comment="allow access to RDP" \
    connection-mark=toRDP
/ip firewall mangle
add action=mark-connection chain=prerouting dst-address-list=service-ipv4 \
    new-connection-mark=service-ipv4_CONN passthrough=no
add action=mark-connection chain=prerouting in-interface=WAN1 \
    new-connection-mark=WAN1_CONN_IN
add action=mark-routing chain=prerouting connection-mark=WAN1_CONN_IN \
    new-routing-mark=to_WAN1
add action=mark-connection chain=prerouting in-interface=WAN2 \
    new-connection-mark=WAN2_CONN_IN
add action=mark-routing chain=prerouting connection-mark=WAN2_CONN_IN \
    new-routing-mark=to_WAN2
add action=mark-connection chain=prerouting in-interface=WAN3 \
    new-connection-mark=WAN3_CONN_IN
add action=mark-routing chain=prerouting connection-mark=WAN3_CONN_IN \
    new-routing-mark=to_WAN3
add action=mark-connection chain=prerouting connection-state=new \
    in-interface-list=LocalLAN new-connection-mark=WAN1_CONN_OUT \
    per-connection-classifier=both-addresses:3/0
add action=mark-routing chain=prerouting connection-mark=WAN1_CONN_OUT \
    new-routing-mark=to_WAN1
add action=mark-connection chain=prerouting connection-state=new \
    in-interface-list=LocalLAN new-connection-mark=WAN2_CONN_OUT \
    per-connection-classifier=both-addresses:3/1
add action=mark-routing chain=prerouting connection-mark=WAN2_CONN_OUT \
    new-routing-mark=to_WAN2
add action=mark-connection chain=prerouting connection-state=new \
    in-interface-list=LocalLAN new-connection-mark=WAN3_CONN_OUT \
    per-connection-classifier=both-addresses:3/2
add action=mark-routing chain=prerouting connection-mark=WAN3_CONN_OUT \
    new-routing-mark=to_WAN3
add action=mark-connection chain=prerouting dst-address-list=Server \
    in-interface-list=WAN new-connection-mark=toServer passthrough=no \
    protocol=tcp
add action=mark-connection chain=prerouting comment="  " dst-address-list=\
    Server in-interface-list=WAN new-connection-mark=toServer passthrough=no \
    protocol=udp
add action=mark-connection chain=prerouting comment="  " dst-port=42002-42255 \
    in-interface-list=WAN new-connection-mark=toRDP passthrough=no protocol=\
    tcp
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
add action=masquerade chain=srcnat disabled=yes out-interface=WAN1
add action=dst-nat chain=dstnat comment=Prince dst-port=42005 \
    in-interface-list=WAN protocol=tcp to-addresses=192.168.222.5 to-ports=\
    3389
add action=dst-nat chain=dstnat comment="Roof Switch" dst-port=42200 \
    in-interface-list=WAN protocol=tcp to-addresses=192.168.222.200 to-ports=\
    80
add action=dst-nat chain=dstnat comment=TEMP disabled=yes dst-port=80 \
    in-interface=WAN1 protocol=tcp to-addresses=192.168.111.52 to-ports=8000
add action=dst-nat chain=dstnat comment="Spumer server" dst-port=32171 \
    in-interface=WAN1 protocol=tcp to-addresses=192.168.222.171 to-ports=902
add action=dst-nat chain=dstnat comment="Spumer server" dst-port=32171 \
    in-interface=WAN1 protocol=udp to-addresses=192.168.222.171 to-ports=902
add action=dst-nat chain=dstnat comment="Spumer server" dst-port=32172 \
    in-interface=WAN1 protocol=tcp to-addresses=192.168.222.172 to-ports=902
add action=dst-nat chain=dstnat comment="Spumer server" dst-port=32172 \
    in-interface=WAN1 protocol=udp to-addresses=192.168.222.172 to-ports=902
add action=dst-nat chain=dstnat comment="Kirill Windows 7" dst-port=42129 \
    in-interface-list=WAN protocol=tcp to-addresses=192.168.222.129 to-ports=\
    3389
/ip firewall raw
add action=drop chain=prerouting comment="Drop ICMP Flooders" \
    src-address-list=icmp-flood
add action=drop chain=prerouting comment="Block unauthorized SSH/Winbox" \
    dst-port=22,8291 in-interface-list=WAN protocol=tcp src-address-list=\
    !safe_ips
add action=drop chain=prerouting comment="drop brute forcers via RAW" \
    in-interface-list=WAN src-address-list=brutef-blacklist
add action=drop chain=prerouting comment="Drop packets to bogon networks" \
    dst-address-list=no_forward_ipv4
/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set h323 disabled=yes
set sip disabled=yes
set rtsp disabled=no
/ip route
add disabled=yes dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=to_WAN2
add disabled=yes dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=to_WAN3
add distance=1 dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=main
add disabled=yes dst-address=0.0.0.0/0 gateway=5.44.1.1 routing-table=to_WAN1
/ipv6 route
add disabled=yes distance=1 dst-address=2000::/3 gateway=2001:470:f2f0::1 \
    scope=30 target-scope=10
add dst-address=::/0 gateway=2001:470:f2f0::1
add disabled=no distance=1 dst-address=2000::/3 gateway=2001:470:c:afb::1 \
    scope=30 target-scope=10
/ip service
set ftp disabled=yes
set telnet disabled=yes
set www disabled=yes
set www-ssl certificate=my-cert disabled=no
set api disabled=yes
/ipv6 address
add address=2001:470:c:afb::2 advertise=no interface=6to4-HE
add address=2001:470:d:afd::1 comment="/64 defalt block from HE" disabled=yes \
    interface=HomeLAN
add address=2001:470:f2f0:111::1 interface=HomeLAN
add address=2001:470:f2f0:222::1 disabled=yes interface=LAN
/ipv6 firewall address-list
add address=ai.google.com comment="from service-ipv4" list=to-HE
add address=gemini.google.com comment="from service-ipv4" list=to-HE
add address=googleapis.com comment="from service-ipv4" list=to-HE
add address=google.com comment="from service-ipv4" list=to-HE
add address=accounts.google.com comment="from service-ipv4" list=to-HE
add address=antigravity.google.com comment="from service-ipv4" list=to-HE
add address=chatgpt.com comment="from service-ipv4" list=to-HE
add address=aistudio.google.com comment="from service-ipv4" list=to-HE
/ipv6 firewall filter
add action=accept chain=input comment="Allow established/related" \
    connection-state=established,related,untracked
add action=drop chain=input comment="Drop invalid" connection-state=invalid
add action=accept chain=input comment="Accept local traffic" in-interface=\
    HomeLAN
add action=drop chain=input comment="Drop everything else from 6to4-HE" \
    in-interface=6to4-HE
add action=accept chain=forward comment="Accept established, related" \
    connection-state=established,related
add action=drop chain=forward comment="Drop invalid" connection-state=invalid
add action=accept chain=forward comment="Accept ICMPv6 forward" protocol=\
    icmpv6
add action=accept chain=forward comment="Allow local to 6to4-HE" \
    out-interface=6to4-HE
add action=drop chain=forward comment=\
    "Drop ALL unsolicited traffic from 6to4-HE to all LANs" connection-state=\
    new in-interface=6to4-HE
/ipv6 firewall mangle
add action=mark-routing chain=prerouting disabled=yes dst-address-list=to-HE \
    new-routing-mark=to-he-ipv6 passthrough=no
/ipv6 nd
add advertise-dns=yes interface=HomeLAN managed-address-configuration=yes
/system clock
set time-zone-autodetect=no
/system clock manual
set time-zone=+05:00
/system identity
set name="Galactic New"
/system ntp client
set enabled=yes
/system ntp client servers
add address=31.28.161.68
add address=79.142.192.4
