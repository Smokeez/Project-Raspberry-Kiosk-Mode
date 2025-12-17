🧠 Project Raspberry 5 — Kiosk Mode

📺⚙️ COMO O PROJETO FUNCIONA

O projeto utiliza um Raspberry Pi 5 como base para transformar qualquer TV ou monitor em uma estação de exibição automática.

Assim que o Raspberry Pi é ligado, ele executa uma sequência totalmente automatizada:

1- Autologin → o sistema entra automaticamente em um usuário dedicado (tv-senai).

2️- Ambiente gráfico → o desktop é carregado.

3️- Serviço systemd (modo usuário) → inicia o script responsável por abrir o navegador.

4️- Chromium Browser é iniciado com as seguintes configurações:

🧩 Modo Kiosk: tela cheia, sem bordas, abas ou menus.

 URL definida no script principal.

 Ignora erros de certificado HTTPS locais (para URLs internas).

 Sem pop-ups, sincronização ou barras de notificação.

5️- Navegador permanece ativo, funcionando como um painel digital.

6️- Watchdog automático (via systemd): caso o Chromium seja fechado, travado ou encerrado, o sistema o reinicia imediatamente.

 O resultado é um sistema de exibição totalmente automático, resiliente e sem necessidade de intervenção humana, ideal para TVs corporativas, dashboards de monitoramento e painéis informativos.

----------------------------------------------------------------------------------------------------------------------------------

🎯📡 PARA QUE O PROJETO FOI FEITO

Este projeto foi criado para resolver a necessidade de manter TVs exibindo informações 24 horas por dia, de forma automática e confiável.

 Objetivo principal:

⚡ Ligar a energia → a TV inicia → o Raspberry abre o site sozinho.
🧱 Nenhuma interação humana é necessária — apenas plug & play.

---------------------------------------------------------------------------------------------------------------------------------

⚙️ COMANDOS UTILIZADOS

Abaixo estão os principais comandos usados para configurar o Raspberry PI 5

 Instalação e Preparação do Sistema

```bash
sudo apt update && sudo apt upgrade -y
```
Atualiza todos os pacotes e dependências do sistema

```bash
sudo apt install chromium -y
```
Instala o navegador Chromium, usado para exibir o conteúdo na tela

```bash
sudo apt install unclutter -y
```
Remove automaticamente o cursor do mouse após alguns segundos(deixa a tela limpa)

```bash
sudo apt install xdotool -y
```
Ferramente útil para automações gráficas (opcional)

----------------------------------------------------------------------------------------------------------------------------------

📁 Criação da Estrutura de Pastas

Caminho para armazenar o script do start_monitor.sh

```bash
cd /home/tv-senai/
```
Criar a pasta script dentro desse caminho

```bash
mkdir scripts
```
Agora dentro da pasta script dar o seguinte comando e coloque o script principal que abre o Chromium em modo kiosk

```bash
 nano start_monitor.sh
```
Comando para dar permissão de execução para o arquivo start_monitor.sh
```bash
sudo chmod +x /home/tv-senai/scripts/start_monitor.sh
```
Caso o arquivo seja criado utilizando o sudo, dar permissão de dono do arquivo
```bash
sudo chown tv-senai:tv-senai /home/tv-senai/scripts/start_monitor.sh
```
<small>[Caminho para o start_monitor.sh](./scripts/start_monitor.sh)</small>

----------------------------------------------------------------------------------------------------------------------------------
Caminho para armazenar o script do kiosk.service, responsavel por iniciar o automaticamente o script start_monitor

```bash
sudo -u tv-senai mkdir -p /home/tv-senai/.config/systemd/user
```
Próximo passo dentro do user criado acima

```bash
sudo nano kiosk.service
```
<small>[Caminho para o kiosk.](./scripts/kiosk.service)</small>

----------------------------------------------------------------------------------------------------------------------------------

🔄 Ativando o Serviço

```bash
systemctl --user daemon-reload
```
Recarrega as definições do systemd (modo usuário)

```bash
systemctl --user enable kiosk.service
```
Ativa o serviço para iniciar automaticamente com o usuário logado

```bash
systemctl --user start kiosk.service
```
Inicia o serviço manualmente (útil para testar)

----------------------------------------------------------------------------------------------------------------------------------
S
🧩 Monitoramento e Logs

```bash
systemctl --user status kiosk.service
```
Mostra o status atual do serviço (ativo, inativo ou com erro)

```bash
journalctl --user -u kiosk.service -f
```
Exibe os logs em tempo real - otimo para debugs

----------------------------------------------------------------------------------------------------------------------------------


🎨🖥️ Personalização da Tela de Boot (Logo)

O Raspberry Pi utiliza o Plymouth para exibir uma imagem durante o processo de inicialização.

Principais comandos para configurar o Plymouth

```bash
sudo apt install plymouth -y
sudo apt install plymouth-themes -y
sudo apt install plymouth-x11 -y
```
----------------------------------------------------------------------------------------------------------------------------------
Desativar a tela arco-íris para colocar a logo desejada

Edite o arquivo:

```bash
sudo nano /boot/firmware/config.txt
```
Dentro desse arquivo txt procurar(ou adicione se não existir)

```bash
[all]
disable_splash=1
```
E para remover a logo da raspberry

Edite:

```bash
sudo nano /boot/firmware/cmdline.txt
```
E na mesma linha colocar 

´´´bash
logo.nologo
```
---------------------------------------------------------------------------------------------------------------------------------------------------

Arquivo do script do tema

```bash
sudo nano /usr/share/plymouth/themes/senai/senai.script
```
<small>[Caminho para o senai.script](./scripts/senai.script)</small>

---------------------------------------------------------------------------------------------------------------------------------------------------
Configuração principal do tema do Plymouth. Ele diz ao sistema como carregar o tema, qual módulo usar e onde esta o script principal


```bash
nano /usr/share/plymouth/themes/senai/senai.plymouth
```
<small>[Caminho para o senai.plymounth](./scripts/senai.plymouth)</small>


 Como funciona a troca de logo?

O Plymouth usa uma imagem chamada splash.png como tela de boot.
Para trocar a logo basta:

1️- Fazer backup da original

2️- Copiar a nova logo

3- Manter o nome splash.png na pasta do tema

Assim, ao ligar o Raspberry, sua logo personalizada (ex.: SENAI) aparece automaticamente.