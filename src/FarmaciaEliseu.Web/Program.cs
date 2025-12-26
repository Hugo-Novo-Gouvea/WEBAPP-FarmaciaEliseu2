using FarmaciaEliseu.Web.Components;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// --- MUDANÇA: Adicionar o HttpClient ---
// Aqui ensinamos o site onde a API mora.
// Toda vez que você pedir um "HttpClient" nas páginas, ele entrega um configurado para a porta 5000.
builder.Services.AddScoped(sp => new HttpClient 
{ 
    // Ele tenta ler do appsettings. Se não achar, usa o localhost como "plano B"
    BaseAddress = new Uri(builder.Configuration["ApiUrl"] ?? "http://localhost:5000/") 
});
// ---------------------------------------

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseAntiforgery();

app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();