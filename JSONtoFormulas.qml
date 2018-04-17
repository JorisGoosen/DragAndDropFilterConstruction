import QtQuick 2.0

Item {
	function convertJSONtoFormulas(jsonObj)
	{
		for(var i=0; i<jsonObj.formulas.length; i++)
			convertJSONtoItem(jsonObj.formulas[i], scriptColumn)
	}

	function convertJSONtoItem(jsonObj, dropItHere)
	{
		if(jsonObj === null || jsonObj === undefined) return


		if(jsonObj.nodeType === "Operator" || jsonObj.nodeType === "OperatorVertical")
		{
			var operatorObj = (jsonObj.nodeType === "Operator" ? createOperator(jsonObj.operator) : createOperatorVertical(jsonObj.operator))
			operatorObj.releaseHere(dropItHere)

			convertJSONtoItem(jsonObj.leftArgument, operatorObj.leftDrop)
			convertJSONtoItem(jsonObj.rightArgument, operatorObj.rightDrop)
		}
		else if(jsonObj.nodeType === "Function")
		{
			var parameterNames = []
			var parameterDropKeys = []
			for(var i=0; i<jsonObj.arguments.length; i++)
			{
				parameterNames.push(jsonObj.arguments[i].name)
				parameterDropKeys.push(jsonObj.arguments[i].dropKeys)
			}

			var funcObj = createFunction(jsonObj.functionName, parameterNames, parameterDropKeys)
			funcObj.releaseHere(dropItHere)

			for(var i=0; i<jsonObj.arguments.length; i++)
				convertJSONtoItem(jsonObj.arguments[i].argument, funcObj.getParameterDropSpot(jsonObj.arguments[i].name))
		}
		else if(jsonObj.nodeType === "Number")
				createNumber(jsonObj.value).releaseHere(dropItHere)
		else if(jsonObj.nodeType === "String")
				createString(jsonObj.text).releaseHere(dropItHere)
		else if(jsonObj.nodeType === "Column")
				createColumn(jsonObj.columnName, jsonObj.columnIcon).releaseHere(dropItHere)
	}

	function createOperator(operator)						{ return operatorComp.createObject(scriptColumn,		{ "operator": operator } ) }
	function createOperatorVertical(operator)				{ return operatorvertComp.createObject(scriptColumn,	{ "operator": operator } ) }
	function createFunction(functionName,
							parameterNames,
							parameterDropKeys)				{ return functionComp.createObject(scriptColumn,		{ "functionName": functionName,	"parameterNames": parameterNames, "parameterDropKeys": parameterDropKeys } ) }
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
