# DEMO2022



# [Auto deploy azure terraform](https://github.com/storm39mad/DEMO2022/blob/main/azure/autodeploy/README.md/ )

# Образец задания
Образец задания для демонстрационного экзамена по комплекту оценочной
документации.

# Описание задания
# Модуль 1
Вариант 1-0 (публичный)

## Physical environment
![DEMO2022azure-Page-5 drawio (1)](https://user-images.githubusercontent.com/79700810/152940108-a33f9a43-91e4-4709-811a-215c52bff54b.png)

## Network environment
![DEMO2022azure-Page-8 drawio](https://user-images.githubusercontent.com/79700810/152974994-45982b32-42b3-4eff-a10d-f70b93988283.png)



## Виртуальные машины и коммутация.
Необходимо выполнить создание и базовую конфигурацию виртуальных
машин.

1. На основе предоставленных ВМ или шаблонов ВМ создайте отсутствующие виртуальные машины в соответствии со схемой.  
   -	Характеристики ВМ установите в соответствии с Таблицей 1;
   -	Коммутацию (если таковая не выполнена) выполните в соответствии со схемой сети.	 
2.  Имена хостов в созданных ВМ должны быть установлены в соответствии со схемой.
3.  Адресация должна быть выполнена в соответствии с Таблицей 1;
4.  Обеспечьте ВМ дополнительными дисками, если таковое необходимо в соответствии с Таблицей 1;

## Таблица 1. Характеристики ВМ

|Name VM         |ОС                  |Size            |CPU /RAM        |IP                  |Additionally                       |
|  ------------- | -------------      | -------------  |  ------------- |  -------------     |  -------------                    |  
|RTR-L           |Debian 11       |Standard B1s    |1/2             |10.0.1.5/24         |       public-ip                   |
|                |                    |                |                |10.0.2.5/24         |                                   |
|RTR-R           |Debian 11       |Standard B1s    |1/2             |172.16.1.5/24       |    public-ip                      |
|                |                    |                |                |172.16.2.5 /24      |                                   |
|SRV             |Win 2019  |Standard B2s      |2/4           |10.0.2.7/24         |Доп диски 2 шт по 5 GB             |
|WEB-L           |Debian 11          |Standard B2s    |2/4             |10.0.2.6/24        |                       |
|WEB-R           |Debian 11          |Standard B2s    |2/4             |172.16.2.6/24        |                       |
|ISP           |Debian 11          |Standard B1s    |1/2             |192.168.1.5/24        |        public-ip               |
|CLI             |Win 10              |Physical PS           |2/4               |any           |          internet                         |


### 1. На основе предоставленных ВМ или шаблонов ВМ создайте отсутствующие виртуальные машины в соответствии со схемой.
Убедитесь что все ВМ созданы в соотведствии со схемой

![image](https://user-images.githubusercontent.com/79700810/152943647-dd51a1cf-09a8-470b-a8b2-06a8011cc91a.png)

### 2.  Имена хостов в созданных ВМ должны быть установлены в соответствии со схемой.
При работе в Azure все имена будут сконфигурированы зарание
### 3.  Адресация должна быть выполнена в соответствии с Таблицей 1;
При работе в Azure все ip адреса будут сконфигурированы зарание

## Сетевая связность.
В рамках данного модуля требуется обеспечить сетевую связность между
регионами работы приложения, а также обеспечить выход ВМ в имитируемую
сеть “Интернет”

1. Сети, подключенные к ISP, считаются внешними:
   - Запрещено прямое попадание трафика из внутренних сетей во внешние и наоборот;
2. Платформы контроля трафика, установленные на границах регионов, должны выполнять трансляцию трафика, идущего из соответствующих внутренних сетей во внешние сети стенда и в сеть Интернет.
   - Трансляция исходящих адресов производится в адрес платформы,расположенный во внешней сети.    
3. Между платформами должен быть установлен защищенный туннель, позволяющий осуществлять связь между регионами с применением внутренних адресов.
   - Трафик, проходящий по данному туннелю, должен быть защищен:
     - Платформа ISP не должна иметь возможности просматривать содержимое пакетов, идущих из одной внутренней сети в другую.
   - Туннель должен позволять защищенное взаимодействие между платформами управления трафиком по их внутренним адресам
     - Взаимодействие по внешним адресам должно происходит без применения туннеля и шифрования
   - Трафик, идущий по туннелю между регионами по внутренним адресам, не должен транслироваться.
 4. Платформа управления трафиком RTR-L выполняет контроль входящего трафика согласно следующим правилам:
    - Разрешаются подключения к портам DNS, HTTP и HTTPS для всех клиентов;
      - Порты необходимо для работы настраиваемых служб
    - Разрешается работа выбранного протокола организации защищенной связи; 
      - Разрешение портов должно быть выполнено по принципу “необходимо и достаточно”
    - Разрешается работа протоколов ICMP;
    - Разрешается работа протокола SSH;
    - Прочие подключения запрещены;
    - Для обращений в платформам со стороны хостов, находящихся внутри регионов, ограничений быть не должно;
5. Платформа управления трафиком RTR-R выполняет контроль входящего трафика согласно следующим правилам:
   - Разрешаются подключения к портам HTTP и HTTPS для всех клиентов;
     - Порты необходимо для работы настраиваемых служб
   - Разрешается работа выбранного протокола организации защищенной связи;
     - Разрешение портов должно быть выполнено по принципу необходимо и достаточно”
   - Разрешается работа протоколов ICMP;
   - Разрешается работа протокола SSH;
   - Прочие подключения запрещены;
   - Для обращений в платформам со стороны хостов, находящихся внутри регионов, ограничений быть не должно;
6. Обеспечьте настройку служб SSH региона Left и Right:
   - Подключения со стороны внешних сетей по протоколу к платформе управления трафиком RTR-L на порт 2222 должны быть перенаправлены на ВМ Web-L;
   - Подключения со стороны внешних сетей по протоколу к платформе управления трафиком RTR-R на порт 2244 должны быть перенаправлены на ВМ Web-R;

### 1. Сети, подключенные к ISP, считаются внешними:

#### RTR-L
Подключаемся по ssh к public-ip RTR-L

```debian
sudo -i
```

```debian
  net.ipv4.ip_forward=1
```

```debian
sysctl -p
```

#### RTR-R
Подключаемся по ssh к public-ip RTR-R

```debian
sudo -i
```

```debian
  net.ipv4.ip_forward=1
```

```debian
sysctl -p
```


### 2. Платформы контроля трафика, установленные на границах регионов, должны выполнять трансляцию трафика, идущего из соответствующих внутренних сетей во внешние сети стенда и в сеть Интернет.

#### RTR-L

```debian
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

```debian
apt-get -y install iptables-persistent
```


#### RTR-R

```debian
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

```debian
apt-get -y install iptables-persistent
```

### 3. Между платформами должен быть установлен защищенный туннель, позволяющий осуществлять связь между регионами с применением внутренних адресов.

#### RTR-L 

```debian
apt install -y libreswan
```

```debian
nano /etc/ipsec.conf
```

```debian
conn mytunnel
    auto=start
    authby=secret
    type=tunnel
    ike=aes128-sha2;dh14
    ikev2=no
    phase2=esp
    pfs=no
    encapsulation=yes
    leftsubnet=0.0.0.0/0
    rightsubnet=0.0.0.0/0
    left=10.0.1.5
    right=<public-ip-RTR-R>
    rightid=172.16.1.5
    mark=5/0xffffffff
    vti-interface=vti01
    vti-routing=no
    vti-shared=yes
    leftvti=192.168.20.1/30
    rightvti=192.168.20.2/30

include /etc/ipsec.d/*.conf
```

```debian
nano /etc/ipsec.d/test.secrets
```

```debian
%any %any : PSK "TheSecretMustBeAtLeast13bytes"
```

```debian
systemctl restart ipsec.service
```

#### RTR-R


```debian
apt install -y libreswan
```

```debian
nano /etc/ipsec.conf
```

```debian
config setup
    listen=172.16.1.5

conn mytunnel
    auto=start
    authby=secret
    type=tunnel
    ike=aes128-sha2;dh14
    ikev2=no
    phase2=esp
    pfs=no
    encapsulation=yes
    leftsubnet=0.0.0.0/0
    rightsubnet=0.0.0.0/0
    left=<public-ip-RTR-L>
    leftid=10.0.1.5
    right=172.16.1.5
    mark=5/0xffffffff
    vti-interface=vti01
    vti-routing=no
    vti-shared=yes
    leftvti=192.168.20.1/30
    rightvti=192.168.20.2/30

include /etc/ipsec.d/*.conf
```
```debian
%any %any : PSK "TheSecretMustBeAtLeast13bytes"
```

```debian
systemctl restart ipsec.service
```
#### RTR-L

```debian
apt install -y frr
```

```debian
nano /etc/frr/daemons
```

```debian
eigrpd=yes
```

```debian
systemctl restart frr.service
systemctl enable frr
```

```debian
vtysh
```

```debian
conf t
router eigrp 6500
network 10.0.2.0/24 
network 192.168.20.0/30
do wr
```
#### RTR-R

```debian
apt install -y frr
```

```debian
nano /etc/frr/daemons
```

```debian
eigrpd=yes
```

```debian
systemctl restart frr.service
systemctl enable frr
```

```debian
vtysh
```

```debian
conf t
router eigrp 6500
network 172.16.2.0/24 
network 192.168.20.0/30
do wr
```

###  4. Платформа управления трафиком RTR-L выполняет контроль входящего трафика согласно следующим правилам:
#### RTR-L ACL

```debian
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2222 -j DNAT --to 10.0.2.6:22
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 10.0.2.6:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 10.0.2.6:443
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 53 -j DNAT --to 10.0.2.7:53
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to 10.0.2.7:3389
```

```debian
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 500 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 4500 -j ACCEPT
iptables -A INPUT -i eth0 -p esp  -j ACCEPT
iptables -A INPUT -i eth0 -p icmp -j ACCEPT
iptables -A INPUT -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i eth0 -j REJECT
```

### 5. Платформа управления трафиком RTR-R выполняет контроль входящего трафика согласно следующим правилам:

#### RTR-R ACL

```debian
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2244 -j DNAT --to 172.16.2.6:22
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 172.16.2.6:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 172.16.2.6:443
```

```debian
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 500 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 4500 -j ACCEPT
iptables -A INPUT -i eth0 -p esp  -j ACCEPT
iptables -A INPUT -i eth0 -p icmp -j ACCEPT
iptables -A INPUT -i eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i eth0 -j REJECT
```

### 6. Обеспечьте настройку служб SSH региона Left:
При работе в Azure служба ssh будет установлина и сконфигурирована


## Инфраструктурные службы

В рамках данного модуля необходимо настроить основные
инфраструктурные службы и настроить представленные ВМ на применение этих
служб для всех основных функций. 

1. Выполните настройку первого уровня DNS-системы стенда:
   - Используется ВМ ISP;
   - Обслуживается зона demo.wsr
     - Наполнение зоны должно быть реализовано в соответствии с Таблицей 2;
   - Сервер делегирует зону int.demo.wsr на SRV;
     - Поскольку SRV находится во внутренней сети западного региона, делегирование происходит на внешний адрес маршрутизатора данного региона. 
     - Маршрутизатор региона должен транслировать соответствующие порты DNS-службы в порты сервера SRV
   - Внешний клиент CLI должен использовать DNS-службу, развернутую на ISP, по умолчанию;
2. Выполните настройку второго уровня DNS-системы стенда;
   - Используется ВМ SRV;
   - Обслуживается зона int.demo.wsr;
     - Наполнение зоны должно быть реализовано в соответствии с Таблицей 2;
   - Обслуживаются обратные зоны для внутренних адресов регионов
     - Имена для разрешения обратных записей следует брать из Таблицы 2;
   - Сервер принимает рекурсивные запросы, исходящие от адресов внутренних регионов;
     - Обслуживание клиентов(внешних и внутренних),  обращающихся к к зоне int.demo.wsr, должно производится без каких либо ограничений по адресу источника;
   - Внутренние хосты регионов (равно как и платформы управления трафиком) должны использовать данную DNS-службу для разрешения всех запросов имен;
3. Выполните настройку первого уровня системы синхронизации времени:
   - Используется сервер ISP. 
   - Сервер считает собственный источник времени верным, stratum=4;
   - Сервер допускает подключение только через внешний адрес соответствующей платформы управления трафиком;
     - Подразумевается обращение SRV для синхронизации времени;
   - Клиент CLI должен использовать службу времени ISP;
4. Выполните конфигурацию службы второго уровня времени на SRV
   - Сервер синхронизирует время с хостом ISP;
     - Синхронизация с другими источникам запрещена;
   - Сервер должен допускать обращения внутренних хостов регионов, в том числе и платформ управления трафиком, для синхронизации времени;
   - Все внутренние хосты(в том числе и платформы управления трафиком) должны синхронизировать свое время с SRV;
5. Реализуйте файловый SMB-сервер на базе SRV
   - Сервер должен предоставлять доступ для обмена файлами серверам WEB-L и WEB-R;
   - Сервер, в зависимости от ОС, использует следующие каталоги для хранения файлов:
     - /mnt/storage для система на базе Linux;
     - Диск R:\ для систем на базе Windows;
   - Хранение файлов осуществляется на диске (смонтированном по указанным выше адресам), реализованном по технологии RAID типа “Зеркало”;
6. Сервера WEB-L и WEB-R должны использовать службу, настроенную на SRV, для обмена файлами между собой:
   - Служба файлового обмена должна позволять монтирование в виде стандартного каталога Linux
     - Разделяемый каталог должен быть смонтирован по адресу /opt/share;
   - Каталог должен позволять удалять и создавать файлы в нем для всех пользователей;
7. Выполните настройку центра сертификации на базе SRV:
   - В случае применения решения на базе Linux используется центр сертификации типа OpenSSL и располагается по адресу /var/ca
   - Выдаваемые сертификаты должны иметь срок жизни не менее 500 дней;
   - Параметры выдаваемых сертификатов:
     - Страна RU;
     - Организация DEMO.WSR;
     - Прочие поля (за исключением CN) должны быть пусты;


## Таблица 2. DNS-записи зон

|Zone            |Type                |Key             |Meaning         |
|  ------------- | -------------      | -------------  |  ------------- |
| demo.wsr       | A                  | isp            | public-ip-ISP        |
|                | A                  | www            |public-ip-RTR-L      |
|                | A                  | www            | public-ip-RTR-R     |
|                | CNAME              | internet       | isp            |
|                | NS                 | int            | rtr-l.demo.wsr      |
|                | A                  | rtr-l       | public-ip-RTR-L     |
   

### 1. Выполните настройку первого уровня DNS-системы стенда:

#### ISP

```debian
sudo -i
```
```debian
apt install -y bind9
```

```debian
mkdir /opt/dns
cp /etc/bind/db.local /opt/dns/demo.db
chown -R bind:bind /opt/dns
```

```debian
nano /etc/apparmor.d/usr.sbin.named
```
```debian
/opt/dns/** rw,
```
```debian
systemctl restart apparmor.service
```
```debian
nano /etc/bind/named.conf.options
```
```debian
allow-query {any; };
```
```debian
nano /etc/bind/named.conf.default-zones
```
```debian
zone "demo.wsr" {
   type master;
   allow-transfer { any; };
   file "/opt/dns/demo.db";
};
```

```debian
@ IN SOA demo.wsr. root.demo.wsr.(
```
```debian
@ IN NS isp.demo.wsr.
isp IN A <public-ip-ISP>
www IN A <public-ip-RTR-L>
www IN A <public-ip-RTR-R>
internet CNAME isp.demo.wsr.
int IN NS rtr-l.demo.wsr
rtr-l IN  A <public-ip-RTR-L>
```

```debian
systemctl restart bind9
```

### 2. Выполните настройку второго уровня DNS-системы стенда;

```powershell
Install-WindowsFeature -Name DNS -IncludeManagementTools
```

```powershell
Add-DnsServerPrimaryZone -Name "int.demo.wsr" -ZoneFile "int.demo.wsr.dns"
```

```powershell
Add-DnsServerPrimaryZone -NetworkId 10.0.2.0/24 -ZoneFile "int.demo.wsr.dns"
```

```powershell
Add-DnsServerPrimaryZone -NetworkId 172.16.2.0/24 -ZoneFile "int.demo.wsr.dns"
```

```powershell
Add-DnsServerResourceRecordA -Name "web-l" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "10.0.2.6" -CreatePtr 
Add-DnsServerResourceRecordA -Name "web-r" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "172.16.2.6" -CreatePtr 
Add-DnsServerResourceRecordA -Name "srv" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "10.0.2.7" -CreatePtr 
Add-DnsServerResourceRecordA -Name "rtr-l" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "10.0.2.5" -CreatePtr 
Add-DnsServerResourceRecordA -Name "rtr-r" -ZoneName "int.demo.wsr" -AllowUpdateAny -IPv4Address "172.16.2.5" -CreatePtr 
```

```powershell
Add-DnsServerResourceRecordCName -Name "webapp1" -HostNameAlias "web-l.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "webapp2" -HostNameAlias "web-r.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "ntp" -HostNameAlias "srv.int.demo.wsr" -ZoneName "int.demo.wsr"
Add-DnsServerResourceRecordCName -Name "dns" -HostNameAlias "srv.int.demo.wsr" -ZoneName "int.demo.wsr"
```

### 3. Выполните настройку первого уровня системы синхронизации времени:
#### ISP
```debian
apt install -y chrony 
```
```debian
nano /etc/chrony/chrony.conf
```
```debian
local stratum 4
```

```debian
systemctl restart chronyd 
```

### 4. Выполните конфигурацию службы второго уровня времени на SRV

```powershell
New-NetFirewallRule -DisplayName "NTP" -Direction Inbound -LocalPort 123 -Protocol UDP -Action Allow
```

```powershell
w32tm /query /status
Start-Service W32Time
w32tm /config /manualpeerlist:<public-ip-ISP> /syncfromflags:manual /reliable:yes /update
Restart-Service W32Time
```

#### CLI NTP

```powershell
New-NetFirewallRule -DisplayName "NTP" -Direction Inbound -LocalPort 123 -Protocol UDP -Action Allow
```

```powershell
Start-Service W32Time
w32tm /config /manualpeerlist:<public-ip-ISP> /syncfromflags:manual /reliable:yes /update
Restart-Service W32Time
```

```powershell
Set-Service -Name W32Time -StartupType Automatic
```

#### RTR-L
```debian
apt install -y chrony 
```
```debian
nano /etc/chrony/chrony.conf
```
```debian
pool <public-ip-ISP> iburst
```
```debian
systemctl start chronyd
systemctl enable chronyd
chronyc sources
```
#### RTR-R
```debian
apt install -y chrony 
```
```debian
nano /etc/chrony/chrony.conf
```
```debian
pool <public-ip-ISP> iburst
```
```debian
systemctl start chronyd
systemctl enable chronyd
chronyc sources
```

#### WEB-L
```debian
apt install -y chrony 
```
```debian
nano /etc/chrony/chrony.conf
```
```debian
pool <public-ip-ISP> iburst
```
```debian
systemctl start chronyd
systemctl enable chronyd
chronyc sources
```

#### WEB-R
```debian
apt install -y chrony 
```
```debian
nano /etc/chrony/chrony.conf
```
```debian
pool <public-ip-ISP> iburst
```
```debian
systemctl start chronyd
systemctl enable chronyd
chronyc sources
```
### 5. Реализуйте файловый SMB-сервер на базе SRV

```powershell
Get-PhysicalDisk
```

```powershell
New-StoragePool -FriendlyName "POOLRAID1" -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks (Get-PhysicalDisk -CanPool $true)
```
```powershell
New-VirtualDisk -StoragePoolFriendlyName "POOLRAID1" -FriendlyName "RAID1" -ResiliencySettingName Mirror -UseMaximumSize
```
```powershell
Initialize-Disk -FriendlyName "RAID1"
```
```powershell
get-disk
```

```powershell
New-Partition -DiskNumber 4 -UseMaximumSize -DriveLetter R
```
```powershell
Format-Volume -DriveLetter R
```

#### SRV SMB

```powershell
Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools
```

```powershell
New-Item -Path R:\storage -ItemType Directory
```
```powershell
New-SmbShare -Name "SMB" -Path "R:\storage" -FullAccess "Everyone"
```
### 6. Сервера WEB-L и WEB-R должны использовать службу, настроенную на SRV, для обмена файлами между собой:

#### WEB-L

```debian
sudo -i
apt install -y cifs-utils
```
```debian
nano /root/.smbclient
```
```debian
username=SRVAdmin
password=Pa$$w0rdPa$$w0rd
```
```debian
nano /etc/fstab
```
```debian
//10.0.2.7/smb /opt/share cifs user,rw,_netdev,credentials=/root/.smbclient 0 0
```
```debian
mkdir /opt/share
mount -a
```

#### WEB-R
```debian
sudo -i
apt install -y cifs-utils
```
```debian
nano /root/.smbclient
```
```debian
username=SRVAdmin
password=Pa$$w0rdPa$$w0rd
```
```debian
nano /etc/fstab
```
```debian
//10.0.2.7/smb /opt/share cifs user,rw,_netdev,credentials=/root/.smbclient 0 0
```
```debian
mkdir /opt/share
mount -a
```

### 7. Выполните настройку центра сертификации на базе SRV:

```powershell
Install-WindowsFeature -Name AD-Certificate, ADCS-Web-Enrollment -IncludeManagementTools
```

```powershell
Install-AdcsCertificationAuthority -CAType StandaloneRootCa -CACommonName "Demo.wsr" -force
```

```powershell
Install-AdcsWebEnrollment -Confirm -force
```

```powershell
New-SelfSignedCertificate -subject "localhost" 
```

```powershell
Get-ChildItem cert:\LocalMachine\My
```

```powershell
Move-item Cert:\LocalMachine\My\XFX2DX02779XFD1F6F4X8435A5X26ED2X8DEFX95 -destination Cert:\LocalMachine\Webhosting\
```
```powershell
New-IISSiteBinding -Name 'Default Web Site' -BindingInformation "*:443:" -Protocol https -CertificateThumbPrint XFX2DX02779XFD1F6F4X8435A5X26ED2X8DEFX95 
```

```powershell
Start-WebSite -Name "Default Web Site"
```

```powershell
Get-CACrlDistributionPoint | Remove-CACrlDistributionPoint -force
```

```powershell
Get-CAAuthorityInformationAccess |Remove-CAAuthorityInformationAccess -force
```

```powershell
Get-CAAuthorityInformationAccess |Remove-CAAuthorityInformationAccess -force
```

```powershell
Restart-Service CertSrc
```

## Инфраструктура веб-приложения.
Данный блок подразумевает установку и настройку доступа к веб-приложению, выполненному в формате контейнера Docker
1. Образ Docker (содержащий веб-приложение) расположен на ISO-образе дополнительных материалов;
   - Выполните установку приложения AppDocker0;
2. Пакеты для установки Docker расположены на дополнительном ISO-образе;
3. Инструкция по работе с приложением расположена на дополнительном ISO-образе;
4. Необходимо реализовать следующую инфраструктуру приложения.
   - Клиентом приложения является CLI (браузер Edge);
   - Хостинг приложения осуществляется на ВМ WEB-L и WEB-R;
   - Доступ к приложению осуществляется по DNS-имени www.demo.wsr;
     - Имя должно разрешаться во “внешние” адреса ВМ управления трафиком в обоих регионах;
     - При необходимости, для доступа к к приложению допускается реализовать реверс-прокси или трансляцию портов;
   - Доступ к приложению должен быть защищен с применением технологии TLS;
     - Необходимо обеспечить корректное доверие сертификату сайта, без применения “исключений” и подобных механизмов;
   - Незащищенное соединение должно переводится на защищенный канал автоматически;
5. Необходимо обеспечить отказоустойчивость приложения;
   - Сайт должен продолжать обслуживание (с задержкой не более 25 секунд) в следующих сценариях:
     - Отказ одной из ВМ Web
     - Отказ одной из ВМ управления трафиком. 



### 1. Образ Docker (содержащий веб-приложение) расположен на ISO-образе дополнительных материалов;

https://hub.docker.com/r/kp11/app

### 2. Пакеты для установки Docker расположены на дополнительном ISO-образе;
#### WEB-L Doc

```debian
apt-get update
```
```debian
apt-get -y install ca-certificates curl gnupg lsb-release
```
```debian
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```debian
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```debian
apt-get update
```

```debian
apt-get install -y docker-ce docker-ce-cli containerd.io
```

```debian
docker run --name app  -p 8080:80 -d kp11/app:latest
docker ps
```

#### WEB-R Doc

```debian
apt-get update
```
```debian
apt-get -y install ca-certificates curl gnupg lsb-release
```
```debian
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```debian
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```debian
apt-get update
```

```debian
apt-get install -y docker-ce docker-ce-cli containerd.io
```

```debian
docker run --name app  -p 8080:80 -d kp11/app:latest
docker ps
```

```debian
systemctl reload nginx.service
```

#### WEB-L Для работы только на 80
```debian
apt install -y nginx
```

```debian
nano /etc/nginx/sites-available/default
```
```debian
upstream backend {
 server 10.0.2.6:8080 fail_timeout=25;
 server 172.16.2.6:8080 fail_timeout=25;
}

server {
   listen 80  default_server;
 location / {
  proxy_pass http://backend ;
 }
  server_name _;

}
```
```debian
systemctl reload nginx.service
```

#### WEB-R Для работы только на 80
```debian
apt install -y nginx
```

```debian
nano /etc/nginx/sites-available/default
```
```debian
upstream backend {
 server 10.0.2.6:8080 fail_timeout=25;
 server 172.16.2.6:8080 fail_timeout=25;
}

server {
   listen 80  default_server;
 location / {
  proxy_pass http://backend ;
 }
  server_name _;

}
```
```debian
systemctl reload nginx.service
```
### 3. Инструкция по работе с приложением расположена на дополнительном ISO-образе;
В данной момент инструкции к приложению нет, приложением является однастраничный сайт

### 4. Необходимо реализовать следующую инфраструктуру приложения

#### SRV ssl


![image](https://user-images.githubusercontent.com/79700810/150323908-1e37041d-450f-477e-9f9f-24a5f1313e54.png)

![image](https://user-images.githubusercontent.com/79700810/150323973-2b4fd9a8-d934-4a49-8e7d-98e02efd7826.png)

![image](https://user-images.githubusercontent.com/79700810/150324325-b67039dc-6d6a-4dd1-9ade-67bbcaa3a6db.png)

![image](https://user-images.githubusercontent.com/79700810/150324402-d9e1c93a-46b0-42ac-83a0-02b97da4829b.png)



![image](https://user-images.githubusercontent.com/79700810/149763513-cb821774-83ce-40f9-a47d-eaa3941504a5.png)

![image](https://user-images.githubusercontent.com/79700810/149763553-5a666a1c-6069-4022-9e20-1e3041d345b7.png)

![image](https://user-images.githubusercontent.com/79700810/149763685-b0dfb33e-ed50-4de6-937c-1aab86524df9.png)


![image](https://user-images.githubusercontent.com/79700810/149763717-75fa754c-4084-4923-acd8-7dc85201fdb1.png)


![image](https://user-images.githubusercontent.com/79700810/149763741-0e3281f3-b17b-4101-ad77-8dd21dfc7534.png)


![image](https://user-images.githubusercontent.com/79700810/149763772-8f7acb37-379f-455e-9198-1117317d73ed.png)

![image](https://user-images.githubusercontent.com/79700810/149763807-f91c2a81-d061-49bd-9b59-b93ae0e30ef3.png)

### 5. Необходимо обеспечить отказоустойчивость приложения;
#### WEB-L ssl

```debian
cd /opt/share 
```

```debian
openssl pkcs12 -nodes -nocerts -in www.pfx -out www.key 
 
openssl pkcs12 -nodes -nokeys -in www.pfx -out www.cer 
```

```debian
cp /opt/share/www.key /etc/nginx/www.key 
 
cp /opt/share/www.cer /etc/nginx/www.cer
```

```debian
nano /etc/nginx/snippets/snakeoil.conf
```
```debian
ssl_certificate /etc/nginx/www.cer; 
ssl_certificate_key /etc/nginx/www.key; 
```
```debian
nano /etc/nginx/sites-available/default 
```
```debian

upstream backend { 
 server 10.0.2.6:8080 fail_timeout=25; 
 server 172.16.2.6:8080 fail_timeout=25; 
} 
 
server { 
    listen 443 ssl default_server; 
    include snippets/snakeoil.conf; 
    server_name www.demo.wsr; 
 
 location / { 
  proxy_pass http://backend ; 
 } 
} 
 
server { 
   listen 80  default_server; 
  server_name _; 
  return 301 https://www.demo.wsr; 
 
} 
```

```debian
systemctl reload nginx 
```

#### WEB-R ssl

```debian
cd /opt/share 
```

```debian
openssl pkcs12 -nodes -nocerts -in www.pfx -out www.key 
 
openssl pkcs12 -nodes -nokeys -in www.pfx -out www.cer 
```

```debian
cp /opt/share/www.key /etc/nginx/www.key 
 
cp /opt/share/www.cer /etc/nginx/www.cer
```

```debian
nano /etc/nginx/snippets/snakeoil.conf
```
```debian
ssl_certificate /etc/nginx/www.cer; 
ssl_certificate_key /etc/nginx/www.key; 
```
```debian
nano /etc/nginx/sites-available/default 
```
```debian

upstream backend { 
 server 10.0.2.6:8080 fail_timeout=25; 
 server 172.16.2.6:8080 fail_timeout=25; 
} 
 
server { 
    listen 443 ssl default_server; 
    include snippets/snakeoil.conf; 
    server_name www.demo.wsr; 
 
 location / { 
  proxy_pass http://backend ; 
 } 
} 
 
server { 
   listen 80  default_server; 
  server_name _; 
  return 301 https://www.demo.wsr; 
 
} 
```

```debian
systemctl reload nginx 
```

#### CLI 
![image](https://user-images.githubusercontent.com/79700810/152964704-c01616b9-73a2-47a6-a360-201d92096a57.png)

![image](https://user-images.githubusercontent.com/79700810/152964437-90da765b-000a-4cc7-80f1-456c3f3b108e.png)
