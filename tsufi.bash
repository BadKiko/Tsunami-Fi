clear
printf '\e[8;33;65t'
printf "
                     ██████████████████████
               ██████████████████████████████████
           ██████████████              ██████████████
        ██████████                            ██████████
     █████████                                    █████████
   ████████                  ██████                  ████████
  ██████             ██████████████████████             ██████
   ███           ██████████████████████████████           ███
              ██████████                ██████████
           ████████                         █████████
          ██████                               ███████
           ███            ████████████            ███
                      ████████████████████
                   ███████████    ███████████
                  ███████              ███████
                   ███                    ███

                            ████████
                           ██████████
                           ██████████
                            ████████
" | lolcat -S 45 -p 200
printf "
 ▄▄▄▄▄▄▄▄                                ▄▄▄▄▄▄▄▄     ██
 ▀▀▀██▀▀▀                                ██▀▀▀▀▀▀     ▀▀
    ██     ▄▄█████▄  ██    ██            ██         ████
    ██     ██▄▄▄▄ ▀  ██    ██            ███████      ██
    ██      ▀▀▀▀██▄  ██    ██   █████    ██           ██
    ██     █▄▄▄▄▄██  ██▄▄▄███            ██        ▄▄▄██▄▄▄
    ▀▀      ▀▀▀▀▀▀    ▀▀▀▀ ▀▀            ▀▀        ▀▀▀▀▀▀▀▀
" | lolcat -S 45 -p 10
sleep 1.5

if (( $(id -u) != 0 )); then #Если запущено без root
clear
printf "\x1b[1;33m\n\nПерезапустите скрипт с правами суперпоользователя! (sudo)\n\n\x1b[0m"
exit 0
fi

while true
do
clear
printf '\e[8;21;53t'
printf "\x1b[1;33m-----# \x1b[1;32mДобро пожаловать в Tsu-Fi \x1b[1;33m#-----\x1b[0m"
printf "\x1b[1;33m\n\nВыберите Wi-Fi адаптер:\n\n\x1b[0m"
idname=(null)
nets=0
for iface in $(ls /sys/class/net/)
do
idname+=($iface)
let "nets+=1"
echo -e "\x1b[1;33m$nets) $iface"
done
let "nets+=1"
printf "\n\x1b[1;32m$nets) Выйти\n\n\x1b[1;32mTSU-FI> \x1b[1;33m"
read adapchoose



if (( "$adapchoose" <= "$nets" )); then
case $adapchoose in
$nets)
exit 0
;;
*) #если введено с клавиатуры то, что в case не описывается, выполнять следующее:
break
esac #окончание оператора case.
fi
done

wificard=${idname[$adapchoose]}

#Вывод в консоль информации
while true
do
clear
iwm=$(iwconfig $wificard | grep Mode)
wifimode=$(echo $iwm | cut -d: -f 2 | cut -d ' ' -f 1)
echo -e  "\x1b[1;33m* \x1b[1;32mВы выбрали интерфейс: \x1b[1;33m$wificard | Режим: $wifimode\x1b[0m"
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 1" ]]; then #Если включен IP-Forwarding укажем на это
echo -e  "\x1b[1;33m* \x1b[1;32mIP-Forwarding включен\x1b[0m"
fi
if [[ "$(iptables -t nat -L PREROUTING | grep REDIRECT | cut -d ' ' -f 1,35,36,37,38)" != "" ]]; then
echo -e "\x1b[1;33m* \x1b[1;32m$(iptables -t nat -L PREROUTING | grep REDIRECT | cut -d ' ' -f 1,35,36,37,38)\x1b[0m"
fi



echo -e  "\x1b[1;33m\n0)\x1b[1;32m Выйти из скрипта.\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e "\x1b[1;33m<Работа с адаптером>"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m1)\x1b[1;32m Сменить интерфейс.\x1b[0m"
if [[ $wifimode == "Managed" ]]; then
echo -e  "\x1b[1;33m2)\x1b[1;32m Перевести интерфейс в режим монитора.\x1b[0m"
fi
if [[ $wifimode == "Monitor" ]]; then
echo -e  "\x1b[1;33m2)\x1b[1;32m Перевести интерфейс в управляемый режим.\x1b[0m"
fi
echo -e "\x1b[1;33m---------------------------------------------"
echo -e "\x1b[1;33m<MITM>"
echo -e "\x1b[1;33m---------------------------------------------"
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 0" ]]; then
echo -e  "\x1b[1;33m3)\x1b[1;32m Включить IP-Forwarding.\x1b[0m"
fi
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 1" ]]; then
echo -e  "\x1b[1;33m3)\x1b[1;32m Выключить IP-Forwarding.\x1b[0m"
fi
echo -e  "\x1b[1;33m4)\x1b[1;32m Redirect портов.\x1b[0m"
echo -e  "\x1b[1;33m5)\x1b[1;32m Запустить Ettercap.\x1b[0m"

printf "\x1b[1;32m\nTSU-FI> \x1b[1;33m"
read choose


#CASE
case $choose in
0)
clear
echo -e "\x1b[1;33m---Выходим---"
exit 0
;;
1) # Выбрать другой интерфейс



while true
do
clear
printf '\e[8;21;53t'
printf "\x1b[1;33m-----# \x1b[1;32mДобро пожаловать в Tsu-Fi \x1b[1;33m#-----\x1b[0m"
printf "\x1b[1;33m\n\nВыберите Wi-Fi адаптер:\n\n\x1b[0m"
idname=(null)
nets=0
for iface in $(ls /sys/class/net/)
do
idname+=($iface)
let "nets+=1"
echo -e "\x1b[1;33m$nets) $iface"
done
let "nets+=1"
printf "\n\x1b[1;32m$nets) Выйти\n\n\x1b[1;32mTSU-FI> \x1b[1;33m"
read adapchoose



if (( "$adapchoose" <= "$nets" )); then
case $adapchoose in
$nets)
exit 0
;;
*) #если введено с клавиатуры то, что в case не описывается, выполнять следующее:
break
esac #окончание оператора case.
fi
done

wificard=${idname[$adapchoose]}
clear
;;
2)#Monitor or managed mode
if [[ $wifimode == "Monitor" ]]; then
clear
echo -e "\x1b[1;33m---Переводим интерфейс в управляемый режим---"
ifconfig $wificard down && iwconfig $wificard mode managed && ifconfig $wificard up
systemctl start NetworkManager
sleep 1
fi
if [[ $wifimode == "Managed" ]]; then
clear
echo -e "\x1b[1;33m---Переводим интерфейс в режим монитора---"
ifconfig $wificard down && iwconfig $wificard mode monitor && ifconfig $wificard up
echo -e "\x1b[1;33m---Отключаем процессы которые могут помешать интерфейсу---"
airmon-ng check kill
sleep 1
fi
;;
3)#Ip-Forwarding
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 0" ]]; then
sysctl -w net.ipv4.ip_forward=1
continue
fi
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 1" ]]; then
sysctl -w net.ipv4.ip_forward=0
continue
fi
;;
4)
while true
do
clear
iwm=$(iwconfig $wificard | grep Mode)
wifimode=$(echo $iwm | cut -d: -f 2 | cut -d ' ' -f 1)
echo -e  "\x1b[1;33m[Главное меню] > \x1b[1;32m[Redirect портов]\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m* \x1b[1;32mВы выбрали интерфейс: \x1b[1;33m$wificard | Режим: $wifimode\x1b[0m"
if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 1" ]]; then #Если включен IP-Forwarding укажем на это
echo -e  "\x1b[1;33m* \x1b[1;32mIP-Forwarding включен\x1b[0m"
fi
if [[ "$(iptables -t nat -L PREROUTING | grep REDIRECT | cut -d ' ' -f 1,35,36,37,38)" != "" ]]; then
echo -e "\x1b[1;33m* \x1b[1;32m$(iptables -t nat -L PREROUTING | grep REDIRECT | cut -d ' ' -f 1,35,36,37,38)\x1b[0m"
fi

echo -e  "\x1b[1;33m\n0)\x1b[1;32m Вернуться в главное меню.\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m1)\x1b[1;32m Перенаправить HTTP на указанный порт.\x1b[0m"
echo -e  "\x1b[1;33m2)\x1b[1;32m Удалить все правила.\x1b[0m"
echo -e  "\x1b[1;33m3)\x1b[1;32m Удалить определенные правила.\x1b[0m"
printf "\x1b[1;32m\nTSU-FI> \x1b[1;33m"
read redirectchoose
case $redirectchoose in
0)
break
;;
1) #HTTP REDIRECT
while true
do
clear
printf '\e[8;21;80t'
echo -e  "\x1b[1;33m[Главное меню] > [Redirect портов] > \x1b[1;32m[HTTP Redirect]\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m0)\x1b[1;32m Вернуться в Redirect портов.\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m* \x1b[1;32m Укажите порт на который будет перенаправлен HTTP трафик.\x1b[0m"
printf "\x1b[1;32m\nTSU-FI> \x1b[1;33m"
read httpnewport
case $httpnewport in
0)
break
;;
''|*[0-9]*)
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $httpnewport
echo -e "\x1b[1;33m---REDIRECT 80 PORT >> 8080 PORT---"
break
esac
done
;;
2)#DELETE ALL
clear
sudo iptables -t nat -F
;;
3)
while true
do
clear
printf '\e[8;21;80t'
echo -e  "\x1b[1;33m[Главное меню] > [Redirect портов] > \x1b[1;32m[Удаление определенного правила]\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m\n0)\x1b[1;32m Вернуться в Redirect портов.\x1b[0m"
echo -e "\x1b[1;33m---------------------------------------------"
echo -e  "\x1b[1;33m* \x1b[1;32m Укажите номер правила которое будет удалено:\x1b[1;33m"
if [[ "$(iptables -t nat -L PREROUTING --line-numbers | grep REDIRECT | cut -d ' ' -f 1,5,38-50)" != "" ]]; then
echo -e "\n$(iptables -t nat -L PREROUTING --line-numbers | grep REDIRECT | cut -d ' ' -f 1,5,38-50)\n"
else
echo -e  "\n\x1b[1;31m! \x1b[1;32m Правил не обнаружено\n\x1b[1;33m"
fi
printf "\x1b[1;32mTSU-FI> \x1b[1;33m"
read deleterule
case $deleterule in
0)
break
;;
''|*[0-9]*)
iptables -t nat -D PREROUTING $deleterule
break
esac
done
esac
done
;;
5)
ettercap -G &
sleep 0.1
esac
done
