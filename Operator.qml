import QtQuick 2.9


Item
{
	id: opRoot

	property int initialWidth: filterConstructor.blockDim * 3
	property string operator: "+"
	property string operatorImageSource: ""
	property bool acceptsDrops: true
	property bool isNested: false


	height: filterConstructor.blockDim
	width: haakjesLinks.width + leftDrop.width + opWidth + rightDrop.width + haakjesRechts.width

	function shouldDrag(mouse)
	{
		return mouse.x <= haakjesLinks.width || mouse.x > haakjesRechts.x || ( mouse.x > opX && mouse.x < opWidth);
	}

	function returnR()
	{
		var compounded = "("
		compounded += leftDrop.containsItem !== null ? leftDrop.containsItem.returnR() : ""
		compounded += " " + operator + " "
		compounded += rightDrop.containsItem !== null ? rightDrop.containsItem.returnR() : ""
		compounded += ")"

		return compounded
	}

	Text
	{
		id: haakjesLinks
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: opRoot.isNested ? opRoot.initialWidth / 8 : 0

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: "("
		font.pixelSize: filterConstructor.fontPixelSize

		visible: opRoot.isNested
	}

	DropSpot {
		dropKeys: ["number"]

		id: leftDrop
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		x: haakjesLinks.width

		width: implicitWidth
		implicitWidth: opRoot.initialWidth / 4

		acceptsDrops: parent.acceptsDrops
		droppedShouldBeNested: true
	}

	Image
	{
		id: opImg
		x: leftDrop.x + leftDrop.width + 2

		visible: operatorImageSource !== ""

		source: operatorImageSource

		height: filterConstructor.blockDim
		width: height
		anchors.verticalCenter: parent.verticalCenter
	}

	Text
	{
		id: opText
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		//width: max(opRoot.initialWidth / 4
		leftPadding: 2
		rightPadding: 2
		x: leftDrop.x + leftDrop.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: opRoot.operator
		font.pixelSize: filterConstructor.fontPixelSize

		visible: !opImg.visible
	}

	property real opWidth: opImg.visible ? opImg.width : opText.width
	property real opX: opImg.visible ? opImg.x : opText.x

	DropSpot {
		dropKeys: ["number"]

		id: rightDrop
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: implicitWidth
		implicitWidth: opRoot.initialWidth / 4
		x: opX + opWidth

		acceptsDrops: parent.acceptsDrops
		droppedShouldBeNested: true
	}

	Text
	{
		id: haakjesRechts
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: opRoot.isNested ? opRoot.initialWidth / 8 : 0
		x: rightDrop.x + rightDrop.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: ")"
		font.pixelSize: filterConstructor.fontPixelSize
		visible: opRoot.isNested
	}
}
