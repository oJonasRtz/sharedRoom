class Server
{
	private WebApplication _app;
	private Routes _routes;

	public Server()
	{
		var builder = WebApplication.CreateBuilder();
		_app = builder.Build();
		_routes = new Routes();
		ConfigMiddlewares();
		_routes.Load(_app);
	}
	public void Run()
	{
		_app.Run();
	}

	private void ConfigMiddlewares()
	{
		_app.Use(async (context, next) =>
		{
			Console.WriteLine($"Request: {context.Request.Method} {context.Request.Path}");
			await next();
		});
	}
}
