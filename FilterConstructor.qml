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

		NumberDrag	{}

		OperatorDrag {}

		OperatorDrag { operator: "-" }
		OperatorDrag { operator: "*" }
		OperatorDrag { operator: "%" }
		OperatorDrag { operator: "/" }
		OperatorDrag { operator: "~" }

		NumberDrag { value: 1 }
		NumberDrag { value: 2 }
		NumberDrag { value: 3 }
		NumberDrag { value: 4 }
		NumberDrag { value: 5 }
		NumberDrag { value: 6 }


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
