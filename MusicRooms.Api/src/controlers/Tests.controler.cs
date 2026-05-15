
class TestsController: Controler
{
	public TestsController()
	{
		routeHandlers.Add("/test/hello", Hello);
	}

	private string Hello()
	{
		return "Hello World";
	}
}
