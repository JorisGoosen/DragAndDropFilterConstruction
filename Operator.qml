import QtQuick 2.9


Item
{
	id: opRoot

	property int initialWidth: filterConstructor.blockDim * 3
	property string operator: "+"
	property string operatorImageSource: ""
	property bool acceptsDrops: true
	property bool isNested: false


	height: Math.max(filterConstructor.blockDim, leftDrop.height, rightDrop.height)
	width: haakjesLinks.width + leftDrop.width + opWidth + rightDrop.width + haakjesRechts.width

	property real opWidth: opImg.visible ? opImg.width : opText.width
	property real opX: opImg.visible ? opImg.x : opText.x

	function shouldDrag(mouse)
	{
		if(!acceptsDrops)
			return true

		return mouse.x <= haakjesLinks.width || mouse.x > haakjesRechts.x || ( mouse.x > opX && mouse.x < opX + opWidth);
	}

	function returnR()
	{
		var compounded = "("
		compounded += leftDrop.containsItem !== null ? leftDrop.containsItem.returnR() : "null"
		compounded += " " + operator + " "
		compounded += rightDrop.containsItem !== null ? rightDrop.containsItem.returnR() : "null"
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
		height: implicitHeight
		implicitWidth: opRoot.initialWidth / 4
		implicitHeight: filterConstructor.blockDim

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



	DropSpot {
		dropKeys: ["number"]

		id: rightDrop
		height: implicitHeight
		width: implicitWidth
		implicitWidth: opRoot.initialWidth / 4
		implicitHeight: filterConstructor.blockDim
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
