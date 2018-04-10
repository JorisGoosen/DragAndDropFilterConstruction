import QtQuick 2.0

ListView {
	id: listOfStuff

	clip: true

	delegate: MouseArea
	{
		width:  ListView.view.width
		height: elementLoader.height

		z: 5

		Loader
		{
			id: elementLoader

			property string listOperator:		type === "operator" ?	operator			: ""
			property string listFunction:		type === "function" ?	functionName		: ""
			property real	listNumber:			type === "number"	?	number				: 1
			property real	listWidth:			parent.width

			anchors.horizontalCenter: parent.horizontalCenter

			sourceComponent: type === "operator" ? operatorComp : type === "function" ? functionComp : type === "number" ? numberComp : type === "separator" ? separatorComp : defaultComp
		}

		onDoubleClicked:
		{
			if(type == "operator")			operatorComp.createObject(scriptColumn, { "operator": operator,			"canBeDragged": true,  "acceptsDrops": true})
			else if(type == "function")		functionComp.createObject(scriptColumn, { "functionName": functionName, "canBeDragged": true,  "acceptsDrops": true, "parameterNames": functionParameters.split(","), "parameterDropKeys": functionParamTypes.split(",") })
			else if(type == "number")		numberComp.createObject(scriptColumn,	{ "value": number,				"canBeDragged": true,  "acceptsDrops": true})
		}

	}

	Component { id: operatorComp;	OperatorDrag	{ canBeDragged: false; operator: listOperator;		acceptsDrops: false} }
	Component { id: functionComp;	FunctionDrag	{ canBeDragged: false; functionName: listFunction;  acceptsDrops: false} }
	Component { id: numberComp;		NumberDrag		{ canBeDragged: false; value: listNumber} }
	Component { id: separatorComp;	Item			{ height: filterConstructor.blockDim; width: listWidth; Rectangle { height: 1; color: "black"; width: listWidth ; anchors.centerIn: parent }  } }
	Component { id: defaultComp;	Text			{ text: "Something wrong!"; color: "red" }  }
}
