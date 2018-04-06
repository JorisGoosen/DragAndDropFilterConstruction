import QtQuick 2.0

Item {

	id: filterConstructor
	property real blockDim: 20

	Column
	{
		id: getIntoTheFlow

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: elements.left
		anchors.bottom: parent.bottom

		Number	{}

		OperatorDragTile {}

		OperatorDragTile { operator: "-" }
		OperatorDragTile { operator: "*" }
		OperatorDragTile { operator: "%" }
		OperatorDragTile { operator: "/" }
		OperatorDragTile { operator: "~" }

		Number { value: 1 }
		Number { value: 2 }
		Number { value: 3 }
		Number { value: 4 }
		Number { value: 5 }
		Number { value: 6 }


	}

	ElementView
	{
		id: elements
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		width: 300
	}
}
