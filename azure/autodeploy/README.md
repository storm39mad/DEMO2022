## doc
[azurerm doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs )


## Установка Chocolatey 

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
## Установка terraform 
```powershell
choco install terraform
```
## Установка git
```powershell
choco install git
```
## Установка vs code
```powershell
choco install vscode
```
## Установка azure cli
```powershell
choco install azure-cli --version=2.0.79
```

![image](https://user-images.githubusercontent.com/79700810/152991466-d80561df-8311-4495-91ab-209005325a8c.png)

## autodeploy спомощью vs code

Переходим в деректорию и копируем репозиторий
```powershell
cd C:\

git clone https://github.com/storm39mad/DEMO2022.git
```

![image](https://user-images.githubusercontent.com/79700810/152991858-3085cbdb-0730-41e4-b969-1b617aa0b68c.png)

Открываем директорию autodeploy в vs code

![image](https://user-images.githubusercontent.com/79700810/152991910-80f1dccd-6779-443f-a4a9-f8a2d863c80d.png)

Запускаем терминал Terminal -> New Terminal

![image](https://user-images.githubusercontent.com/79700810/152991976-4cd3dbfb-e4aa-4b9f-bce1-15ad3ae4e860.png)

Устанавливаем плагины

![image](https://user-images.githubusercontent.com/79700810/152992386-0c5ed540-a54b-47e1-85cf-fb4f67e3fd10.png)

В файле main.tf объявлены все основные переменные и обращение к ресурстной группе в azure, а также логины и пароли от ВМ

![image](https://user-images.githubusercontent.com/79700810/152992126-e609b36b-7f75-4260-b413-da271a6620d3.png)

Делаем terraform init в Terminal для скачивания плагинов
```powershell
terraform init
```

![image](https://user-images.githubusercontent.com/79700810/152992752-9c43289e-2d23-47c7-9de8-9b60004df629.png)

Для подключения к порталу azure используем az login и указываем свою учетную запись
```powershell
az login
```

![image](https://user-images.githubusercontent.com/79700810/152995696-d8a4c051-bc3d-4616-8a61-f70890cc286d.png)

на портале azure переходим в группу ресурсов 

![image](https://user-images.githubusercontent.com/79700810/152995939-6f3363d3-ba6f-47ae-81f2-94333213c083.png)

 Создаем новую группу ресурсов 
 
![image](https://user-images.githubusercontent.com/79700810/152996116-b00bab67-d548-4c77-9b26-3fea462495a1.png)

в файле main.tf меняем "Azure-competition-KP11_prof" на вашу группу 
![image](https://user-images.githubusercontent.com/79700810/152996429-086839d5-c03a-43c2-84b0-787409f23ede.png)

для проверки конфигурации используем terraform plan

```powershell
terraform plan
```
![image](https://user-images.githubusercontent.com/79700810/153010655-3413249f-aa93-44cc-a5e5-3a9d3ced8158.png)


для развертывания инфраструктуры terraform apply 
```powershell
terraform apply
```
```powershell
yes
```

![image](https://user-images.githubusercontent.com/79700810/153000909-fcde95bd-2ad5-4ecb-9b81-19071c35b4a4.png)


обязательно нужно указать yes

![image](https://user-images.githubusercontent.com/79700810/153001108-d7cd7070-025f-4351-8c67-57399546e041.png)


после чего в группе ресурсов будат созданны все необхожимые и описанные элементы инфраструктуры
Output покажет публичные ip адреса для подключения по ssh

![image](https://user-images.githubusercontent.com/79700810/153014004-074695b4-7204-458d-bebb-d5c502f8a5c1.png)


![image](https://user-images.githubusercontent.com/79700810/153005787-87d7d071-b78d-42fe-889e-ac1a1a6ae4e4.png)


После выполнения работы используем terraform destroy для удаления элементов инфраструктуры
```powershell
terraform destroy
```
```powershell
yes
```

![image](https://user-images.githubusercontent.com/79700810/153005950-7bb7ed75-07df-432b-9066-fca4ea2ffd43.png)

## Подключение

### ISP

![image](https://user-images.githubusercontent.com/79700810/153823342-c31506e0-182b-4f5b-8fd5-43a46a39336f.png)

### RTRL

![image](https://user-images.githubusercontent.com/79700810/153823662-9d81c72b-bcc6-46c9-ac86-d30f97bd15a8.png)

### WEBL
![image](https://user-images.githubusercontent.com/79700810/153823734-f1a0ce1b-7cb5-4434-a676-0ce148fde870.png)

### SRV

![image](https://user-images.githubusercontent.com/79700810/153823971-e870c70a-94b4-4794-a1fb-8d56d52408a7.png)


![image](https://user-images.githubusercontent.com/79700810/153824008-e5302118-6c9d-4d6f-b9ca-8d82d129e45f.png)

### RTRR
![image](https://user-images.githubusercontent.com/79700810/153824109-a2c8f8ad-c116-49ba-836d-07e2f7e20888.png)

### WEBR

![image](https://user-images.githubusercontent.com/79700810/153824189-5d60b353-c02b-4b56-a22b-f200a79c84c3.png)
