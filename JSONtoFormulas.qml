import QtQuick 2.0

Item {
	function convertJSONtoFormulas(jsonObj)
	{
		console.log(jsonObj)
		for(var i=0; i<jsonObj.formulas.length; i++)
			convertJSONtoItem(jsonObj.formulas[i]).releaseHere(scriptColumn)
	}

	function convertJSONtoItem(jsonObj)
	{
		if(jsonObj === null || jsonObj === undefined) return

		if(jsonObj.nodeType === "Operator" || jsonObj.nodeType === "OperatorVertical")
		{
			var operatorObj = createOperator(jsonObj.operator)
			releaseher of zo?

											 HIER VERDER GAAN!


			convertJSONtoItem(jsonObj.leftArgument)
			convertJSONtoItem(jsonObj.rightArgument)
		}
		else if(jsonObj.nodeType === "Function")
			for(var i=0; i<jsonObj.arguments.length; i++)
				convertJSONtoItem(jsonObj.arguments[i].argument)
	}

	function createOperator(operator)						{ return operatorComp.createObject(scriptColumn,		{ "operator": operator } ) }
	function createOperatorVertical(operator)				{ return operatorvertComp.createObject(scriptColumn,	{ "operator": operator } ) }
	function createFunction(functionName, parameterNames)	{ return functionComp.createObject(scriptColumn,		{ "functionName": functionName,	"parameterNames": parameterNames, "parameterDropKeys": parameterDropKeys } ) }
	function createNumber(number)							{ return numberComp.createObject(scriptColumn,			{ "value": number } ) }
	function createString(text)								{ return stringComp.createObject(scriptColumn,			{ "text": text } ) }
	function createColumn(columnName, columnIcon)			{ return columnComp.createObject(scriptColumn,			{ "columnName": columnName,	"columnIcon": columnIcon } ) }


	Component { id: operatorComp;		OperatorDrag			{ } }
	Component { id: operatorvertComp;	OperatorVerticalDrag	{ } }
	Component { id: functionComp;		FunctionDrag			{ } }
	Component { id: numberComp;			NumberDrag				{ } }
	Component { id: stringComp;			StringDrag				{ } }
	Component {	id: columnComp;			ColumnDrag				{ } }


}
