using System;
using System.Reflection;

namespace UnitTests
{
	class Program
	{
		[STAThread]
		static void Main(string[] args)
		{
			string prefix = Environment.OSVersion.Platform == PlatformID.Unix ? "--" : "/";
			string nothread = prefix + "nothread";
			string domain = prefix + "domain=None";
			string labels = prefix + "labels";

			string[] my_args = { Assembly.GetExecutingAssembly().Location, nothread, domain, labels };

			int returnCode = NUnit.ConsoleRunner.Runner.Main(my_args);

			if (returnCode != 0)
				Console.Beep();

			Console.WriteLine("Press any key...");
			Console.ReadKey();
		}
	}
}
