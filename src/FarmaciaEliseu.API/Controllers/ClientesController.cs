using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Data;
using FarmaciaEliseu.API.Domain.Entities;

namespace FarmaciaEliseu.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ClientesController : ControllerBase
{
    private readonly AppDbContext _context;

    public ClientesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<Cliente>>> GetClientes()
    {
        var clientes = await _context.Clientes
                                     .Where(c => !c.Deletado)
                                     .OrderBy(c => c.Nome) // Ordena por nome A-Z
                                     .Take(50) 
                                     .ToListAsync();

        return Ok(clientes);
    }
}