import QtQuick 2.0


MouseArea {
	id: mouseArea

	property bool canBeDragged: true

	property real dragHotSpotX: width / 2
	property real dragHotSpotY: height / 2

	property real dragX: dragMe.x - mapToItem(dragMe.parent, 0, 0).x
	property real dragY: dragMe.y - mapToItem(dragMe.parent, 0, 0).y


	objectName: "DragGeneric"
	property var shownChild: null
	property alias dragChild: dragMe

	width: shownChild == null ? implicitWidth : shownChild.width
	height: shownChild == null ? implicitHeight : shownChild.height

	property bool nested: parent !== null && parent.objectName === "DropSpot" && parent.droppedShouldBeNested



	property var dropKeys: [ "number", "boolean", "string", "variable" ] //all possible options by default

	drag.target: dragMe

	property var oldParent: null

	onPressed:
	{
		oldParent = parent

		if(!showMe.shouldDrag(mouse) || !canBeDragged)
			mouse.accepted = false
		else
		{
			dragHotSpotX = mouse.x
			dragHotSpotY = mouse.y
		}
	}

	onReleased:
	{
		if(dragMe.Drag.target != null && dragMe.Drag.target.objectName === "DropTrash")
		{
			destroy();
			return;
		}

		if(oldParent.objectName === "DropSpot" && dragMe.Drag.target != oldParent )
		{
			oldParent.width = oldParent.implicitWidth
			oldParent.containsItem = null
		}


		parent = dragMe.Drag.target !== null ? dragMe.Drag.target : scriptColumn

		if(parent == oldParent ) { parent = null; parent = oldParent }

		dragMe.x = 0
		dragMe.y = 0
		mouseArea.x = 0
		mouseArea.y = 0

		if(parent.objectName === "DropSpot")
		{
			parent.width = Qt.binding(function() { return dragMe.width })
			parent.containsItem = this
		}
	}


	Item {
		id: dragMe

		width: mouseArea.width
		height: mouseArea.height
		x: mouseArea.x
		y: mouseArea.y

		Drag.keys: dropKeys
		Drag.active: mouseArea.drag.active
		Drag.hotSpot.x: dragHotSpotX
		Drag.hotSpot.y: dragHotSpotY

		states: [
			State {
			when: mouseArea.drag.active
			ParentChange { target: dragMe; parent: filterConstructor }
			AnchorChanges { target: dragMe; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
		},

		State {
			when: !mouseArea.drag.active
			AnchorChanges { target: dragMe; anchors.verticalCenter: mouseArea.verticalCenter; anchors.horizontalCenter: mouseArea.horizontalCenter }
		}
		]

	}
}



