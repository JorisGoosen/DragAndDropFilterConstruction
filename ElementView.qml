import QtQuick 2.0

ListView {
	id:listOfStuff

	property bool containsSomething: false //to avoid errormessages from DragTile

	model: ListModel
	{
		ListElement { name: "Number";	element: "numberComp";		value: 1}
		ListElement { name: "Number";	element: "numberComp";		value: 1.2}
		ListElement { name: "Number";	element: "numberComp";		value: 8}
		ListElement { name: "Number";	element: "numberComp";		value: 6}
		ListElement { name: "Operator";	element: "operatorComp";	operator: "*"}
		ListElement { name: "Operator";	element: "operatorComp";	operator: "+"}
		ListElement { name: "Operator";	element: "operatorComp";	operator: "%"}
	}

	delegate: MouseArea
	{
		width:  ListView.view.width
		height: elementLoader.height

		property var chosenComponent: element == "numberComp" ? numberComp : operatorComp

		Loader
		{
			id: elementLoader
			sourceComponent: parent.chosenComponent
			property var listValue: value
			property var listOperator: operator
			anchors.horizontalCenter: parent.horizontalCenter
		}

		onDoubleClicked: { chosenComponent.createObject(getIntoTheFlow, { "value": value, "operator": operator, "canBeDragged": true}) }
	}

	Component { id: numberComp;		NumberDrag		{ canBeDragged: false; value: listValue} }
	Component { id: operatorComp;	OperatorDrag	{ canBeDragged: false; operator: listOperator} }

}
