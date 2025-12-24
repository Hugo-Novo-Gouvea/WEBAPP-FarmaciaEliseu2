using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Domain.Entities;

namespace FarmaciaEliseu.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
        AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
    }

    public DbSet<Cliente> Clientes { get; set; }
    public DbSet<Funcionario> Funcionarios { get; set; }
    public DbSet<Produto> Produtos { get; set; }
    public DbSet<Movimento> Movimentos { get; set; }

    // --- ADICIONE ESTE BLOCO NO FINAL ---
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Mapeamento manual dos IDs (já que no banco não é padronizado como "id")
        
        modelBuilder.Entity<Cliente>()
            .Property(c => c.Id)
            .HasColumnName("clientes_id");

        modelBuilder.Entity<Funcionario>()
            .Property(f => f.Id)
            .HasColumnName("funcionarios_id");

        modelBuilder.Entity<Produto>()
            .Property(p => p.Id)
            .HasColumnName("produtos_id");

        modelBuilder.Entity<Movimento>()
            .Property(m => m.Id)
            .HasColumnName("movimentos_id");

        base.OnModelCreating(modelBuilder);
    }
}