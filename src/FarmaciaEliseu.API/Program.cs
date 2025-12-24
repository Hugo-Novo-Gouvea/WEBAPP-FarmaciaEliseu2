using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.EntityFrameworkCore;
using System.Net;
using FarmaciaEliseu.API.Data;

var builder = WebApplication.CreateBuilder(args);

// ==============================================================================
// 1. CONFIGURAÇÃO DE INFRAESTRUTURA (SERVIDORES E BANCO)
// ==============================================================================

// Configuração do Servidor Web (Kestrel)
// Força rodar na porta 5000 para evitar conflitos e portas aleatórias.
builder.WebHost.ConfigureKestrel(options =>
{
    options.Listen(IPAddress.Any, 5000); 
    // Se quiser HTTPS no futuro, descomente a linha abaixo (requer certificado):
    // options.Listen(IPAddress.Any, 5001, listenOptions => listenOptions.UseHttps());
});

// Configuração do Banco de Dados (PostgreSQL)
// Pega a string de conexão do User Secrets (Dev) ou appsettings.json (Prod)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

// ==============================================================================
// 2. INJEÇÃO DE DEPENDÊNCIA DOS SERVIÇOS
// ==============================================================================

// Adiciona suporte a Controllers (Melhor para APIs grandes que Minimal API)
builder.Services.AddControllers();

// Configuração do Swagger (Documentação da API)
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// ==============================================================================
// 3. PIPELINE DE REQUISIÇÃO (MIDDLEWARES)
// ==============================================================================

// Em ambiente de desenvolvimento, ativa o Swagger visual
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(); // Cria a interface em /swagger/index.html
}

// Redirecionamento HTTPS desligado para facilitar dev local (ative em produção!)
// app.UseHttpsRedirection(); 

app.UseAuthorization();

// Mapeia os Controllers (Seus futuros endpoints de Clientes, Produtos, etc)
app.MapControllers();

// Roda a aplicação
app.Run();