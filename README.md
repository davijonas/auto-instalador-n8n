SCRIPT DE AUTO INSTALAÇÃO PARA N8N COM SSL 

# Auto Instalador n8n

Este repositório contém um script bash para automatizar a instalação do n8n em sistemas Debian e Ubuntu, usando Docker e Docker Compose.
<br>Se você quiser contribuir para este projeto, sinta-se à vontade para abrir uma Issue ou enviar um Pull Request. Toda contribuição é bem-vinda!

## Como Usar

1. Certifique-se de estar executando o script em um ambiente seguro e de ter permissões de superusuário (sudo).
2. Execute o seguinte comando no terminal para iniciar a instalação:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/davijonas/auto-instalador-n8n/main/install.sh)"

<br>
Siga as instruções fornecidas pelo script para inserir os dados necessários, como a pasta de dados, domínio, subdomínio, autenticação básica e outros.
O script criará os arquivos docker-compose.yml e .env com as configurações fornecidas e iniciará o serviço do n8n.

<br>🙋‍♂️ Dê preferência a vps com Debian LTS, vai funciona melhor e consome menos memória. 

---
Se este projeto te ajudou e você gostaria de contribuir, considere fazer uma doação via PIX:

![QR Code PIX](link-para-o-seu-qr-code-pix)

❗➡️Chave PIX: 04a1233f-3e80-4b70-a32a-1742f59bab0b

Sua contribuição é muito apreciada e ajudará no desenvolvimento contínuo deste projeto. Muito obrigado!
Licença
Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

