using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FarmaciaEliseu.API.Domain.Entities;

[Table("movimentos")]
public class Movimento : BaseEntity
{
    // --- CHAVES ESTRANGEIRAS (FKs) ---
    // Aqui guardamos apenas o ID. Futuramente, faremos o C# navegar (trazer o Cliente completo)
    // Mas por enquanto, mapear o ID é suficiente.

    [Column("produtos_id")]
    public int ProdutoId { get; set; }

    [Column("clientes_id")]
    public int ClienteId { get; set; }

    [Column("funcionarios_id")]
    public int FuncionarioId { get; set; }

    // --- DADOS HISTÓRICOS (Redundância proposital do banco) ---
    [Column("produtos_descricao")]
    public string ProdutoDescricao { get; set; } = string.Empty;

    [Column("clientes_nome")]
    public string ClienteNome { get; set; } = string.Empty;

    [Column("funcionarios_nome")]
    public string FuncionarioNome { get; set; } = string.Empty;

    // --- VALORES ---
    [Column("quantidade")]
    public int Quantidade { get; set; }

    [Column("preco_unitario_dia_venda")]
    public decimal PrecoUnitarioDiaVenda { get; set; }

    [Column("preco_total_dia_venda")]
    public decimal PrecoTotalDiaVenda { get; set; }

    [Column("preco_unitario_atual")]
    public decimal PrecoUnitarioAtual { get; set; }

    [Column("preco_total_atual")]
    public decimal PrecoTotalAtual { get; set; }

    [Column("valor_pago")]
    public decimal ValorPago { get; set; }

    [Column("desconto")]
    public decimal Desconto { get; set; }

    // --- DATAS E CONTROLE ---
    [Column("data_venda")]
    public DateTime DataVenda { get; set; }

    [Column("data_pagamento")]
    public DateTime? DataPagamento { get; set; } // Pode não ter pago ainda (Fiado)

    [Column("codigo_movimento")]
    public int CodigoMovimento { get; set; } // Aquele número sequencial da nota
}