using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

public abstract class BaseEntity
{
    [Key]
    public int Id { get; set; }

    [Column("data_cadastro")]
    public DateTime DataCadastro { get; set; } = DateTime.UtcNow;

    [Column("data_ultimo_registro")]
    public DateTime DataUltimoRegistro { get; set; } = DateTime.UtcNow;

    [Column("deletado")]
    public bool Deletado { get; set; } = false;
}