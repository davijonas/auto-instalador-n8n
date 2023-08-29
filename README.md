# auto-instalador-n8n
SCRIPT DE AUTO INSTALAÇÃO PARA N8N COM SSL 

# Auto Instalador n8n

Este repositório contém um script bash para automatizar a instalação do n8n em sistemas Debian e Ubuntu, usando Docker e Docker Compose.

## Como Usar

1. Certifique-se de estar executando o script em um ambiente seguro e de ter permissões de superusuário (sudo).
2. Execute o seguinte comando no terminal para iniciar a instalação:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/davijonas/auto-instalador-n8n/main/install.sh)"

<br>
<br>
Siga as instruções fornecidas pelo script para inserir os dados necessários, como a pasta de dados, domínio, subdomínio, autenticação básica e outros.
O script criará os arquivos docker-compose.yml e .env com as configurações fornecidas e iniciará o serviço do n8n.
<br><br>Certifique-se de revisar e entender o script antes de executá-lo, pois ele realizará a instalação e configuração no sistema.

<br><br>Contribuição
Se você quiser contribuir para este projeto, sinta-se à vontade para abrir uma Issue ou enviar um Pull Request. Toda contribuição é bem-vinda!

Licença
Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

