using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FarmaciaEliseu.API.Data;
using FarmaciaEliseu.API.Domain.Entities;

namespace FarmaciaEliseu.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FuncionariosController : ControllerBase
{
    private readonly AppDbContext _context;

    public FuncionariosController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<List<Funcionario>>> GetFuncionarios()
    {
        var funcionarios = await _context.Funcionarios
                                         .Where(f => !f.Deletado)
                                         .OrderBy(f => f.Nome)
                                         .ToListAsync();

        return Ok(funcionarios);
    }
}