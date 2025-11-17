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

```python
mkdir -p ~/scripts
mkdir -p ~/.config/systemd/user
mkdir -p ~/services
```
criar as pastas que armazenam os scripts e serviços do projeto

----------------------------------------------------------------------------------------------------------------------------------

🚀 Movendo e Preparando os Arquivos

```python
cp scripts/start_monitor.sh ~/scripts/
cp services/kiosk.service ~/.config/systemd/user/
chmod +x ~/scripts/start_monitor.sh
```
copia os arquivos para os locais corretos e dá permissão ao script principal

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
Essa imagem fica localizada em:
```python
/usr/share/plymouth/themes/pix/splash.png
```
Para personalizar essa tela, o projeto substitui a imagem padrão do Raspberry PI por uma imagem personalizada (Ex:logo do SENAI)

o funcionamento é simples:
1- Fazemos um backup da imagem original
2- Copiamos a nova logo para o diretório do Plymouth
3- Mantemos o mesmo nome do arquivo (splash.png)

Dessa forma, ao ligar o Raspberry, o sistema exibe automaticamente a nova logo durante o boot.