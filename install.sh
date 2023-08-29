#!/bin/bash

# Função para instalar o Docker
function instalar_docker() {
  echo "Instalando o Docker..."

  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io

  echo "Docker instalado com sucesso!"
}

# Função para instalar o Docker Compose
function instalar_docker_compose() {
  echo "Instalando o Docker Compose..."

  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  echo "Docker Compose instalado com sucesso!"
}

# Função para criar o arquivo docker-compose.yml
function criar_docker_compose() {
  echo "Criando o arquivo docker-compose.yml..."

  cat > docker-compose.yml << EOF
version: "3"

services:
  traefik:
    image: "traefik"
    restart: always
    command:
      - "--api=true"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.mytlschallenge.acme.tlschallenge=true"
      - "--certificatesresolvers.mytlschallenge.acme.email=\$SSL_EMAIL"
      - "--certificatesresolvers.mytlschallenge.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - \${DATA_FOLDER}/letsencrypt:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock:ro

  n8n:
    image: docker.n8n.io/n8nio/n8n
    restart: always
    ports:
      - "127.0.0.1:5678:5678"
    labels:
      - traefik.enable=true
      - traefik.http.routers.n8n.rule=Host(\`\${SUBDOMAIN}.\${DOMAIN_NAME}\`)
      - traefik.http.routers.n8n.tls=true
      - traefik.http.routers.n8n.entrypoints=web,websecure
      - traefik.http.routers.n8n.tls.certresolver=mytlschallenge
      - traefik.http.middlewares.n8n.headers.SSLRedirect=true
      - traefik.http.middlewares.n8n.headers.STSSeconds=315360000
      - traefik.http.middlewares.n8n.headers.browserXSSFilter=true
      - traefik.http.middlewares.n8n.headers.contentTypeNosniff=true
      - traefik.http.middlewares.n8n.headers.forceSTSHeader=true
      - traefik.http.middlewares.n8n.headers.SSLHost=\${DOMAIN_NAME}
      - traefik.http.middlewares.n8n.headers.STSIncludeSubdomains=true
      - traefik.http.middlewares.n8n.headers.STSPreload=true
      - traefik.http.routers.n8n.middlewares=n8n@docker
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=\$N8N_BASIC_AUTH_USER
      - N8N_BASIC_AUTH_PASSWORD=\$N8N_BASIC_AUTH_PASSWORD
      - N8N_HOST=\${SUBDOMAIN}.\${DOMAIN_NAME}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://\${SUBDOMAIN}.\${DOMAIN_NAME}/
      - GENERIC_TIMEZONE=\$GENERIC_TIMEZONE
    volumes:
      - \${DATA_FOLDER}/.n8n:/home/node/.n8n
EOF

  echo "Arquivo docker-compose.yml criado com sucesso!"
}

# Função para criar o arquivo .env
function criar_env_file() {
  echo "Criando o arquivo .env..."

  read -p "Pasta onde os dados devem ser salvos (ex n8n): " DATA_FOLDER
  read -p "Nome do domínio principal (ex nome.com.br): " DOMAIN_NAME
  read -p "Subdomínio (ex n8n): " SUBDOMAIN
  read -p "Nome de usuário para autenticação básica: " N8N_BASIC_AUTH_USER
  read -p "Senha para autenticação básica: " N8N_BASIC_AUTH_PASSWORD
  read -p "Endereço de e-mail para o certificado SSL: " SSL_EMAIL

  cat > .env << EOF
DATA_FOLDER=\$DATA_FOLDER
DOMAIN_NAME=\$DOMAIN_NAME
SUBDOMAIN=\$SUBDOMAIN
N8N_BASIC_AUTH_USER=\$N8N_BASIC_AUTH_USER
N8N_BASIC_AUTH_PASSWORD=\$N8N_BASIC_AUTH_PASSWORD
GENERIC_TIMEZONE=America/Sao_Paulo
SSL_EMAIL=\$SSL_EMAIL
EOF

  echo "Arquivo .env criado com sucesso!"
}

# Função para exibir o menu
function exibir_menu() {
  echo "===== Instalação do n8n ====="
  echo "Selecione uma opção:"
  echo "1. Instalar n8n"
  echo "2. Atualizar n8n"
  echo "3. Sair"

  read -p "Opção: " opcao

  case \$opcao in
    1) instalar_n8n ;;
    2) atualizar_n8n ;;
    3) exit ;;
    *) echo "Opção inválida. Selecione novamente." ;;
  esac
}

# Função para instalar o n8n
function instalar_n8n() {
  # Verificar se o Docker e o Docker Compose estão instalados
  if ! command -v docker &> /dev/null; then
    instalar_docker
  fi

  if ! command -v docker-compose &> /dev/null; then
    instalar_docker_compose
  fi

  # Criar o arquivo .env
  criar_env_file

  # Criar o arquivo docker-compose.yml
  criar_docker_compose

  # Subir o serviço do n8n
  sudo docker-compose up -d

  echo "n8n instalado com sucesso!"
}

# Função para atualizar o n8n
function atualizar_n8n() {
  # Verificar se o Docker e o Docker Compose estão instalados
  if ! command -v docker &> /dev/null; then
    instalar_docker
  fi

  if ! command -v docker-compose &> /dev/null; then
    instalar_docker_compose
  fi

  # Subir o serviço do n8n
  sudo docker-compose pull
  sudo docker-compose up -d

  echo "n8n atualizado com sucesso!"
}

# Executar o script
exibir_menu
