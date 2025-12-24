using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Domain.Entities; // Importante para achar a classe Cliente

namespace FarmaciaEliseu.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
        // Configuração para o Postgres aceitar datas antigas sem dar erro de fuso horário
        AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
    }

    // Aqui é onde a mágica acontece.
    // Estamos dizendo: "Banco, crie uma representação da tabela Clientes baseada na classe Cliente"
    public DbSet<Cliente> Clientes { get; set; }
    public DbSet<Funcionario> Funcionarios { get; set; }
    public DbSet<Produto> Produtos { get; set; }
    public DbSet<Movimento> Movimentos { get; set; }
    
}