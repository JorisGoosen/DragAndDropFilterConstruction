import QtQuick 2.0

DragTile {
	colorKey: "red"
	id: root

	height: filterConstructor.blockDim
	width: filterConstructor.blockDim * 0.8//, nummer.contentWidth)

	property real value: 0

	delegate:
		Text
		{
			id: nummer
			anchors.horizontalCenter: parent.horizontalCenter
			text: value
			font.pixelSize: parent.height
		}
}
