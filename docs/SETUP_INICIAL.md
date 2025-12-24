# Configuração Inicial do Projeto - FarmaciaEliseu

## 1. Stack Tecnológica
- **Linguagem:** C# (.NET 9)
- **Framework Web:** ASP.NET Core Web API
- **Servidor Web:** Kestrel (Cross-platform)
- **Banco de Dados:** PostgreSQL
- **ORM:** Entity Framework Core

## 2. Estrutura de Pastas
O projeto segue a estrutura de Solução na raiz e fontes em `src`:
- `/src`: Código fonte da aplicação.
- `/docs`: Documentação técnica.
- `/tests`: (Futuro) Projetos de teste.

## 3. Comandos de Setup (Log de Execução)

Comandos executados para criar a estrutura do zero:

```bash
# Estando dentro da pasta onde vai receber seu repositorio (NÃO CRIE UMA PASTA COM NOME IGUAL, O PROPRIO GIT JA VAI CRIAR NA RAIZ):
git clone https://github.com/SEU-USUARIO/SEU-LINK-HTTPS.git
cd NOME-DA-PASTA
dotnet new gitignore

# 1. Criação da Solução vazia
dotnet new sln -n FarmaciaEliseu

# 2. Criação do Projeto Web API (dentro de src)
mkdir src
cd src
dotnet new webapi -n FarmaciaEliseu.API

# 3. Instalação de Pacotes do PostgreSQL (Entity Framework)
cd FarmaciaEliseu.API
dotnet add package Microsoft.EntityFrameworkCore --version 9.0.0
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 9.0.0
dotnet add package Microsoft.EntityFrameworkCore.Design --version 9.0.0

# 4. Vinculação do projeto à solução (voltando para a raiz)
cd ../..
dotnet sln add src/FarmaciaEliseu.API/FarmaciaEliseu.API.csproj
```

## 4. Explicação das Dependências Chave
Entenda o papel de cada pacote instalado no passo 3:

### Npgsql.EntityFrameworkCore.PostgreSQL
- **O  que e:** O Provider (Provedor) oficial do Entity Framework Core para PostgreSQL.
- **Funcao:** Atua como um tradutor. Ele pega as consultas LINQ do C# (ex: context.Clientes.Where(...)) e as traduz para o dialeto SQL específico do PostgreSQL.
- **Ciclo de Vida:** Runtime (Vai para produção).

### Microsoft.EntityFrameworkCore.Design
- **O  que e:** Ferramentas de tempo de design para o EF Core.
- **Funcao:** Permite executar comandos de gerenciamento do banco via CLI, como criar Migrations (dotnet ef migrations add) ou atualizar o banco (dotnet ef database update). Ele analisa seu código fonte para entender o modelo de dados.
- **Ciclo de Vida:** Development (Geralmente não é necessário no binário final de produção, pois é usado apenas pelos desenvolvedores ou pipeline de CI/CD).