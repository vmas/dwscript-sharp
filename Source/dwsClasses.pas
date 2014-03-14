unit dwsClasses;

interface

uses
	dwsComp,
	dwsExprs,
	dwsSymbols,
	DWSGenericType,
	dwsCoreExprs,
//	Dialogs,
	ComObj,
	Windows,
	dwsCOMTypes;


type
	TDWSErrorCallback = procedure(const error: string); cdecl;
	TDWSIncludeCallback = function(const scriptName: string): TUnicodeString; safecall;
	TCOMCallback = procedure(const obj: IUnknown); safecall;

	IDWSGenericTypeDefinition = interface
		['{5FA48473-A1C0-4F40-BFAE-94A207115B09}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetFields(out rv: ICOMEnumerable): HResult; stdcall;
	end;

	IDWSGenericMethodDefinition = interface
		['{753549A4-82D4-4C45-ACD0-D25A4A18EFA3}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetArgs(out rv: ICOMEnumerable): HResult; stdcall;
		function GetReturnTypeName(out rv: TUnicodeString): HResult; stdcall;
		function GetCallback(out rv : TCOMCallback) : HResult; stdcall;
		function GetIsOverloaded(out rv : Boolean) : HRESULT; stdcall;
	end;

	IDWSGenericArrayDefinition = interface
		['{F406C38C-9E16-44FA-A34B-025CFA23BD52}']
		function GetName(out rv: TUnicodeString): HResult; stdcall;
		function GetElementsTypeName(out rv: TUnicodeString): HResult; stdcall;
		function GetIsDynamic(out rv: Boolean): HResult; stdcall;
		function GetLowBound(out rv: Int32): HResult; stdcall;
		function GetHighBound(out rv: Int32): HResult; stdcall;
	end;

	IDWSContext = interface
		['{FFE89EEB-45BF-43E0-826C-7BB5D95F5027}']
		function SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
		function SetIncludeCallback(callback: TDWSIncludeCallback): HRESULT; stdcall;
		function DefineType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineRecordType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineArrayType(typedefinition: IDWSGenericArrayDefinition): HRESULT; stdcall;
		function DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
		function Evaluate(code: TUnicodeString; out rv : TUnicodeString): HRESULT; stdcall;
		function Stop(): HRESULT; stdcall;
		function DefineEnumType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
	end;

	TDWSContext = class(TCOMObject, IDWSContext)
	private
		_scope: TdwsUnit;
		_runtime: TDelphiWebScript;
		_errorCallback: TDWSErrorCallback;
		_includeCallback: TDWSIncludeCallback;
		_context : IdwsProgram;
		_assembly : IdwsProgramExecution;

		procedure ReportError(error: string);
	public
		constructor Create(runtime: TDelphiWebScript);
		destructor Destroy(); override;
		procedure dwsIncludeCallback(const scriptName: string; var scriptSource: string);

		function SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
		function SetIncludeCallback(callback: TDWSIncludeCallback): HRESULT; stdcall;
		function DefineType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineRecordType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineArrayType(typedefinition: IDWSGenericArrayDefinition): HRESULT; stdcall;
		function DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
		function Evaluate(code: TUnicodeString; out rv : TUnicodeString): HRESULT; stdcall;
		function Stop(): HRESULT; stdcall;
		function DefineEnumType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
	end;

	IDWSRuntime = interface
		['{564CEE22-7FEA-429A-A6F9-76FBAA94EA65}']
		function NewContext(out rv: IDWSContext) : HRESULT; stdcall;
	end;

	TDWSRuntime = class(TCOMObject, IDWSRuntime)
		private
			_dws : TDelphiWebScript;
		public
			constructor Create();
			destructor Destroy(); override;
			function NewContext(out rv: IDWSContext) : HRESULT; stdcall;
    end;

	TMethodProxy = class(TCOMObject)
		private
			_context : TDWSContext;
			_function : TdwsFunction;
			_callback : TCOMCallback;
		public
			constructor Create(context : TDWSContext; func : TdwsFunction; callback : TCOMCallback);
			procedure dwsEvalCallback(info : TProgramInfo);
	end;



implementation

constructor TDWSRuntime.Create();
begin
	_dws := TDelphiWebScript.Create(nil);
end;

destructor TDWSRuntime.Destroy();
begin
	_dws.Free;
	inherited;
end;

function TDWSRuntime.NewContext(out rv: IDWSContext) : HRESULT; stdcall;
begin
	TDWSContext.Create(_dws).GetInterface(IDWSContext, rv);
	rv._AddRef();
	Result := S_OK;
end;

{$REGION ' TDWSContext implementation '}
{$REGION ' private methods ' }

procedure TDWSContext.ReportError(error: string);
begin
	// if(_errorCallback <> nil) then
	if (Assigned(_errorCallback)) then
		_errorCallback(error);
end;

{$ENDREGION private methods }

constructor TDWSContext.Create(runtime: TDelphiWebScript);
begin
	_errorCallback := nil;
	_runtime := runtime;
	_runtime.OnInclude := self.dwsIncludeCallback;
	_scope := TdwsUnit.Create(nil);
	_scope.UnitName := 'dwsContext';
	_context := _runtime.Compile(''
+ 'procedure SetLength(a: array of Variant; size: Integer);'#13#10
+ 'begin'#13#10
+ '	a.SetLength(size);'#13#10
+ 'end;'#13#10

);
	_assembly := _context.BeginNewExecution();
	_assembly.BeginProgram();
	_assembly.RunProgram(0);
	_assembly.EndProgram();
end;

destructor TDWSContext.Destroy();
begin
	_scope.Destroy;
	inherited;
end;

function TDWSContext.SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
begin
	self._errorCallback := callback;
	Result := S_OK;
end;

function TDWSContext.SetIncludeCallback(callback: TDWSIncludeCallback): HRESULT; stdcall;
begin
	self._includeCallback := callback;
	Result := S_OK;
end;

procedure TDWSContext.dwsIncludeCallback(const scriptName: string; var scriptSource: string);
begin
	scriptSource := self._includeCallback(scriptName);
end;

function TDWSContext.DefineType(typedefinition: IDWSGenericTypeDefinition) : HRESULT; stdcall;
var
	name, typeName : TUnicodeString;
	members : ICOMEnumerable;
	enumerator : ICOMEnumerator;
	ok : boolean;
	unkObj : IUnknown;
	fieldDef : IDWSFieldDefinition;
	c: TdwsClass;
	f: TdwsField;
	vi: Integer;
begin
	Result := E_FAIL;
	if((typedefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	if((_scope.Records.IndexOf(name) <> -1) or (_scope.Classes.IndexOf(name) <> -1) or (_scope.Enumerations.IndexOf(name) <> -1))
		then Exit(E_ABORT);

	c := _scope.Classes.Add();
	try
		try
			c.Name := name;

			SuccessCall(typedefinition.GetFields(members));
			if(members = nil)
				then raise ECOMException.Create(E_UNEXPECTED);
			SuccessCall(members.GetEnumerator(enumerator));
			if(enumerator = nil) then
				raise ECOMException.Create(E_UNEXPECTED);
			while(true) do begin
				SuccessCall(enumerator.MoveNext(ok));
				if(not ok) then break;
				SuccessCall(enumerator.GetCurrent(unkObj));
				fieldDef := unkObj as IDWSFieldDefinition;
				if(fieldDef = nil) then
					raise ECOMException.Create(E_UNEXPECTED);
				SuccessCall(fieldDef.GetName(name));
				SuccessCall(fieldDef.GetTypeName(typeName));
				SuccessCall(fieldDef.GetModifier(vi));
				if(name.IsNullOrEmpty() or typeName.IsNullOrEmpty()) then
					raise ECOMException.Create(E_UNEXPECTED);

				f := c.Fields.Add();
				f.Name := name;
				f.DataType := typeName;
				f.Visibility := TdwsVisibility(vi);
			end;
			Result := S_OK;
		except
			on E : ECOMException do begin
				Result := E.Code;
			end;
		end;
	finally
	   if(Result <> S_OK) then begin
			_scope.Classes.Delete(_scope.Classes.IndexOf(c.Name));
			c.Free;
	   end;
	end;

end;

function TDWSContext.DefineRecordType(typedefinition: IDWSGenericTypeDefinition) : HRESULT; stdcall;
var
	name, typeName : TUnicodeString;
	members : ICOMEnumerable;
	enumerator : ICOMEnumerator;
	ok : boolean;
	unkObj : IUnknown;
	fieldDef : IDWSFieldDefinition;
	c: TdwsRecord;
	f: TdwsMember;
	vi: Integer;
begin
	Result := E_FAIL;
	if((typedefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	if((_scope.Records.IndexOf(name) <> -1) or (_scope.Classes.IndexOf(name) <> -1) or (_scope.Enumerations.IndexOf(name) <> -1))
		then Exit(E_ABORT);

	c := _scope.Records.Add();
	try
		try
			c.Name := name;
			SuccessCall(typedefinition.GetFields(members));
			if(members = nil)
				then raise ECOMException.Create(E_UNEXPECTED);
			SuccessCall(members.GetEnumerator(enumerator));
			if(enumerator = nil) then
				raise ECOMException.Create(E_UNEXPECTED);
			while(true) do begin
				SuccessCall(enumerator.MoveNext(ok));
				if(not ok) then break;
				SuccessCall(enumerator.GetCurrent(unkObj));
				fieldDef := unkObj as IDWSFieldDefinition;
				if(fieldDef = nil) then
					raise ECOMException.Create(E_UNEXPECTED);
				SuccessCall(fieldDef.GetName(name));
				SuccessCall(fieldDef.GetTypeName(typeName));
				SuccessCall(fieldDef.GetModifier(vi));
				if(name.IsNullOrEmpty() or typeName.IsNullOrEmpty()) then
					raise ECOMException.Create(E_UNEXPECTED);

				f := c.Members.Add();
				f.Name := name;
				f.DataType := typeName;
				f.Visibility := TdwsVisibility(vi);
			end;
			Result := S_OK;
		except
			on E : ECOMException do begin
				Result := E.Code;
			end;
		end;
	finally
	   if(Result <> S_OK) then begin
			_scope.Records.Delete(_scope.Records.IndexOf(c.Name));
			c.Free;
	   end;
	end;

end;

function TDWSContext.DefineEnumType(typedefinition: IDWSGenericTypeDefinition) : HRESULT; stdcall;
var
	name : TUnicodeString;
	members : ICOMEnumerable;
	enumerator : ICOMEnumerator;
	ok : boolean;
	unkObj : IUnknown;
	elemDef : IDWSElementDefinition;
	c: TdwsEnumeration;
	f: TdwsElement;
	v: Integer;
begin
	Result := E_FAIL;
	if((typedefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	if((_scope.Records.IndexOf(name) <> -1) or (_scope.Classes.IndexOf(name) <> -1) or (_scope.Enumerations.IndexOf(name) <> -1))
		then Exit(E_ABORT);

	c := _scope.Enumerations.Add();
	try
		try
			c.Name := name;
			SuccessCall(typedefinition.GetFields(members));
			if(members = nil)
				then raise ECOMException.Create(E_UNEXPECTED);
			SuccessCall(members.GetEnumerator(enumerator));
			if(enumerator = nil) then
				raise ECOMException.Create(E_UNEXPECTED);
			while(true) do begin
				SuccessCall(enumerator.MoveNext(ok));
				if(not ok) then break;
				SuccessCall(enumerator.GetCurrent(unkObj));
				elemDef := unkObj as IDWSElementDefinition;
				if(elemDef = nil) then
					raise ECOMException.Create(E_UNEXPECTED);

				SuccessCall(elemDef.GetName(name));
				SuccessCall(elemDef.GetValue(v));

				f := c.Elements.Add();
				f.Name := name;
				f.DisplayName := name;
				f.IsUserDef := True;
				f.UserDefValue := v;
			end;
			Result := S_OK;
		except
			on E : ECOMException do begin
				Result := E.Code;
			end;
		end;
	finally
	   if(Result <> S_OK) then begin
			_scope.Enumerations.Delete(_scope.Enumerations.IndexOf(c.Name));
			c.Free;
	   end;
	end;

end;

function TDWSContext.DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
var
	name, typeName, s : TUnicodeString;
	args : ICOMEnumerable;
	enumerator : ICOMEnumerator;
	ok, boolVal : boolean;
	unkObj : IUnknown;
	fieldDef : IDWSFieldDefinition;
	fun: TdwsFunction;
	param: TdwsParameter;
	callback : TCOMCallback;
	proxy : TMethodProxy;
	i : integer;
begin
	Result := E_FAIL;
	if((methoddefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	i := _scope.Functions.IndexOf(name);
	if(i >= 0) then begin
		fun := TdwsFunction(_scope.Functions.Items[i]);
		if (not fun.Overloaded) then Exit(E_ABORT);
	end;

	fun := _scope.Functions.Add();
	try
		try
			fun.Name := name;
			SuccessCall(methoddefinition.GetIsOverloaded(boolVal));
			fun.Overloaded := boolVal;
			SuccessCall(methoddefinition.GetCallback(callback));
			proxy := TMethodProxy.Create(self, fun, callback);
			fun.OnEval := proxy.dwsEvalCallback;
			SuccessCall(methoddefinition.GetArgs(args));
			if(args <> nil) then begin
				SuccessCall(args.GetEnumerator(enumerator));
				if(enumerator = nil) then
					raise ECOMException.Create(E_UNEXPECTED);

				while(true) do begin
					SuccessCall(enumerator.MoveNext(ok));
					if(not ok) then break;
					SuccessCall(enumerator.GetCurrent(unkObj));
					fieldDef := unkObj as IDWSFieldDefinition;
					if(fieldDef = nil) then
						raise ECOMException.Create(E_UNEXPECTED);

					SuccessCall(fieldDef.GetName(name));
					SuccessCall(fieldDef.GetTypeName(typeName));
					if(name.IsNullOrEmpty() or typeName.IsNullOrEmpty()) then
						raise ECOMException.Create(E_UNEXPECTED);




					param := fun.Parameters.Add();
					param.Name := name;
					param.DataType := typeName;

					SuccessCall(fieldDef.GetIsVarParam(ok));
					param.IsVarParam := ok;

					SuccessCall(fieldDef.GetHasDefaultValue(ok));
					param.HasDefaultValue := ok;
					if (param.HasDefaultValue) then begin
						SuccessCall(fieldDef.GetDefaultValue(s));
						param.DefaultValue := string(s);
					end;

				end;
			end;
			SuccessCall(methoddefinition.GetReturnTypeName(name));
			if(not name.IsNullOrEmpty()) then
				fun.ResultType := name;

			proxy.GetInterface(IUnknown, method);
			method._AddRef();
			Result := S_OK;
		except
			on E : ECOMException do begin
				Result := E.Code;
			end;
		end;
	finally
	   if(Result <> S_OK) then begin
			_scope.Functions.Delete(_scope.Functions.IndexOf(fun.Name));
			fun.Free;
	   end;
	end;
end;

function TDWSContext.DefineArrayType(typedefinition: IDWSGenericArrayDefinition): HRESULT; stdcall;
var
	name, typeName : TUnicodeString;
	b : Boolean;
	n : Integer;
	a : TdwsArray;
begin
	Result := E_FAIL;
	if((typedefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	if(_scope.Arrays.IndexOf(name) <> -1)
		then Exit(E_ABORT);

	a := TdwsArray(_scope.Arrays.Add());
	try
		try
			a.Name := name;
			SuccessCall(typedefinition.GetElementsTypeName(typeName));
			if(typeName.IsNullOrEmpty()) then
				raise ECOMException.Create(E_UNEXPECTED);
			a.DataType := typeName;
			SuccessCall(typedefinition.GetIsDynamic(b));
			a.IsDynamic := b;
			if(not b) then begin
				SuccessCall(typedefinition.GetLowBound(n));
				a.LowBound := n;
				SuccessCall(typedefinition.GetHighBound(n));
				a.HighBound := n;
            end;
			Result := S_OK;
		except
			on E : ECOMException do begin
				Result := E.Code;
			end;
		end;
	finally
	   if(Result <> S_OK) then begin
			_scope.Arrays.Delete(_scope.Arrays.IndexOf(a.Name));
			a.Free;
	   end;
	end;

end;

function TDWSContext.Evaluate(code: TUnicodeString; out rv : TUnicodeString): HRESULT; stdcall;
var
	s : string;
begin
	_runtime.AddUnit(_scope);
	try
		s := code;
		s := 'uses dwsContext;' + #13#10 + s;
		_assembly.Result.Clear();
		_assembly.Msgs.Clear();
		_context.Msgs.Clear();

		_runtime.RecompileInContext(_context, s);
		if not _context.Msgs.HasErrors then begin
			_assembly.BeginProgram();
			_assembly.RunProgram(0);
			_assembly.EndProgram();
			if _assembly.Msgs.HasErrors then begin
				self.ReportError(_assembly.Msgs.AsInfo);
			end;
		end else begin
			self.ReportError(_context.Msgs.AsInfo);
		end;

		rv := _assembly.Result.ToString();
	finally
		_runtime.RemoveUnit(_scope);
	end;
	Result := S_OK;
end;

function TDWSContext.Stop(): HRESULT; stdcall;
begin
	_assembly.Stop();
	Result := S_OK;
end;

{$ENDREGION}

{$REGION ' TMethodProxy implementation '}
constructor TMethodProxy.Create(context : TDWSContext; func: TdwsFunction; callback: TCOMCallback);
begin
	_context := context;
	_function := func;
	_callback := callback
end;

procedure  TMethodProxy.dwsEvalCallback(info: TProgramInfo);
var
	comInfo: TDWSProgramInfo;
begin
	comInfo := TDWSProgramInfo.Create(Info);
	_callback(comInfo);
end;
{$ENDREGION ' TMethodProxy '}




end.
