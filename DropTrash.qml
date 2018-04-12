import QtQuick 2.0

//! [0]
DropArea {
	id: trashCan
	objectName: "DropTrash"

	keys: [ "number", "boolean", "string", "variable" ]

	onDropped: if(drop.drag.source !== null) drop.drag.source.destroy()
	property real aspect: 1.7
	width: height / aspect
	property real iconPadding: 0.9

	property bool somethingHovers: false

	onEntered: somethingHovers = true
	onExited: somethingHovers = false

	Image
	{
		id:	trashIcon
		anchors.centerIn: parent

		property real sizer: (trashCan.height < trashCan.width * aspect ? trashCan.height : trashCan.width * aspect)

		height: sizer * parent.iconPadding
		width: (sizer / aspect) * parent.iconPadding

		source: somethingHovers ? "icons/trashcan_open.svg" : "icons/trashcan.svg"

		smooth: true
	}

	MouseArea
	{
		anchors.fill: parent

		onDoubleClicked: parent.destroyAll()
	}

	function destroyAll()
	{
		for(var i=scriptColumn.children.length-1; i >= 0; i--)
			scriptColumn.children[i].destroy()
	}


}
//! [0]
