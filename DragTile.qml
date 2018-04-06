import QtQuick 2.0


MouseArea {
	id: mouseArea

	property string colorKey
	property Component delegate: null

	drag.target: dragme

	property var oldParent: null

	onPressed: oldParent = parent

	onReleased:
	{
		if(oldParent.objectName === "DropSpot" && dragme.Drag.target != oldParent )
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

		dragme.x = 0
		dragme.y = 0
		mouseArea.x = 0
		mouseArea.y = 0

		if(parent.objectName === "DropSpot")
		{
			parent.width = Qt.binding(function() { return dragme.width })
			parent.containsSomething = true
		}
	}


	Item {
		id: dragme

		width: mouseArea.width
		height: mouseArea.height
		x: mouseArea.x
		y: mouseArea.y

		Drag.keys: [ colorKey ]
		Drag.active: mouseArea.drag.active
		Drag.hotSpot.x: width / 2
		Drag.hotSpot.y: height / 2

		Loader
		{
			sourceComponent: delegate
			height: dragme.height
			width: dragme.width

			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
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



