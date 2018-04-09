import QtQuick 2.0

//! [0]
DropArea {
	id: dragTarget
	objectName: "DropSpot"

	property var dropKeys: [ "number", "boolean", "string", "variable" ]
	property alias dropProxy: dragTarget

	width:  acceptsDrops ? 64 : 8;
	height: 64
	keys: dropKeys
	property real originalWidth: defaultText.length * filterConstructor.blockDim * 0.4
	property bool acceptsDrops: true
	property string defaultText: "..."
	property bool droppedShouldBeNested: false

	onEntered:
	{
		if(containsItem != null || !acceptsDrops)
		{
			drag.accepted = false
			return
		}

		var ancestry = parent

		while(ancestry !== null)
		{
			if((ancestry.objectName == "DragGeneric" && ancestry.dragChild === drag.source) || ancestry == drag.source)
			{
				drag.accepted = false
				return
			}

			ancestry = ancestry.parent
		}

		originalWidth = width
		width = drag.source.width
	}

	onExited:
	{
		if(containsItem == null)
			width = originalWidth
	}

	onDropped: containsItem = drop.drag.source

	property var containsItem: null

	Text
	{
		id: dropText
		text: dragTarget.defaultText
		font.pixelSize: filterConstructor.fontPixelSize
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		visible: parent.acceptsDrops & dragTarget.containsItem === null

		states: [
			State {
				when: dragTarget.containsDrag
				PropertyChanges {
					target: dropText
					text: ""
				}
			},
			State {
				when: !dragTarget.containsDrag
				PropertyChanges {
					target: dropText
					text: dragTarget.defaultText
				}
			}
		]
	}


}
//! [0]
