using System.Net.Http.Json;
using System.Net.Http.Headers;

public class Auth
{
	private readonly HttpClient _http;
	private readonly IHttpContextAccessor _httpContextAccessor;

	public Auth(
		HttpClient http,
		IHttpContextAccessor httpContextAccessor
	)
	{
		_http = http;
		_httpContextAccessor = httpContextAccessor;
	}
	

	public async Task<string?> EnsureAuth()
	{
		var context = _httpContextAccessor.HttpContext;
		if (context == null)
			return null;

		var existingToken = context.Request.Cookies["token"];
		if (!string.IsNullOrEmpty(existingToken))
		{
			_http.DefaultRequestHeaders.Authorization =
				new AuthenticationHeaderValue("Bearer", existingToken);
			return existingToken;
		}

		var res = await _http.PostAsync("/user/login", null);
		if (!res.IsSuccessStatusCode)
			return null;

		var auth = await res.Content.ReadFromJsonAsync<AuthResponse>();
		if (auth == null)
			return null;

		context.Response.Cookies.Append("token", auth.Token, new CookieOptions
		{
			HttpOnly = true,
			Secure = true,
			SameSite = SameSiteMode.Strict,
			Expires = DateTimeOffset.UtcNow.AddHours(20)
		});

		context.Response.Cookies.Append("nickname", auth.Nickname, new CookieOptions
		{
			HttpOnly = false,
			Secure = true,
			SameSite = SameSiteMode.Strict,
			Expires = DateTimeOffset.UtcNow.AddHours(20)
		});

		_http.DefaultRequestHeaders.Authorization =
			new AuthenticationHeaderValue("Bearer", auth.Token);

		return auth.Token;
	}
}