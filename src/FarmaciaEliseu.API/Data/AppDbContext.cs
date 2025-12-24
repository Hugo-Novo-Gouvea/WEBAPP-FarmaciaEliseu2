using Microsoft.EntityFrameworkCore;
using System.Net;

namespace FarmaciaEliseu.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    // Futuramente suas tabelas virão aqui. Ex:
    // public DbSet<Cliente> Clientes { get; set; }
}