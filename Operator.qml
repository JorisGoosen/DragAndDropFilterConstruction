import QtQuick 2.0


MouseArea
{
	property int initialWidth: filterConstructor.blockDim * 3
	property string operator: "+"

	id: mouseArea

	drag.target: dragme

	height: dragme.height
	width: dragme.width

	property var oldParent: null

	onPressed:
	{
		oldParent = parent

		if(!(mouse.x <= haakjesLinks.width || mouse.x > haakjesRechts.x || ( mouse.x > opText.x && mouse.x < rightDrop.x)))
			mouse.accepted = false
	}

	onReleased:
	{
		if(oldParent.objectName === "DropTile" && dragme.Drag.target != oldParent )
		{
			oldParent.width = oldParent.implicitWidth
			oldParent.containsSomething = false
		}

		parent = dragme.Drag.target !== null ? dragme.Drag.target : oldParent

		if(parent == getIntoTheFlow && oldParent == getIntoTheFlow)
		{
			parent = null
			parent = getIntoTheFlow
		}


		mouseArea.x = 0//Qt.binding(function() { return opText.x })
		mouseArea.y = 0
		dragme.x = 0
		dragme.y = 0

		if(parent.objectName === "DropTile")
		{
			parent.width = Qt.binding(function() { return mouseArea.width })
			parent.containsSomething = true
		}
	}

	Item
	{
		property string colorKey: "red"
		Drag.keys: [ colorKey ]
		id: dragme
		Drag.active: mouseArea.drag.active
		Drag.hotSpot.x: width / 2
		Drag.hotSpot.y: height / 2


		height: filterConstructor.blockDim
		width: haakjesLinks.width + leftDrop.width + opText.width + rightDrop.width + haakjesRechts.width
		//anchors.fill: parent

		//anchors.verticalCenter: mouseArea.verticalCenter
		//anchors.horizontalCenter: mouseArea.horizontalCenter

		Text
		{
			id: haakjesLinks
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mouseArea.initialWidth / 8

			text: "("
			font.pixelSize: parent.height * 0.8
		}

		DropTile {
			id: leftDrop
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			x: haakjesLinks.width

			colorKey: "red"

			width: implicitWidth
			implicitWidth: mouseArea.initialWidth / 4
		}

		Text
		{
			id: opText
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mouseArea.initialWidth / 4
			x: leftDrop.x + leftDrop.width

			text: mouseArea.operator
			font.pixelSize: parent.height
		}

		DropTile {
			id: rightDrop
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: implicitWidth
			implicitWidth: mouseArea.initialWidth / 4
			x: opText.x + opText.width

			colorKey: "red"
		}

		Text
		{
			id: haakjesRechts
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mouseArea.initialWidth / 8
			x: rightDrop.x + rightDrop.width

			text: ")"
			font.pixelSize: parent.height * 0.8
		}

		states: [
			State {
				when: mouseArea.drag.active
				ParentChange { target: dragme; parent: getIntoTheFlow }
				AnchorChanges { target: dragme; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
			},
			State {
				when: !mouseArea.drag.active
				AnchorChanges { target: dragme; anchors.verticalCenter: mouseArea.verticalCenter; anchors.horizontalCenter: mouseArea.horizontalCenter }
			}
		]



	}
}
