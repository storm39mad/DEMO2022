# DEMO2022

# Образец задания
Образец задания для демонстрационного экзамена по комплекту оценочной
документации.

# Описание задания
## Модуль 1
Вариант 1-0 (публичный)

![Untitled Diagram-Page-9 drawio (1)](https://user-images.githubusercontent.com/79700810/149122755-73e58784-a1f7-4df9-b685-d81e473f26a3.png)

## Виртуальные машины и коммутация.
Необходимо выполнить создание и базовую конфигурацию виртуальных
машин.

1. На основе предоставленных ВМ или шаблонов ВМ создайте отсутствующие виртуальные машины в соответствии со схемой.  

    a.	Характеристики ВМ установите в соответствии с Таблицей 1;
  
    b.	Коммутацию (если таковая не выполнена) выполните в соответствии со схемой сети.

2. Имена хостов в созданных ВМ должны быть установлены в соответствии со схемой.

3. Адресация должна быть выполнена в соответствии с Таблицей 1;

4. Обеспечьте ВМ дополнительными дисками, если таковое необходимо в соответствии с Таблицей 1;

## Таблица 1. Характеристики ВМ

|Name VM         |ОС                  |RAM             |CPU             |IP                    |Additionally                       |
|  ------------- | -------------      | -------------  |  ------------- |  -------------       |  -------------                    |  
|RTR-L           |Debian 11/CSR       |2 GB            |2/4             |4.4.4.100/24          |                                   |
|                |                    |                |                |192.168.100.254/24    |                                   |
|RTR-R           |Debian 11/CSR       |2 GB            |2/4             |5.5.5.100/24          |                                   |
|                |                    |                |                |172.16.100.254 /24    |                                   |
|SRV             |Debian 11/Win 2019  |2 GB /4 GB      |2/4             |192.168.100.200/24    |Доп диски 2 шт по 2 GB             |
|WEB-L           |Debian 11           |2 GB            |2               |192.168.100.100/24    |                                   |
|WEB-R           |Debian 11           |2 GB            |2               |172.16.100.100/24     |                                   |
|ISP             |Debian 11           |2 GB            |2               |4.4.4.1/24            |                                   |
|                |                    |                |                |5.5.5.1/24            |                                   |
|                |                    |                |                |3.3.3.1/24            |                                   |
|CLI             |Win 10              |4 GB            |4               |3.3.3.10/24           |                                   |


## Имена хостов в созданных ВМ должны быть установлены в соответствии со схемой.
## RTR-L

```cisco
en
conf t
hostname RTR-L-XX
do wr
```

![image](https://user-images.githubusercontent.com/79700810/149130676-f87df5f2-ff68-42f9-9ad6-12397ffa7da1.png)

## RTR-R

```cisco
en
conf t
hostname RTR-R-XX
do wr
```
![image](https://user-images.githubusercontent.com/79700810/149131854-405305c4-0836-45f3-84d2-216de66648bb.png)

## SRV

```powershell
Rename-Computer -NewName SRV-XX
```

![image](https://user-images.githubusercontent.com/79700810/149132196-2d6adb20-5d45-4b81-bb11-c7f2a9e4091a.png)

## WEB-L

```debian
hostnamectl set-hostname WEB-L-XX
```

![image](https://user-images.githubusercontent.com/79700810/149132399-17daa67d-9e3a-4ed9-ac7f-a16ceb841839.png)

## WEB-R

```debian
hostnamectl set-hostname WEB-R-XX
```

![image](https://user-images.githubusercontent.com/79700810/149132565-36c043eb-5a6f-48a1-89e4-2d98929a2af6.png)

## ISP

```debian
hostnamectl set-hostname ISP-XX
```

![image](https://user-images.githubusercontent.com/79700810/149132932-73fa60e9-37ce-448c-8a7b-a1176f9ac814.png)

## CLI

```powershell
Rename-Computer -NewName CLI-XX
```

![image](https://user-images.githubusercontent.com/79700810/149140416-38cb1f3d-5be7-461d-a833-c1301d4e06a8.png)


## Адресация должна быть выполнена в соответствии с Таблицей 1;
## RTR-L
```cisco
int gi 1
ip address 4.4.4.100 255.255.255.0
no sh

int gi 2
ip address 192.168.100.254 255.255.255.0
no sh
end
wr
```

![image](https://user-images.githubusercontent.com/79700810/149131532-441bf23b-1cc1-443a-90e5-6fd6863248bb.png)

## RTR-R

```cisco
int gi 1
ip address 5.5.5.100 255.255.255.0
no sh
int gi 2
ip address 172.16.100.254 255.255.255.0
no sh
end
wr
```
![image](https://user-images.githubusercontent.com/79700810/149136014-1b7f6173-e5c7-404e-ac77-120f11947809.png)

## SRV

```powershell
$GetIndex = Get-NetAdapter
New-NetIPAddress -InterfaceIndex $GetIndex.ifIndex -IPAddress 192.168.100.200 -PrefixLength 24 -DefaultGateway 192.168.100.254
Set-DnsClientServerAddress -InterfaceIndex $GetIndex.ifIndex -ServerAddresses ("192.168.100.200","4.4.4.1")
```

![image](https://user-images.githubusercontent.com/79700810/149136645-da7a2f8c-a223-4961-aeb6-a4276bbe4b6d.png)

## WEB-L

```debian
apt-cdrom add
apt install -y network-manager
nmcli connection show
nmcli connection modify Wired\ connection\ 1 conn.autoconnect yes conn.interface-name ens192 ipv4.method manual ipv4.addresses '192.168.100.100/24' ipv4.dns 192.168.100.200 ipv4.gateway 192.168.100.254
```
![image](https://user-images.githubusercontent.com/79700810/149137520-04fb65d6-ac34-4e2f-a4d8-f6eed3011574.png)

## WEB-R

```debian
apt-cdrom add
apt install -y network-manager
nmcli connection show
nmcli connection modify Wired\ connection\ 1 conn.autoconnect yes conn.interface-name ens192 ipv4.method manual ipv4.addresses '172.16.100/24' ipv4.dns 5.5.5.1 ipv4.gateway 172.16.100.254
```

![image](https://user-images.githubusercontent.com/79700810/149138018-65de91c7-6431-45fe-884b-a7edf32201df.png)

## ISP

```debian
apt-cdrom add
apt install -y network-manager bind9 chrony 
nmcli connection show
nmcli connection modify Wired\ connection\ 1 conn.autoconnect yes conn.interface-name ens192 ipv4.method manual ipv4.addresses '3.3.3.1/24'
nmcli connection modify Wired\ connection\ 2 conn.autoconnect yes conn.interface-name ens224 ipv4.method manual ipv4.addresses '4.4.4.1/24'
nmcli connection modify Wired\ connection\ 3 conn.autoconnect yes conn.interface-name ens256 ipv4.method manual ipv4.addresses '5.5.5.1/24'
```

![image](https://user-images.githubusercontent.com/79700810/149140670-2d614562-4038-4103-ad34-49044058eff0.png)


## CLI

```powershell
$GetIndex = Get-NetAdapter
New-NetIPAddress -InterfaceIndex $GetIndex.ifIndex -IPAddress 3.3.3.10 -PrefixLength 24 -DefaultGateway 3.3.3.1
Set-DnsClientServerAddress -InterfaceIndex $GetIndex.ifIndex -ServerAddresses ("3.3.3.1")
```

![image](https://user-images.githubusercontent.com/79700810/149141167-2233dd9d-3bb8-46eb-b00e-2c8aae2b09a5.png)

## Сетевая связность.
В рамках данного модуля требуется обеспечить сетевую связность между
регионами работы приложения, а также обеспечить выход ВМ в имитируемую
сеть “Интернет”. 

## ISP forward

nano /etc/sysctl.conf

   net.ipv4.ip_forward=1


## RTR-L-XX Gitw


ip route 0.0.0.0 0.0.0.0 4.4.4.1

## RTR-R-XX gitw

ip route 0.0.0.0 0.0.0.0 5.5.5.1

## RTR-L-XX GRE

interface Tunne 1
ip address 172.16.1.1 255.255.255.0
tunnel mode gre ip
tunnel source 4.4.4.100
tunnel destination 5.5.5.100

## RTR-R-XX GRE

interface Tunne 1
ip address 172.16.1.2 255.255.255.0
tunnel mode gre ip
tunnel source 5.5.5.100
tunnel destination 4.4.4.100


## NAT
на внутр. интерфейсе - ip nat inside
на внешн. интерфейсе - ip nat outside

## RTR-L-XX NAT


int gi 1
ip nat outside

int gi 2
ip nat inside

access-list 1 permit 192.168.100.0 0.0.0.255
ip nat inside source list 1 interface Gi1 overload

## RTR-R-XX NAT

int gi 1
ip nat outside

int gi 2
ip nat inside

access-list 1 permit 172.16.100.0 0.0.0.255
ip nat inside source list 1 interface Gi1 overload


## RTR-L-XX

crypto isakmp policy 1
encr aes
authentication pre-share
hash sha256
group 14
!
crypto isakmp key TheSecretMustBeAtLeast13bytes address 5.5.5.100
crypto isakmp nat keepalive 5
!
crypto ipsec transform-set TSET  esp-aes 256 esp-sha256-hmac
mode tunnel
!
crypto ipsec profile VTI
set transform-set TSET

interface Tunnel1
tunnel mode ipsec ipv4
tunnel protection ipsec profile VTI

## RTR-R-XX

conf t

crypto isakmp policy 1
encr aes
authentication pre-share
hash sha256
group 14
!
crypto isakmp key TheSecretMustBeAtLeast13bytes address 4.4.4.100
crypto isakmp nat keepalive 5
!
crypto ipsec transform-set TSET  esp-aes 256 esp-sha256-hmac
mode tunnel
!
crypto ipsec profile VTI
set transform-set TSET

interface Tunnel1
tunnel mode ipsec ipv4
tunnel protection ipsec profile VTI

## rtr-l-xx

ip access-list extended L
permit tcp any any eq 53
permit udp any any eq 53
permit tcp any any eq 80
permit tcp any any eq 443
permit tcp any any eq echo
permit tcp any any eq 22
permit icmp any any

int gi 1
ip access-group L in

## rtr-r-xx
ip access-list extended R
permit tcp any any eq 53
permit udp any any eq 53
permit tcp any any eq 80
permit tcp any any eq 443
permit tcp any any eq echo
permit tcp any any eq 22
permit icmp any any
