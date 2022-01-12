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

## Коммутацию (если таковая не выполнена) выполните в соответствии со схемой сети.
## RTR-L
```cisco
int gi 1
ip address 4.4.4.1 255.255.255.0
no sh

int gi 2
ip address 192.168.100.254 255.255.255.0
no sh
end
```

![image](https://user-images.githubusercontent.com/79700810/149131532-441bf23b-1cc1-443a-90e5-6fd6863248bb.png)

