using System.Text;
using System.Text.Json;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;

class UserController : Controler
{
	public UserController()
	{
		routeHandlers.Add("/user/login", Login);
	}

	private string Login()
	{
		var id = Guid.NewGuid().ToString();
		string nickname = UsernameGen();

		var claims = new[]
		{
			new Claim("id", id),
		};

		var key = new SymmetricSecurityKey(
			Encoding.UTF8.GetBytes(
				"my_super_secret_key_that_is_very_long_123456789"  // Replace with .env later
			)
		);

		var creds = new SigningCredentials(
			key,
			SecurityAlgorithms.HmacSha256  // Replace with .env later
		);

		var token = new JwtSecurityToken(
			claims: claims,
			expires: DateTime.UtcNow.AddDays(7), // Replace with .env later
			signingCredentials: creds
		);

		string jwt = new JwtSecurityTokenHandler()
			.WriteToken(token);

		return JsonSerializer.Serialize(new
		{
			token = jwt,
			nickname
		});
	}

	private string UsernameGen()
	{
		var adjectives = new[] { "Swift", "Silent", "Brave", "Clever", "Mighty" };
		var animals = new[] { "Lion", "Eagle", "Shark", "Wolf", "Panther" };
		var random = new Random();
		string adjective = adjectives[random.Next(adjectives.Length)];
		string animal = animals[random.Next(animals.Length)];
		return $"{adjective} {animal}";
	}
}
