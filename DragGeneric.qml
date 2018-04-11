import QtQuick 2.0


MouseArea {
	id: mouseArea

	z: 2

	property var alternativeDropFunction: null

	property real dragHotSpotX: width / 2
	property real dragHotSpotY: height / 2

	property real dragX: dragMe.x - mapToItem(dragMe.parent, 0, 0).x
	property real dragY: dragMe.y - mapToItem(dragMe.parent, 0, 0).y

	property var leftDropSpot: null //should only contain something for operators I guess?



	objectName: "DragGeneric"
	property var shownChild: null

	property alias dragChild: dragMe

	width: shownChild == null ? implicitWidth : shownChild.width
	height: shownChild == null ? implicitHeight : shownChild.height

	property bool nested: parent !== null && parent.objectName === "DropSpot" && parent.droppedShouldBeNested

	property var dragKeys: [ "number", "boolean", "string", "variable" ] //all possible options by default

	drag.target: dragMe

	property var oldParent: null

	hoverEnabled: true
	cursorShape: (containsMouse && showMe.shouldDrag(mouseX, mouseY)) || drag.active  ? Qt.PointingHandCursor : Qt.ArrowCursor

	onPressed:
	{
		oldParent = parent

		if(!showMe.shouldDrag(mouse.x, mouse.y))
			mouse.accepted = false
		else
		{
			dragHotSpotX = mouse.x
			dragHotSpotY = mouse.y
		}
	}

	onReleased:
	{
		if(alternativeDropFunction !== null)
		{
			var obj = alternativeDropFunction(dragMe.Drag.target)
			if(obj !== null)
				obj.releaseHere(dragMe.Drag.target)
		}
		else
			this.releaseHere(dragMe.Drag.target)
	}

	function releaseHere(dropTarget)
	{
		if(oldParent === null && dropTarget === null) //just created and not dropped anywhere specific!
		{
			var newDropTarget = this.determineReasonableInsertionSpot() //So lets try to find a better place, make it as userfriendly as possible
			if(newDropTarget !== null)
			{
				this.releaseHere(newDropTarget)
				return
			}
			else if(leftDropSpot !== null) //maybe gobble something up instead of the other way 'round?
			{
				this.tryLeftApplication()
				return
			}
		}

		if(dropTarget !== null && dropTarget.objectName === "DropSpot")
		{
			var foundAtLeastOneMatchingKey = false
			for(var dragI=0; dragI<dragKeys.length; dragI++)
				if(dropTarget.dropKeys.indexOf(dragKeys[dragI]) >= 0)
					foundAtLeastOneMatchingKey = true

			if(!foundAtLeastOneMatchingKey)
			{
				releaseHere(scriptColumn)
				return
			}
		}


		if(oldParent !== null && oldParent.objectName === "DropSpot" && dropTarget !== oldParent )
		{
			oldParent.width = oldParent.implicitWidth
			oldParent.height = oldParent.implicitHeight
			oldParent.containsItem = null
		}

		if(dropTarget !== null && dropTarget.objectName === "DropTrash")
		{
			destroy();
			dropTarget.somethingHovers = false
			return;
		}

		parent = dropTarget !== null ? dropTarget : scriptColumn

		if(parent === oldParent ) { parent = null; parent = oldParent }



		dragMe.x = 0
		dragMe.y = 0
		mouseArea.x = 0
		mouseArea.y = 0

		if(parent.objectName === "DropSpot")
		{
			parent.width = Qt.binding(function() { return dragMe.width })
			parent.height = Qt.binding(function() { return dragMe.height })
			parent.containsItem = this
		}


		scriptColumn.focus = true
	}

	function determineReasonableInsertionSpot()
	{
		if(scriptColumn.data.length === 0) return null

		var lastScriptScrap = scriptColumn.data[scriptColumn.data.length - 1]

		if(lastScriptScrap === this)
		{
			if(scriptColumn.data.length === 1)
				return null

			lastScriptScrap = scriptColumn.data[scriptColumn.data.length - 2]
			if(lastScriptScrap === this)
				return null //cannot happen hopefully?
		}

		return lastScriptScrap.returnEmptyRightMostDropSpot(true)
	}

	function returnR()							{ return shownChild.returnR() }
	function returnEmptyRightMostDropSpot()		{ return shownChild.returnEmptyRightMostDropSpot() }
	function returnFilledRightMostDropSpot()	{ return shownChild.returnFilledRightMostDropSpot() }

	function tryLeftApplication()
	{
		this.releaseHere(scriptColumn)

		if(leftDropSpot === null || leftDropSpot.containsItem !== null || scriptColumn.data.length === 1) return

		for(var i=scriptColumn.data.length - 1; i>=0; i--)
			if(scriptColumn.data[i] !== this)
			{
				var gobbleMeUp = scriptColumn.data[i]
				var putResultHere = scriptColumn

				while(gobbleMeUp !== null && putResultHere !== null && gobbleMeUp !== undefined)
				{

					for(var keyI=0; keyI<gobbleMeUp.dragKeys.length; keyI++)
						if(leftDropSpot.dropKeys.indexOf(gobbleMeUp.dragKeys[keyI])>=0)
						{
							gobbleMeUp.releaseHere(leftDropSpot)
							if(putResultHere !== scriptColumn) //we went deeper
								releaseHere(putResultHere)

							return
						}

					//Ok, we couldnt actually take the entire node into ourselves. Maybe only the right part?
					//Which means we have to place ourselves in the current gobbleMeUp!

					putResultHere	= gobbleMeUp.returnFilledRightMostDropSpot()
					if(putResultHere === null) return
					gobbleMeUp		= putResultHere.containsItem
				}

				return
			}
	}

	Item {
		id: dragMe

		width: mouseArea.width
		height: mouseArea.height
		x: mouseArea.x
		y: mouseArea.y

		Drag.keys: dragKeys
		Drag.active: mouseArea.drag.active
		Drag.hotSpot.x: dragHotSpotX
		Drag.hotSpot.y: dragHotSpotY

		Rectangle
		{
			id:	dragHandleVisualizer
			color: "transparent"
			radius: width
			property real maxWidth: 12
			height: width
			border.color: "red"
			border.width: 2

			x: dragHotSpotX - (width / 2)
			y: dragHotSpotY - (height / 2)

			visible: mouseArea.drag.active
			SequentialAnimation on width {
				NumberAnimation { from: 1; to: dragHandleVisualizer.maxWidth; duration: 500;  }
				NumberAnimation { from: dragHandleVisualizer.maxWidth; to: 1; duration: 500;  }
				loops: Animation.Infinite
			}

		}

		states: [
			State {
				when: mouseArea.drag.active
				ParentChange	{ target: dragMe; parent: filterConstructor }
				AnchorChanges	{ target: dragMe; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
			},
			State {
				when: !mouseArea.drag.active
				AnchorChanges	{ target: dragMe; anchors.verticalCenter: mouseArea.verticalCenter; anchors.horizontalCenter: mouseArea.horizontalCenter }
			}
		]

	}
}



