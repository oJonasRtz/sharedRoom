class Controler
{
	protected readonly Dictionary<string, Delegate> routeHandlers;
	public Controler()
	{
		routeHandlers = new Dictionary<string, Delegate>();
	}
	public Dictionary<string, Delegate> Load(WebApplication app)
	{
		return routeHandlers;
	}
}
