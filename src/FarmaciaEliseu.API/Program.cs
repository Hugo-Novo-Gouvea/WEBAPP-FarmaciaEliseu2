using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.EntityFrameworkCore;
using System.Net;
using FarmaciaEliseu.API.Data;

var builder = WebApplication.CreateBuilder(args);

// Configuração manual da porta 5000 (Isso que gera o aviso de override, e está correto!)
builder.WebHost.ConfigureKestrel(options =>
{
    options.Listen(IPAddress.Any, 5000); 
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

// --- MUDANÇA 1: Adicionar o serviço de CORS ---
// Isso permite que o Blazor (que roda em outra porta) acesse os dados aqui.
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy => 
    {
        policy.AllowAnyOrigin()  // Permite qualquer site (localhost, IP da rede, etc)
              .AllowAnyMethod()  // Permite GET, POST, PUT, DELETE
              .AllowAnyHeader(); // Permite qualquer cabeçalho
    });
});
// ----------------------------------------------

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection(); // Removi se estiver usando HTTP puro na porta 5000 para evitar conflito

// --- MUDANÇA 2: Ativar o CORS ---
// Importante: Coloque EXATAMENTE nesta ordem (antes do Authorization)
app.UseCors("AllowAll"); 
// --------------------------------

app.UseAuthorization();

app.MapControllers();

app.Run();