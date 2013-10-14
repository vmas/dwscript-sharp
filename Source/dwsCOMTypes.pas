unit dwsCOMTypes;

interface

uses SysUtils,
//    Dialogs,
	Windows,
	Classes;

	procedure SuccessCall(code : HResult);

type
	TDWSDebugCallback = procedure(const error: string); cdecl;

	ICOMEnumerator = interface
		['{3A1E2229-26C0-436C-97D7-08C46CF86995}']
		function GetCurrent(out rv: IUnknown): HResult; stdcall;
		function MoveNext(out rv: boolean): HResult; stdcall;
	end;

	ICOMEnumerable = interface
		['{BA4F1915-F9A0-460B-A4D3-1DC5FC9560B6}']
		function GetEnumerator(out rv: ICOMEnumerator): HResult; stdcall;
	end;

	ECOMException = class(Exception)
		private _code : HResult;
		public
			constructor Create(code : HResult);
			function GetCode() : HRESULT;
			property Code : Hresult read GetCode;
	end;

	IDelphiObject = interface
		['{C7A2EC25-7D05-41D8-B1C1-8E930B9F95FB}']
		function SetDebugCallback(callback: TDWSDebugCallback): HRESULT; stdcall;
	end;

	TCOMObject = class(TInterfacedObject, IDelphiObject)
		private
			_debug: TDWSDebugCallback;
		public
			destructor Destroy; override;
			function GetIUnknownForObject() : Pointer;
			function SetDebugCallback(callback: TDWSDebugCallback): HRESULT; stdcall;
			procedure Debug(s: string);
	end;

	TUnicodeString = record
		private
			_address : PChar;
		public
			class operator Implicit(s: TUnicodeString): String;
			class operator Implicit(s: String): TUnicodeString;
			function IsNull() : boolean;
			function IsNullOrEmpty() : boolean;
	end;

	TDWSWrapperCreator = function(obj: TObject) : TCOMObject;

	TCOMEnumerable<T> = class(TCOMObject, ICOMEnumerable)
		private
			_value : IEnumerable;
			_createT : TDWSWrapperCreator;
		public
			constructor Create(value: IEnumerable; createT : TDWSWrapperCreator); virtual;
			function GetEnumerator(out rv: ICOMEnumerator): HResult; stdcall;
	end;

	TCOMEnumerator<T> = class(TCOMObject, ICOMEnumerator)
		private
			_value : IEnumerator;
			_createT : TDWSWrapperCreator;
		public
			constructor Create(value: IEnumerator; createT : TDWSWrapperCreator); virtual;
			function GetCurrent(out rv: IUnknown): HResult; stdcall;
			function MoveNext(out rv: boolean): HResult; stdcall;
	end;

implementation

{$REGION ' ECOMException implementation '}
procedure SuccessCall(code : HResult);
begin
	if(code <> S_OK) then raise ECOMException.Create(code);
end;

constructor ECOMException.Create(code : HResult);
begin
	self._code := code;
end;

function ECOMException.GetCode() : HResult;
begin
	Result := self._code;
end;
{$ENDREGION ECOMException}

{$REGION ' TCOMObject implementation '}
destructor TCOMObject.Destroy;
begin
	self.Debug('destroyed');
	inherited;
end;

function TCOMObject.SetDebugCallback(callback: TDWSDebugCallback): HRESULT; stdcall;
begin
	_debug := callback;
	Result := S_OK;
end;

procedure TCOMObject.Debug(s: string);
begin
	if (Assigned(self._debug)) then self._debug(s);
end;

function TCOMObject.GetIUnknownForObject() : Pointer;
var
   iface : IInterface;
begin
	if(self.GetInterface(IInterface, iface)) then begin
		iface._AddRef;
		Result := Pointer(iface);
	end else begin
		Result := nil;
	end;
end;


{$ENDREGION TCOMObject}

{$REGION ' TUnicodeString implementation '}
class operator TUnicodeString.Implicit(s: TUnicodeString): String;
var
	ptr : Cardinal;
begin
	ptr := Cardinal(s._address);
	if (ptr <> 0) then begin
		Result := UnicodeString(s._address);
		// LocalFree(ptr);
	end else begin
		Result := '';
	end;
end;
class operator TUnicodeString.Implicit(s: string): TUnicodeString;
var
	rv : TUnicodeString;
	len : Integer;
begin
	len := Length(s);
	if (len > 0) then begin
		len := (len + 1) * SizeOf(WideChar);
		rv._address := PWideChar(LocalAlloc(LMEM_FIXED, len));
		Move(s[1], rv._address^, len);
	end else begin
		rv._address := PWideChar(0);
    end;
	Result := rv;
end;
function TUnicodeString.IsNull() : boolean;
begin
	Result := not Assigned(_address);
end;
function TUnicodeString.IsNullOrEmpty() : boolean;
begin
	Result := not Assigned(_address);
end;
{$ENDREGION TUnicodeString}

{$REGION ' TCOMGenericEnumerable '}
constructor TCOMEnumerable<T>.Create(value: IEnumerable; createT : TDWSWrapperCreator);
begin
	_value := value;
	_createT := createT;
end;

function TCOMEnumerable<T>.GetEnumerator(out rv: ICOMEnumerator): HResult; stdcall;
begin
	 TCOMEnumerator<T>.Create(_value.GetEnumerator(), _createT).GetInterface(ICOMEnumerator, rv);
	 rv._AddRef;
	 Result := S_OK;
end;
{$ENDREGION TCOMGenericEnumerable}

{$REGION ' TCOMGenericEnumerator '}
constructor TCOMEnumerator<T>.Create(value: IEnumerator; createT : TDWSWrapperCreator);
begin
	_value := value;
	_createT := createT;
end;

function TCOMEnumerator<T>.GetCurrent(out rv: IUnknown): HResult; stdcall;
var
	value : TCOMObject;
begin
	value := _createT(_value.Current);
	if(value.GetInterface(IUnknown, rv)) then begin
		rv._AddRef;
		Result := S_OK;
	end else begin
		rv := nil;
		value.Free;
		Result := E_FAIL;
	end;
end;

function TCOMEnumerator<T>.MoveNext(out rv: boolean): HResult; stdcall;
begin

end;

{$ENDREGION TCOMGenericEnumerable}
end.
