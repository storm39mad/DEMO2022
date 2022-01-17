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
## RTR-L-XX
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

## RTR-R-XX

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

## SRV-XX

```powershell
$GetIndex = Get-NetAdapter
New-NetIPAddress -InterfaceIndex $GetIndex.ifIndex -IPAddress 192.168.100.200 -PrefixLength 24 -DefaultGateway 192.168.100.254
Set-DnsClientServerAddress -InterfaceIndex $GetIndex.ifIndex -ServerAddresses ("192.168.100.200","4.4.4.1")
```

![image](https://user-images.githubusercontent.com/79700810/149136645-da7a2f8c-a223-4961-aeb6-a4276bbe4b6d.png)

## WEB-L-XX

```debian
apt-cdrom add
apt install -y network-manager
nmcli connection show
nmcli connection modify Wired\ connection\ 1 conn.autoconnect yes conn.interface-name ens192 ipv4.method manual ipv4.addresses '192.168.100.100/24' ipv4.dns 192.168.100.200 ipv4.gateway 192.168.100.254
```
![image](https://user-images.githubusercontent.com/79700810/149137520-04fb65d6-ac34-4e2f-a4d8-f6eed3011574.png)

## WEB-R-XX

```debian
apt-cdrom add
apt install -y network-manager
nmcli connection show
nmcli connection modify Wired\ connection\ 1 conn.autoconnect yes conn.interface-name ens192 ipv4.method manual ipv4.addresses '172.16.100/24' ipv4.dns 5.5.5.1 ipv4.gateway 172.16.100.254
```

![image](https://user-images.githubusercontent.com/79700810/149138018-65de91c7-6431-45fe-884b-a7edf32201df.png)

## ISP-XX

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

router eigrp 6500
network 192.168.0.0 0.0.255.255
network 172.16.0.0 0.0.0.255
## RTR-R-XX GRE

interface Tunne 1
ip address 172.16.1.2 255.255.255.0
tunnel mode gre ip
tunnel source 5.5.5.100
tunnel destination 4.4.4.100

router eigrp 6500
network 192.168.0.0 0.0.255.255
network 172.16.0.0 0.0.0.255

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



## SSH RTR-L-XX
ip nat inside source static tcp 192.168.100.100 22 4.4.4.100 2222






## SSH RTR-R-XX
ip nat inside source static tcp 172.16.100.100 22 5.5.5.100 2244

## SSH WEB-L-XX

apt-cdrom add
apt install -y openssh-server ssh
systemctl start sshd
systemctl enable ssh

## SSH WEB-R-XX

apt-cdrom add
apt install -y openssh-server ssh
systemctl start sshd
systemctl enable ssh


## Инфраструктурные службы




## ISP

|Zone            |Type                |Key             |Meaning         |
|  ------------- | -------------      | -------------  |  ------------- |
| demo.wsr       | A                  | isp            | 3.3.3.1        |
|                | A                  | www            | 4.4.4.100      |
|                | A                  | www            | 5.5.5.100      |
|                | CNAME              | internet       | isp            |
|                | NS                 | int            | rtr-l-xx.demo.wsr      |
|                | A                  | rtr-l-xx       | 4.4.4.100      |
apt-cdrom add
apt install -y bind9

mkdir /opt/dns
cp /etc/bind/db.local /opt/dns/demo.db
chown -R bind:bind /opt/dns
nano /etc/apparmor.d/usr.sbin.named
```
    /opt/dns/** rw,
```

systemctl restart apparmor.service

nano /etc/bind/named.conf.default-zones
```
zone "demo.wsr" {
   type master;
   allow-transfer { any; };
   file "/opt/dns/demo.db";
};
```

nano /opt/dns/demo.db
```
@ IN SOA demo.wsr. root.demo.wsr.(
```

```
@ IN NS isp-xx.demo.wsr.
isp-xx IN A 3.3.3.1
www IN 4.4.4.100
www IN 5.5.5.100
internet CNAME isp-xx.demo.wsr.
int IN NS rtr-l-xx.demo.wsr
rtr-l-xx IN  A 4.4.4.100
```



systemctl restatr bind9


## RTR-L-XX

ip nat inside source static tcp 192.168.100.200 53 4.4.4.100 53

ip nat inside source static udp 192.168.100.200 53 4.4.4.100 53



## SRV

Install-WindowsFeature -Name DNS -IncludeManagementTools

Add-DnsServerPrimaryZone -Name "int.demo.wsr" -ZoneFile "int.demo.wsr.dns"

|Zone            |Type                |Key             |Meaning         |
|  ------------- | -------------      | -------------  |  ------------- |
| int.demo.wsr   | A                  | web-l-xx           | 192.168.100.100        |
|                | A                  | web-r-xx            | 172.16.100.100      |
|                | A                  | srv-xx            | 192.168.100.200      |
|                | A                  | rtr-l-xx            | 192.168.100.254      |
|                | A                  | rtr-r-xx           | 172.16.100.254 |
|                | CNAME              | webapp        | web-l-xx            |
|                | CNAME              | webapp       | web-r-xx            |
|                | CNAME              | ntp       | srv-xx            |
|                | CNAME              | dns       | srv-xx           |




Add-DnsServerResourceRecordA -Name "web-l-xx" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "192.168.1.100"
Add-DnsServerResourceRecordA -Name "web-r-xx" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "172.16.100.100" 
Add-DnsServerResourceRecordA -Name "srv-xx" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "192.168.100.200" 
Add-DnsServerResourceRecordA -Name "rtr-l-xx" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "192.168.100.254" 
Add-DnsServerResourceRecordA -Name "rtr-r-xx" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "172.16.100.254" 

Add-DnsServerResourceRecordCName -Name "webapp" -HostNameAlias "web-l-xx.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "webapp" -HostNameAlias "web-r-xx.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "ntp" -HostNameAlias "srv-xx.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "dns" -HostNameAlias "srv-xx.int.demo.wsr" -ZoneName "int.demo.wsr"

## ISP NTP

apt install -y chrony 

nano /etc/chrony.conf

local stratum 4
allow 4.4.4.0/24

systemctl restart chronyd 


## SRV NTP

New-NetFirewallRule -DisplayName "NTP" -Direction Inbound -LocalPort 123 -Protocol UDP -Action Allow

w32tm /query /status
Start-Service W32Time
w32tm /config /manualpeerlist:4.4.4.1 /syncfromflags:manual /reliable:yes /update
Restart-Service W32Time

## CLI NTP

New-NetFirewallRule -DisplayName "NTP" -Direction Inbound -LocalPort 123 -Protocol UDP -Action Allow
Start-Service W32Time
w32tm /config /manualpeerlist:4.4.4.1 /syncfromflags:manual /reliable:yes /update
Restart-Service W32Time

![image](https://user-images.githubusercontent.com/79700810/149523036-1db4eeca-ca6b-491a-9d19-d6c097a7ca80.png)

## RTR-L-XX NTP

SRV

Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Any


ip domain name int.demo.wsr
ip name-server 192.168.100.200

ntp server ntp.int.demo.wsr

## WEB-L-XX NTP

apt-cdrom add

apt install -y chrony 

nano /etc/chrony/chrony.conf

pool ntp.int.demo.wsr iburst

allow 192.168.100.0/24

systemctl restart chrony
## RTR-R-XX NTP

ip domain name int.demo.wsr
ip name-server 192.168.100.200

ntp server ntp.int.demo.wsr

## WEB-R-XX NTP

apt-cdrom add

apt install -y chrony 

nano /etc/chrony/chrony.conf

pool ntp.int.demo.wsr iburst

allow 192.168.100.0/24

systemctl restart chrony


## SRV RAID

get-disk

set-disk -Number 1 -IsOffline $false
set-disk -Number 2 -IsOffline $false

New-StoragePool -FriendlyName "POOLRAID1" -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks (Get-PhysicalDisk -CanPool $true)

New-VirtualDisk -StoragePoolFriendlyName "POOLRAID1" -FriendlyName "RAID1" -ResiliencySettingName Mirror -UseMaximumSize

Initialize-Disk -FriendlyName "RAID1"

New-Partition -DiskNumber 3 -UseMaximumSize -DriveLetter R

Format-Volume -DriveLetter R

## SRV NFS

Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools

Install-WindowsFeature -Name FS-NFS-Service -IncludeManagementTools

New-Item -Path R:\storage -ItemType Directory


New-NfsShare -Path "R:\shares" -Name nfs -Permission Readwrite




## WEB-L-XX nfs

apt-cdrom add
apt -y install nfs-common

nano /etc/fstab

    #<file system>
    srv-xx.int.demo.wsr:/nfs /opt/share nfs defaults,_netdev 0 0

mkdir /opt/share
mount -a


## WEB-R-XX nfs

apt-cdrom add
apt -y install nfs-common

nano /etc/fstab

    #<file system>
    srv-xx.int.demo.wsr:/nfs /opt/share nfs defaults,_netdev 0 0

mkdir /opt/share
mount -a


## SRV-XX ADCS

Install-WindowsFeature -Name AD-Certificate, ADCS-Web-Enrollment -IncludeManagementTools

Install-AdcsCertificationAuthority -CAType StandaloneRootCa -CACommonName "Demo.wsr" -force

Install-AdcsWebEnrollment -Confirm -force

## Инфраструктура веб-приложения.

## WEB-L-XX Doc

apt-cdrom add

apt install -y docker-ce
systemctl start docker
systemctl enable docker


mkdir /mnt/app

mount /dev/sr1 /mnt/app

docker load < /mnt/app/app.tar

docker images
docker run --name app  -p 8080:80 -d app
docker ps
## WEB-R-XX Doc

apt-cdrom add

apt install -y docker-ce
systemctl start docker
systemctl enable docker


mkdir /mnt/app

mount /dev/sr1 /mnt/app

docker load < /mnt/app/app.tar

docker images
docker run --name app  -p 8080:80 -d app
docker ps

## RTR-L-XX

no ip http secure-server
wr
reload

ip nat inside source static tcp 192.168.100.100 80 4.4.4.100 80 
ip nat inside source static tcp 192.168.100.100 443 4.4.4.100 443 

## RTR-R-XX

no ip http secure-server
wr
reload

ip nat inside source static tcp 172.16.100.100 80 5.5.5.100 80 
ip nat inside source static tcp 172.16.100.100 443 5.5.5.100 443 

## SRV ssl

![image](https://user-images.githubusercontent.com/79700810/149763282-2b6d46b0-836a-450d-84ba-8f25bc488157.png)

![image](https://user-images.githubusercontent.com/79700810/149763302-ed88dc08-9bd7-4a15-8a47-59bc5ee92649.png)

![image](https://user-images.githubusercontent.com/79700810/149766791-01f84de0-d512-4693-942a-1ab0855254a1.png)

![image](https://user-images.githubusercontent.com/79700810/149763486-8c0dfe06-400f-421c-abe2-d63678ae0418.png)

![image](https://user-images.githubusercontent.com/79700810/149763513-cb821774-83ce-40f9-a47d-eaa3941504a5.png)

![image](https://user-images.githubusercontent.com/79700810/149763553-5a666a1c-6069-4022-9e20-1e3041d345b7.png)

![image](https://user-images.githubusercontent.com/79700810/149763685-b0dfb33e-ed50-4de6-937c-1aab86524df9.png)


![image](https://user-images.githubusercontent.com/79700810/149763717-75fa754c-4084-4923-acd8-7dc85201fdb1.png)


![image](https://user-images.githubusercontent.com/79700810/149763741-0e3281f3-b17b-4101-ad77-8dd21dfc7534.png)


![image](https://user-images.githubusercontent.com/79700810/149763772-8f7acb37-379f-455e-9198-1117317d73ed.png)

![image](https://user-images.githubusercontent.com/79700810/149763807-f91c2a81-d061-49bd-9b59-b93ae0e30ef3.png)




## WEB-L-XX ssl



cd /opt/share

openssl pkcs12 -nodes -nocerts -in www.pfx -out www.key

openssl pkcs12 -nodes -nokeys -in www.pfx -out www.cer

cp /opt/share /etc/nginx/www.key

cp /opt/share /etc/nginx/www.cer

![image](https://user-images.githubusercontent.com/79700810/149767553-c42bd433-0ebb-43dd-9256-abcd782c3e47.png)

/etc/nginx/sites-enabled/default

![image](https://user-images.githubusercontent.com/79700810/149767856-4de23e3a-cf68-4b51-9949-9aa22642644b.png)


systemctl reload nginx

## WEB-R-XX ssl

cd /opt/share

openssl pkcs12 -nodes -nocerts -in www.pfx -out www.key

openssl pkcs12 -nodes -nokeys -in www.pfx -out www.cer

cp /opt/share /etc/nginx/www.key

cp /opt/share /etc/nginx/www.cer

![image](https://user-images.githubusercontent.com/79700810/149767553-c42bd433-0ebb-43dd-9256-abcd782c3e47.png)

/etc/nginx/sites-enabled/default

![image](https://user-images.githubusercontent.com/79700810/149767856-4de23e3a-cf68-4b51-9949-9aa22642644b.png)


systemctl reload nginx

## SRV ssl

## WEB-R-XX ssl
ssh 

![image](https://user-images.githubusercontent.com/79700810/149774137-4c65faa7-a467-4b2f-a2ce-c1f6616f0c54.png)

![image](https://user-images.githubusercontent.com/79700810/149774186-c83b7b0a-5f67-41bb-9051-b26897840154.png)

## CLI-xx ssl

scp -P 2244 'root@5.5.5.100:/opt/share/ca.cer' C:\Users\Admin\Desktop\
![image](https://user-images.githubusercontent.com/79700810/149774248-784bebe3-8015-414f-88dc-e96f91dfd395.png)\


## rtr-l-xx ACL

ip access-list extended L
permit tcp any any eq 53
permit udp any any eq 53
permit tcp any any eq 80
permit tcp any any eq 443
permit tcp any any eq echo
permit tcp any any eq 2222
permit icmp any any
permit esp any any
permit udp host 5.5.5.100 host 4.4.4.100 eq 4500
permit udp host 5.5.5.100 host 4.4.4.100 eq 500

int gi 1
ip access-group L in

## rtr-r-xx ACL

ip access-list extended R
permit tcp any any eq 53
permit udp any any eq 53
permit tcp any any eq 80
permit tcp any any eq 443
permit tcp any any eq echo
permit tcp any any eq 2244
permit icmp any any
permit esp any any
permit udp host 4.4.4.100 host 5.5.5.100 eq 4500
permit udp host 5.5.5.100 host 4.4.4.100 eq 500

int gi 1
ip access-group R in



