using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

// "abstract" significa que você nunca vai usar "new BaseEntity()". 
// Ela serve só de herança para os outros.
public abstract class BaseEntity
{
    [Key] // Avisa que essa é a Chave Primária (PK)
    [Column("id")] // Mapeia para a coluna "id" no Postgres (que criamos com SERIAL)
    public int Id { get; set; }

    [Column("data_cadastro")]
    public DateTime DataCadastro { get; set; } = DateTime.UtcNow;

    [Column("data_ultimo_registro")]
    public DateTime DataUltimoRegistro { get; set; } = DateTime.UtcNow;

    [Column("deletado")]
    public bool Deletado { get; set; } = false;
}