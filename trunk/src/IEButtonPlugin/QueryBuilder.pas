unit QureyBuilder;

interface

uses
	StrUtils;
type TQueryItem  = Class

private
  tag: Boolean;
  sbString: String;
  firstString: String;
	otherString: String;
	innerSymbol: String;
//  res: String;
protected
	configOrAnd: String;
  symbol: String;
public
		 constructor Create;
		 Procedure setOr;
     Procedure setAnd;
     Procedure setLike;
     Procedure setEqual;
     Procedure setLargeAndEqual;
     Procedure setLessAndEqual;
     Procedure setNotEqual;
     Procedure setInnerOr;
     Procedure setInnerAnd;
     Procedure setValue(value: String);dynamic;
     Procedure add(item: TQueryItem);
     Function toString:String;dynamic;
End;

type TQueryBuilder = Class

private
      tag: Boolean;
      tableName: String;
      res: String;
  const
      FROM_STRING = 'Select * from ';
      COUNT_STRING = 'Select count(*) from ';
      WHERE_STRING = ' where 1=1 and ';

protected

public
    constructor Create;
    Function getInstance:TQueryBuilder;
    Procedure setTableName(name: String);
    Procedure add(item: TQueryItem);
    Function toString(tag: String):String;
End;



type TQueryItemOfInteger = Class(TQueryItem)

private
    intName: String;
    intValue: String;
    resString: String;
public
    constructor Create(name: String);
    Procedure setValue(value: String);override;
    Function toString:String;override;
End;

type TQueryItemOfString = Class(TQueryItem)

private
    stringName: String;
    stringValue: String;
    resString: String;
public
    constructor Create(name: String);
    procedure setValue(value: String);override;
    Function toString:String;override;
End;
implementation
////////////////////////////////////////////////////////////
constructor TQueryBuilder.Create;
begin
  tag := True;
end;
Function TQueryBuilder.getInstance:TQueryBuilder;
begin
  getInstance := TQueryBuilder.Create;
end;

Procedure TQueryBuilder.setTableName(name: String);
begin
   tableName := name;
end;

Procedure TQueryBuilder.add(item: TQueryItem);
var
  sbString: String;
begin


 		 sbString := item.toString();
     if sbString <> ''  then
     begin
         if tag then
         begin
           tag := False;
           sbString := AnsiReplaceText(sbString, 'and', ' ');
           sbString := AnsiReplaceText(sbString, 'or', '');
         end ;

           res := res + sbString;

     end;

end;

Function TQueryBuilder.toString(tag: String):String;
begin

  if tableName = '' then
  begin
    toString := '';
  end
  else
  begin
  if res = '' then
  begin
    if (tag <> '') and (tag = 'count') then
    begin
     toString := COUNT_STRING + tableName ;
    end
    else
    begin
      toString := FROM_STRING + tableName ;
    end;
  end
  else
  begin
      if (tag <> '') and (tag = 'count') then
    begin
     toString := COUNT_STRING + tableName + WHERE_STRING +res ;
     end
    else
    begin
       toString := FROM_STRING + tableName + WHERE_STRING +res ;
    end;
  end;
  end;
end;

////////////////////////////////////////
constructor TQueryItem.Create;
begin
tag := True;
end;
 procedure TQueryItem.setOr;
 begin
  configOrAnd := ' or ';
 end;
 procedure TQueryItem.setAnd;
 begin
  configOrAnd := ' and ';
 end;
 procedure TQueryItem.setLike;
 begin
  symbol := ' like ';
 end;
procedure TQueryItem.setEqual;
begin
  symbol := ' = ';
end;
procedure TQueryItem.setLargeAndEqual;
begin
  symbol := ' >=';
end;
procedure TQueryItem.setLessAndEqual;
begin
  symbol := ' <=';
end;
procedure TQueryItem.setNotEqual;
begin
  symbol := ' <> ';
end;
procedure TQueryItem.setInnerOr;
begin
  innerSymbol := ' or ';
end;
procedure TQueryItem.setInnerAnd;
begin
  innerSymbol := ' and ';
end;
procedure TQueryItem.setValue(value: String);
begin

end;
procedure TQueryItem.add(item: TQueryItem);
begin
  sbString := item.toString;
  if sbString <> '' then
  begin
    if tag then
     begin
       tag := False;
       firstString := sbString;
     end
     else
     begin
       otherString := sbString;
       tag := True;
     end;

  end;

end;
Function TQueryItem.toString;
begin
  if (configOrAnd ='') OR (firstString ='') OR (innerSymbol ='') OR (otherString ='') then
   begin
    toString := '';
   end
   else
   begin
     toString := configOrAnd + '(' + firstString + innerSymbol + otherString + ')';
   end;
  
end;


//////////////////////////////////////////
constructor TQueryItemOfInteger.Create(name: string);
begin
  inherited Create();
  intName := name;
end;
procedure TQueryItemOfInteger.setValue(value: String);
begin
    intValue := value;
end;
Function TQueryItemOfInteger.toString;
begin
  if (intName = '') OR (intValue = '') OR (symbol = '') then
   begin
    toString := '';
   end
   else
   begin
   if configOrAnd = '' then
   begin
      resString := intName + symbol;
    end
    else
    begin
      resString := configOrAnd + intName + symbol;
   end;
  if symbol = ' like ' then
  begin
   toString := resString + '''%' + intValue + '%''';
  end
   else
   begin
    toString := resString + intValue ;
   end;
   end;

//    toString := intName + InttoStr(intValue);
end;
////////////////////////////////////////////
constructor TQueryItemOfString.Create(name: string);
begin
inherited Create();
stringName := name;
end;
procedure TQueryItemOfString.setValue(value: String);
begin
stringValue := value;
end;
Function TQueryItemOfString.toString;
begin
if (stringName = '') OR (stringValue = '') OR (symbol = '') then
  begin
  toString := '';
  end
  else
  begin

  if configOrAnd = '' then
  begin
    resString := stringName + symbol;
  end
  else
  begin
    resString := configOrAnd + stringName + symbol;
  end;
  if symbol = ' like ' then
  begin
   toString := resString + '''%' + stringValue + '%''';
  end
   else
   begin
    toString := resString + '''' + stringValue + '''';
   end;
   end;
end;
end.
