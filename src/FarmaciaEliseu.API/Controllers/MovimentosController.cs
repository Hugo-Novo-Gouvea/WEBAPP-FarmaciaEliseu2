using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Data;
using FarmaciaEliseu.API.Domain.Entities;

namespace FarmaciaEliseu.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MovimentosController : ControllerBase
{
    private readonly AppDbContext _context;

    public MovimentosController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<Movimento>>> GetMovimentos()
    {
        // Pega as últimas 50 vendas realizadas
        var movimentos = await _context.Movimentos
                                       .Where(m => !m.Deletado)
                                       .OrderByDescending(m => m.DataVenda) // Mais recentes primeiro
                                       .Take(50)
                                       .ToListAsync();

        return Ok(movimentos);
    }
}