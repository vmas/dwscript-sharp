unit dwsClasses;

interface

uses
	dwsComp,
	dwsExprs,
	dwsSymbols,
	DWSGenericType,
	dwsCoreExprs,
//	Dialogs,
	Windows,
	dwsCOMTypes;


type
	TDWSErrorCallback = procedure(const error: string); cdecl;
	TCOMCallback = procedure(const obj: IUnknown); cdecl;

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
		['{A4E0EADC-E8F2-4388-B2BD-7B5DA5B1694D}']
		function SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
		function DefineType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineRecordType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineArrayType(typedefinition: IDWSGenericArrayDefinition): HRESULT; stdcall;
		function DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
		function Evaluate(code: TUnicodeString; out rv : TUnicodeString): HRESULT; stdcall;
		function Stop(): HRESULT; stdcall;
	end;

	TDWSContext = class(TCOMObject, IDWSContext)
	private
		_scope: TdwsUnit;
		_runtime: TDelphiWebScript;
		_errorCallback: TDWSErrorCallback;
		_context : IdwsProgram;
		_assembly : IdwsProgramExecution;

		procedure ReportError(error: string);
	public
		constructor Create(runtime: TDelphiWebScript);
		destructor Destroy(); override;
		function SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
		function DefineType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineRecordType(typedefinition: IDWSGenericTypeDefinition): HRESULT; stdcall;
		function DefineArrayType(typedefinition: IDWSGenericArrayDefinition): HRESULT; stdcall;
		function DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
		function Evaluate(code: TUnicodeString; out rv : TUnicodeString): HRESULT; stdcall;
		function Stop(): HRESULT; stdcall;
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

	IDWSProgramInfo = interface
		['{6CDAC2C3-0175-4566-AEFB-7F1B1E59E39C}']
		function GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
		function SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
		function SetResultAsInt64(value: Int64): HRESULT; stdcall;
		function SetResultAsDouble(value: Double): HRESULT; stdcall;
		function SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
		function CreateTypedValue(typeName: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
	end;

	TDWSProgramInfo = class(TCOMObject, IDWSProgramInfo)
	private
		_info: TProgramInfo;
		_context: TDWSContext;
	public
		constructor Create(context: TDWSContext; Info: TProgramInfo);
		function GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
		function SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
		function SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
		function SetResultAsInt64(value: Int64): HRESULT; stdcall;
		function SetResultAsDouble(value: Double): HRESULT; stdcall;
		function SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
		function CreateTypedValue(typeName : TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
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
	_scope := TdwsUnit.Create(nil);
	_scope.UnitName := 'dwsContext';
	_context := _runtime.Compile('');
	_assembly := _context.BeginNewExecution();

end;

destructor TDWSContext.Destroy();
begin
	_assembly.EndProgram();
	_scope.Destroy;
	inherited;
end;

function TDWSContext.SetErrorCallback(callback: TDWSErrorCallback): HRESULT; stdcall;
begin
	self._errorCallback := callback;
	Result := S_OK;
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
	if((_scope.Records.IndexOf(name) <> -1) or (_scope.Classes.IndexOf(name) <> -1))
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
	if((_scope.Records.IndexOf(name) <> -1) or (_scope.Classes.IndexOf(name) <> -1))
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

function TDWSContext.DefineMethod(methoddefinition: IDWSGenericMethodDefinition; out method : IUnknown): HRESULT; stdcall;
var
	name, typeName, s : TUnicodeString;
	args : ICOMEnumerable;
	enumerator : ICOMEnumerator;
	ok : boolean;
	unkObj : IUnknown;
	fieldDef : IDWSFieldDefinition;
	fun: TdwsFunction;
	param: TdwsParameter;
	callback : TCOMCallback;
	proxy : TMethodProxy;
begin
	Result := E_FAIL;
	if((methoddefinition.GetName(name) <> S_OK) or name.IsNullOrEmpty())
		then Exit(E_UNEXPECTED);
	if(_scope.Functions.IndexOf(name) <> -1)
		then Exit(E_ABORT);

	fun := _scope.Functions.Add();
	try
		try
			fun.Name := name;
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
		s := 'uses dwsContext;' + #13#10 + code;
		_assembly.Result.Clear();
		_runtime.RecompileInContext(_context, s);
		if _context.Msgs.Count = 0 then begin
			_assembly.RunProgram(0);
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
	comInfo := TDWSProgramInfo.Create(_context, Info);
	_callback(comInfo);
end;
{$ENDREGION ' TMethodProxy '}


{$REGION ' TDWSProgramInfo implementation '}
constructor TDWSProgramInfo.Create(context: TDWSContext; Info: TProgramInfo);
begin
	_info := Info;
	_context := context;
end;

function TDWSProgramInfo.GetVariable(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.Vars[name];
	if( v <> nil) then begin
		TDWSGenericTypeValue.Create(name, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.CreateTypedValue(typeName: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.GetTemp(typeName);
	if ((not v.TypeSym.IsBaseType) and (v.TypeSym.ClassName() <> 'TRecordSymbol'))
		then v := v.Method['Create'].Call();

	if( v <> nil) then begin
		TDWSGenericTypeValue.Create('value of ' + typeName, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.GetTypeReference(name: TUnicodeString; out rv: IDWSGenericTypeValue): HRESULT; stdcall;
var
	v : IInfo;
begin
	v := _info.GetTemp(name);
	if( v <> nil) then begin
		TDWSGenericTypeValue.Create(name, v).GetInterface(IDWSGenericTypeValue, rv);
		rv._AddRef;
	end else begin
		rv := nil;
	end;
	Result := S_OK;
end;

function TDWSProgramInfo.SetResultAsString(value: TUnicodeString): HRESULT; stdcall;
begin
	_info.ResultAsString := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsBoolean(value: Boolean): HRESULT; stdcall;
begin
	_info.ResultAsBoolean := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsInt64(value: Int64): HRESULT; stdcall;
begin
	_info.ResultAsInteger := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsDouble(value: Double): HRESULT; stdcall;
begin
	_info.ResultAsFloat := value;
	Result := S_OK;
end;
function TDWSProgramInfo.SetResultAsObject(value: IDWSGenericTypeValue): HRESULT; stdcall;
var
	nativeObj : IDWSNativeGenericTypeValue;
	v : IInfo;
begin
	nativeObj := value as IDWSNativeGenericTypeValue;
	if(nativeObj <> nil) then begin
		v := nativeObj.GetInfo();
		if v <> nil then begin
			_info.ResultVars.Data := v.Data;
			Result := S_OK;
		end else begin
			Result := E_INVALIDARG;
		end;
	end else begin
		Result := E_INVALIDARG;
    end;
end;

{$ENDREGION TDWSProgramInfo}

end.
