🧠 Project Raspberry 5 — Kiosk Mode

📺⚙️ COMO O PROJETO FUNCIONA

O projeto utiliza um Raspberry Pi 5 como base para transformar qualquer TV ou monitor em uma estação de exibição automática.

Assim que o Raspberry Pi é ligado, ele executa uma sequência totalmente automatizada:

1️⃣ Autologin → o sistema entra automaticamente em um usuário dedicado (tv-senai).

2️⃣ Ambiente gráfico → o desktop é carregado.

3️⃣ Serviço systemd (modo usuário) → inicia o script responsável por abrir o navegador.

4️⃣ Chromium Browser é iniciado com as seguintes configurações:

🧩 Modo Kiosk: tela cheia, sem bordas, abas ou menus.

🌐 URL definida no script principal.

🔒 Ignora erros de certificado HTTPS locais (para URLs internas).

⚙️ Sem pop-ups, sincronização ou barras de notificação.

5️⃣ Navegador permanece ativo, funcionando como um painel digital.

6️⃣ Watchdog automático (via systemd): caso o Chromium seja fechado, travado ou encerrado, o sistema o reinicia imediatamente.

📊 O resultado é um sistema de exibição totalmente automático, resiliente e sem necessidade de intervenção humana, ideal para TVs corporativas, dashboards de monitoramento e painéis informativos.

----------------------------------------------------------------------------------------------------------------------------------

🎯📡 PARA QUE O PROJETO FOI FEITO

Este projeto foi criado para resolver a necessidade de manter TVs exibindo informações 24 horas por dia, de forma automática e confiável.

🎬 Objetivo principal:

⚡ Ligar a energia → a TV inicia → o Raspberry abre o site sozinho.
🧱 Nenhuma interação humana é necessária — apenas plug & play.

---------------------------------------------------------------------------------------------------------------------------------

⚙️ COMANDOS UTILIZADOS

abaixo estão os principais comandos usados para configurar o Raspberry PI 5

🔧 Instalação e Preparação do Sistema

```Python
sudo apt update && sudo apt upgrade -y
```
Atualiza todos os pacotes e dependências do sistema

```python
sudo apt install chromium-browser -y
```
instala o navegador Chromium, usado para exibir o conteúdo na tela

```python
sudo apt install unclutter -y
```
Remove automaticamente o cursor do mouse após alguns segundos(deixa a tela limpa)

```python
sudo apt install xdotool -y
```
Ferramente útil para automações gráficas (opcional)

----------------------------------------------------------------------------------------------------------------------------------

📁 Criação da Estrutura de Pastas

Caminho para armazenar o script do start_monitor.sh

```python
cd /home/tv-senai/
```
Criar a pasta script dentro desse caminho

```python
mkdir scripts
```
Agora dentro da pasta script dar o seguinte comando e coloque o script principal que abre o Chromium em modo kiosk

```python
sudo nano start_monitor.sh
```
####[Caminho para o start_monitor.sh](./scripts/start_monitor.sh)
----------------------------------------------------------------------------------------------------------------------------------
Caminho para armazenar o script do kiosk.service, responsavel por iniciar o automaticamente o script start_monitor
```python
sudo -u tv-senai mkdir -p /home/tv-senai/.config/systemd/user
```
Próximo passo dentro do user criado acima
```python
sudo nano kiosk.service
```
####[Caminho para o kiosk.](./scripts/kiosk.service)
----------------------------------------------------------------------------------------------------------------------------------

🔄 Ativando o Serviço

```python
systemctl --user daemon-reload
```
recarrega as definições do systemd (modo usuário)

```python
systemctl --user start kiosk.service
```
ativa o serviço para iniciar automaticamente com o usuário logado

```python
sytemctl --user start kiosk.service
```
inicia o serviço manualmente (útil para testar)

----------------------------------------------------------------------------------------------------------------------------------

🧩 Monitoramento e Logs

```python
systemctl --user status kiosk.service
```
mostra o status atual do serviço (ativo, inativo ou com erro)

```python
journalctl --user -u kiosk.service -f
```
exibe os logs em tempo real - otimo para debugs

----------------------------------------------------------------------------------------------------------------------------------


🎨🖥️ Personalização da Tela de Boot (Logo)

O Raspberry Pi utiliza o Plymouth para exibir uma imagem durante o processo de inicialização.

Principais comandos para configurar o Plymouth

```python
sudo apt install plymouth -y
sudo apt install plymouth-themes -y
sudo apt install plymouth-x11 -y
```
----------------------------------------------------------------------------------------------------------------------------------
Desativar a tela arco-íris para colocar a logo desejada

```python
sudo nano /boot/firmware/config.txt
```
dentro desse arquivo txt procurar(ou adicione se não existir)
```python
[all]
disable_splash=1
```
E para remover a logo da raspberry

```python
sudo nano /boot/firmware/cmdline.txt
```
e na mesma linha colocar 

´´´python
logo.nologo
```
---------------------------------------------------------------------------------------------------------------------------------------------------Agora vamos criar o que vai controlar tudo que aparece na tela do boot

```python
sudo nano /usr/share/plymouth/themes/senai/senai.script
```
<small>[Caminho para o senai.script](./scripts/senai.script)</small>

---------------------------------------------------------------------------------------------------------------------------------------------------
Configuração principal do tema do Plymouth. Ele diz ao sistema como carregar o tema, qual módulo usar e onde esta o script principal


```python
nano /usr/share/plymouth/themes/senai/senai.plymouth
```
<small>[Caminho para o senai.plymounth](./scripts/senai.plymouth)</small>


Para personalizar essa tela, o projeto substitui a imagem padrão do Raspberry PI por uma imagem personalizada (Ex:logo do SENAI)

o funcionamento é simples:
1- Fazemos um backup da imagem original
2- Copiamos a nova logo para o diretório do Plymouth
3- Mantemos o mesmo nome do arquivo (splash.png)

Dessa forma, ao ligar o Raspberry, o sistema exibe automaticamente a nova logo durante o boot.