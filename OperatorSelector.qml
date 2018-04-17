import QtQuick 2.0

Item
{
	//color: filterConstructor.jaspDarkBlue

	z: 2
	property real horizontalCenterX: width / 2

	Row
	{

		x: parent.horizontalCenterX - (width / 2)

		OperatorDrag			{ operator: "+";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "-";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "*";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorVerticalDrag	{ operator: "/";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "/";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "^";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
        FunctionDrag			{ functionName: "sqrt";	acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef; parameterNames: []; parameterDropKeys: [] }
		OperatorDrag			{ operator: "%";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "==";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "!=";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "<";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "<=";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: ">";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: ">=";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "&";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
		OperatorDrag			{ operator: "|";		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef }
        FunctionDrag			{ functionName: "!";	acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef; parameterNames: []; parameterDropKeys: [] }

	}


	Component { id: operatorComp;		OperatorDrag			{ } }
	Component { id: operatorvertComp;	OperatorVerticalDrag	{ } }
	Component { id: functionComp;		FunctionDrag			{ } }

	property var alternativeDropFunctionDef: function(caller)
	{
		var obj = null

		if(caller.shownChild.objectName === "Operator")					obj = operatorComp.createObject(scriptColumn,		{ "alternativeDropFunction": null, "operator": caller.operator,			"acceptsDrops": true})
		else if(caller.shownChild.objectName === "OperatorVertical")	obj = operatorvertComp.createObject(scriptColumn,	{ "alternativeDropFunction": null, "operator": caller.operator,			"acceptsDrops": true})
        else if(caller.shownChild.objectName === "Function")			obj = functionComp.createObject(scriptColumn,		{ "alternativeDropFunction": null, "functionName": caller.functionName,	"acceptsDrops": true,  "parameterNames": caller.function === "!" ? ["logical(s)"] : ["value(s)"], parameterDropKeys: caller.function === "!" ? ["boolean"] : ["number"] })

		return obj
	}

}
