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

	delegate: Loader
	{
		sourceComponent: element == "numberComp" ? numberComp : operatorComp
		property var listValue: value
		property var listOperator: operator
	}

	Component { id: numberComp;		Number		{ value: listValue} }
	Component { id: operatorComp;	Operator	{ operator: listOperator} }

}
