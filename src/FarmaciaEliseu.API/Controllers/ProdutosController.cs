using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Data;
using FarmaciaEliseu.API.Domain.Entities;

namespace FarmaciaEliseu.API.Controllers;

[ApiController] // Diz que é uma API (retorna JSON)
[Route("api/[controller]")] // Define a URL como: http://localhost:5000/api/produtos
public class ProdutosController : ControllerBase
{
    private readonly AppDbContext _context;

    // Injeção de Dependência: O sistema entrega o AppDbContext pronto aqui
    public ProdutosController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/produtos
    [HttpGet]
    public async Task<ActionResult<List<Produto>>> GetProdutos()
    {
        // Vai no banco, pega 50 produtos que não estão deletados
        var produtos = await _context.Produtos
                                     .Where(p => !p.Deletado)
                                     .Take(50) 
                                     .ToListAsync();

        return Ok(produtos); // Retorna HTTP 200 com os dados
    }
}