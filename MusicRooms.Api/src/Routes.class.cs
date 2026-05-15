class Routes
{
	private readonly List<Controler> controlers;

	public Routes()
	{
		controlers = new List<Controler>()
		{
			new TestsController(),
			new UserController()
		};
	}
	public void Load(WebApplication app)
	{
		foreach (var controler in controlers)
		{
			var routeHandlers = controler.Load(app);
			foreach (var route in routeHandlers)
				app.MapGet(route.Key, route.Value);
		}
	}
}
