using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

[Table("produtos")]
public class Produto : BaseEntity
{
    [Required]
    [MaxLength(200)]
    [Column("descricao")]
    public string Descricao { get; set; } = string.Empty;

    [MaxLength(200)]
    [Column("unidade_medida")]
    public string? UnidadeMedida { get; set; } // Pode ser nulo (UN, CX, FR...)

    [Column("preco_compra")]
    public decimal PrecoCompra { get; set; } // Decimal é perfeito para dinheiro

    [Column("preco_venda")]
    public decimal PrecoVenda { get; set; }

    [MaxLength(200)]
    [Column("localizacao")]
    public string? Localizacao { get; set; }

    [MaxLength(200)]
    [Column("laboratorio")]
    public string? Laboratorio { get; set; }

    [MaxLength(200)]
    [Column("principio")]
    public string? Principio { get; set; } // Princípio Ativo

    [Required]
    [MaxLength(3)]
    [Column("generico")]
    public string Generico { get; set; } = "NAO"; // Default "NAO"

    [MaxLength(9)]
    [Column("codigo_produto")]
    public string? CodigoProduto { get; set; } // Aquele código interno antigo

    [Required] // Código de Barras é obrigatório para vender
    [MaxLength(50)]
    [Column("codigo_barras")]
    public string CodigoBarras { get; set; } = string.Empty;
}