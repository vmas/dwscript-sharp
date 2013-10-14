using System;
using System.Collections.Generic;
using System.Text;

namespace DWScript
{
	public delegate object NativeFunction(DWSProgramContext context, DWSValue[] args);
	public delegate void NativeAction(DWSProgramContext context, DWSValue[] args);
}
