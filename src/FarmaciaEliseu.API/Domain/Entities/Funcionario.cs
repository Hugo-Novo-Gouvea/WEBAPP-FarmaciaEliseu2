using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

[Table("funcionarios")] // Mapeia para public.funcionarios
public class Funcionario : BaseEntity
{
    [Required]
    [MaxLength(200)]
    [Column("nome")]
    public string Nome { get; set; } = string.Empty;
}