using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddAuthorization();
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
               .AddJwtBearer(jwtBearerOptions =>
               {
                   jwtBearerOptions.Authority = Environment.GetEnvironmentVariable("OIDC_AUTHORITY") ?? "http://localhost:8090/auth/realms/FitnessApp";
                   jwtBearerOptions.Audience = Environment.GetEnvironmentVariable("OIDC_CLIENT_ID") ?? "FitnessApp";
                   jwtBearerOptions.IncludeErrorDetails = true;
                   jwtBearerOptions.RequireHttpsMetadata = false;
                   jwtBearerOptions.TokenValidationParameters = new TokenValidationParameters
                   {
                       ValidateAudience = true,
                       ValidAudiences = new[] { "master-realm", "account" },
                       ValidateIssuer = false,
                       ValidateLifetime = false
                   };
               });

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
