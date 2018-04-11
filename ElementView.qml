import QtQuick 2.0

ListView {
	id: listOfStuff

	//clip: true

	delegate: MouseArea
	{
		width:  ListView.view.width
		height: elementLoader.height

		z: 5

		property var alternativeDropFunctionDef: function(targetLoc)
		{
			var obj = null

			if(type == "operator")			obj = operatorComp.createObject(scriptColumn,	{ "alternativeDropFunction": null, "operator": operator,			"acceptsDrops": true})
			else if(type == "function")		obj = functionComp.createObject(scriptColumn,	{ "alternativeDropFunction": null, "functionName": functionName,	"acceptsDrops": true, "parameterNames": functionParameters.split(","), "parameterDropKeys": functionParamTypes.split(",") })
			else if(type == "number")		obj = numberComp.createObject(scriptColumn,		{ "alternativeDropFunction": null, "value": number,					"acceptsDrops": true})
			else if(type == "string")		obj = stringComp.createObject(scriptColumn,		{ "alternativeDropFunction": null, "text": text,					"acceptsDrops": true})

			return obj
		}

		Loader
		{
			id: elementLoader

			property string listOperator:		type === "operator" ?	operator			: "???"
			property string listFunction:		type === "function" ?	functionName		: "???"
			property real	listNumber:			type === "number"	?	number				: -1
			property string	listText:			type === "string"	?	text				: "???"
			property real	listWidth:			parent.width


			anchors.horizontalCenter: parent.horizontalCenter

			sourceComponent: type === "operator" ? operatorComp : type === "function" ? functionComp : type === "number" ? numberComp : type === "string" ? stringComp : type === "separator" ? separatorComp : defaultComp
		}

		onDoubleClicked: alternativeDropFunctionDef()

		Component { id: operatorComp;	OperatorDrag	{ operator: listOperator;		acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef } }
		Component { id: functionComp;	FunctionDrag	{ functionName: listFunction;	acceptsDrops: false;	alternativeDropFunction: alternativeDropFunctionDef } }
		Component { id: numberComp;		NumberDrag		{ value: listNumber;									alternativeDropFunction: alternativeDropFunctionDef } }
		Component { id: stringComp;		StringDrag		{ text: listText;										alternativeDropFunction: alternativeDropFunctionDef } }
		Component { id: separatorComp;	Item			{ height: filterConstructor.blockDim; width: listWidth; Rectangle { height: 1; color: "black"; width: listWidth ; anchors.centerIn: parent }  } }
		Component { id: defaultComp;	Text			{ text: "Something wrong!"; color: "red" }  }
	}


}
