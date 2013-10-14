using System;
using System.Collections.Generic;
using DWScript.Interop;

namespace DWScript
{
	public class DelphiArray<T> : List<T>, ICOMEnumerable
	{
		class DelphiArrayEnumerator : ICOMEnumerator
		{
			Enumerator _enumerator;

			public DelphiArrayEnumerator(Enumerator enumerator)
			{
				_enumerator = enumerator;
			}

			public object GetCurrent()
			{
				return _enumerator.Current;
			}

			public bool MoveNext()
			{
				return _enumerator.MoveNext();
			}
		}

		ICOMEnumerator ICOMEnumerable.GetEnumerator()
		{
			return new DelphiArrayEnumerator(this.GetEnumerator());
		}
	}
}
