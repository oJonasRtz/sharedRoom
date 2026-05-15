class Server
{
	private WebApplication _app;
	private Routes _routes;

	public Server()
	{
		var builder = WebApplication.CreateBuilder();
		_app = builder.Build();
		_routes = new Routes();
		_routes.Load(_app);
	}
	public void Run()
	{
		_app.Run();
	}
}
