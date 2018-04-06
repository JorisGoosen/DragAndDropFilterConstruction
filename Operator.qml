import QtQuick 2.0


Item
{
	id: opRoot

	property int initialWidth: filterConstructor.blockDim * 3
	property string operator: "+"

	Drag.keys: [ "number" ]

	height: filterConstructor.blockDim
	width: haakjesLinks.width + leftDrop.width + opText.width + rightDrop.width + haakjesRechts.width

	function shouldDrag(mouse)
	{
		return mouse.x <= haakjesLinks.width || mouse.x > haakjesRechts.x || ( mouse.x > opText.x && mouse.x < rightDrop.x);
	}

	Text
	{
		id: haakjesLinks
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: opRoot.initialWidth / 8

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: "("
		font.pixelSize: parent.height * 0.8
	}

	DropSpot {
		dropKeys: ["number"]

		id: leftDrop
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		x: haakjesLinks.width

		width: implicitWidth
		implicitWidth: opRoot.initialWidth / 4
	}

	Text
	{
		id: opText
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: opRoot.initialWidth / 4
		x: leftDrop.x + leftDrop.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: opRoot.operator
		font.pixelSize: parent.height
	}

	DropSpot {
		dropKeys: ["number"]

		id: rightDrop
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: implicitWidth
		implicitWidth: opRoot.initialWidth / 4
		x: opText.x + opText.width
	}

	Text
	{
		id: haakjesRechts
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: opRoot.initialWidth / 8
		x: rightDrop.x + rightDrop.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: ")"
		font.pixelSize: parent.height * 0.8
	}
}
