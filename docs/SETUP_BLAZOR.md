# Setup do Frontend (Blazor WebApp)

Este documento registra os passos para criação e configuração inicial do projeto de Frontend utilizando Blazor.

## 1. Criação do Projeto
Comando executado na raiz da solução para criar o projeto web baseado no template Blazor:

```bash
dotnet new blazor -o src/FarmaciaEliseu.Web
```

## 2. Vínculo com a Solução (SLN)
Adiciona o projeto novo ao arquivo de solução global para que o Visual Studio/VS Code gerencie tudo junto:

```bash
dotnet sln add src/FarmaciaEliseu.Web
```

## 3. Referência ao Backend (Shared Code)
Este passo é crucial. Ele permite que o Frontend "enxergue" as classes (Entidades) do Backend, evitando duplicação de código (DTOs). O projeto Web passa a ter acesso direto às classes Produto, Cliente, etc. do projeto API.

```bash
dotnet add src/FarmaciaEliseu.Web reference src/FarmaciaEliseu.API
```

## 4. Como Rodar o Frontend
Para iniciar apenas o site (sem a API):

```bash
cd src/FarmaciaEliseu.Web
dotnet run
```

O site ficará disponível na porta indicada no terminal (ex: http://localhost:5xxx).