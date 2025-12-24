using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

[Table("clientes")] // MUITO IMPORTANTE: Liga essa classe à tabela "clientes" do Postgres
public class Cliente : BaseEntity
{
    [Required] // Diz que não pode ser nulo
    [MaxLength(200)] // Limita a string a 200 caracteres (igual VARCHAR(200))
    [Column("nome")] // Liga à coluna "nome" do banco
    public string Nome { get; set; } = string.Empty;

    [MaxLength(200)]
    [Column("endereco")]
    public string? Endereco { get; set; } // O "?" significa que pode vir nulo do banco

    [MaxLength(30)]
    [Column("rg")]
    public string? Rg { get; set; }

    [MaxLength(30)]
    [Column("cpf")]
    public string? Cpf { get; set; }

    [MaxLength(50)]
    [Column("telefone")]
    public string? Telefone { get; set; }

    [MaxLength(50)]
    [Column("celular")]
    public string? Celular { get; set; }

    [Column("data_nascimento")]
    public DateTime? DataNascimento { get; set; }

    [Column("codigo_fichario")]
    public int CodigoFichario { get; set; }
}