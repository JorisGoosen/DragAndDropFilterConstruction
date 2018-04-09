import QtQuick 2.0

//! [0]
DropArea {
	id: trashCan
	objectName: "DropTrash"

	keys: [ "number", "boolean", "string", "variable" ]

	onDropped: if(drop.drag.source !== null) drop.drag.source.destroy()

	width: trashIcon.width + iconPadding
	property real iconPadding: 4

	Rectangle
	{
		anchors.fill: parent
		border.color: "grey"
		border.width: 1
	}

	Image
	{
		id:	trashIcon
		anchors.centerIn: parent
		height: Math.min(trashCan.height - parent.iconPadding, 64)
		width: height

		source: "icons/recycle.svg"
	}


}
//! [0]
