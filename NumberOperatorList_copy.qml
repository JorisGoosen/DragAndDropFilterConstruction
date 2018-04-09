import QtQuick 2.0

ListView {
	id: listOfStuff

	model: ListModel
	{
		ListElement { operator: "+"}
		ListElement { operator: "-"}
		ListElement { operator: "*"}
		ListElement { operator: "/"}
		ListElement { operator: "%"}
		ListElement { operator: "^"}
	}

	delegate: MouseArea
	{
		width:  ListView.view.width
		height: elementLoader.height

		Loader
		{
			id: elementLoader
			sourceComponent: operatorComp
			property var listOperator: operator
			anchors.horizontalCenter: parent.horizontalCenter
		}

		onDoubleClicked: { operatorComp.createObject(scriptColumn, { "operator": operator, "canBeDragged": true,  "acceptsDrops": true}) }
	}

	Component { id: operatorComp;	OperatorDrag	{ canBeDragged: false; operator: listOperator; acceptsDrops: false} }

}
