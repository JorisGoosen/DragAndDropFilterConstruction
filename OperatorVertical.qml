import QtQuick 2.9


Item
{
	id: opRoot
	objectName: "Operator" //not really ?

	property int initialHeight: filterConstructor.blockDim * 3
	property string operator: "/"
	property string operatorImageSource: ""
	property bool acceptsDrops: true
	property bool isNested: false
	property var leftDropSpot: leftDrop
	property var dropKeys: ["number"]
	property bool dropKeysMirrorEachother: false
	property var dropKeysLeft: dropKeys
	property var dropKeysRight: dropKeys

	height: opHeight + rightDrop.height + leftDrop.height
	width: Math.max(leftDrop.width, rightDrop.width, opWidth)

	property real opWidth: opImg.visible ? opImg.width : opText.width
	property real opHeight: opImg.visible ? opImg.height : opText.height
	property real opY: opImg.visible ? opImg.y : opText.y

	function shouldDrag(mouseX, mouseY)
	{
		if(!acceptsDrops)
			return true

		return  mouseY > opY && mouseY < opY + opHeight
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

	function returnEmptyRightMostDropSpot()
	{
		if(rightDrop.containsItem !== null)
			return rightDrop.containsItem.returnEmptyRightMostDropSpot()
		return rightDrop
	}

	function returnFilledRightMostDropSpot()
	{
		if(rightDrop.containsItem !== null)
			return rightDrop
		return null
	}


	DropSpot {
		dropKeys: !(opRoot.dropKeysMirrorEachother && rightDrop.containsItem !== null) ? opRoot.dropKeysLeft : rightDrop.containsItem.dragKeys
		id: leftDrop

		anchors.horizontalCenter: parent.horizontalCenter

		height: acceptsDrops ? implicitHeight : 0
		width: acceptsDrops ? implicitWidth : 0
		implicitWidth: filterConstructor.blockDim
		implicitHeight: acceptsDrops ? opRoot.initialHeight / 3 : 0

		acceptsDrops: parent.acceptsDrops
		droppedShouldBeNested: false
	}



	Image
	{
		id: opImg
		y: leftDrop.y + leftDrop.height + 2

		visible: operatorImageSource !== "" && (operator !== "/" || !acceptsDrops)

		source: operatorImageSource

		height: filterConstructor.blockDim
		width: height
		anchors.horizontalCenter: parent.horizontalCenter
	}

	Text
	{
		id: opText

		anchors.left: parent.left
		anchors.right: parent.right

		y: leftDrop.y + leftDrop.height + 2
		height: operator === "/" ? 6 : filterConstructor.blockDim * 1.5

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: operator === "/" ? "" : opRoot.operator
		font.pixelSize: filterConstructor.fontPixelSize

		visible: !opImg.visible

		font.bold: true

		Rectangle
		{
			visible: operator === "/"
			color: "black"
			height: 2

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 2
			anchors.rightMargin: 2

			anchors.verticalCenter: parent.verticalCenter
		}
	}



	DropSpot {
		dropKeys: !(opRoot.dropKeysMirrorEachother && leftDrop.containsItem !== null) ? opRoot.dropKeysRight : leftDrop.containsItem.dragKeys

		anchors.horizontalCenter: parent.horizontalCenter

		id: rightDrop
		height: acceptsDrops ? implicitHeight : 0
		width: acceptsDrops ? implicitWidth : 0
		implicitWidth: filterConstructor.blockDim
		implicitHeight: acceptsDrops ? opRoot.initialHeight / 3 : 0
		y: opY + opHeight

		acceptsDrops: parent.acceptsDrops
		droppedShouldBeNested: false
	}
}
