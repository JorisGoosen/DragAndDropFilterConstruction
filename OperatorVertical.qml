import QtQuick 2.9


Item
{
	id: opRoot
	objectName: "OperatorVertical"

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

	height: opY + opHeight + rightDrop.height
	width: opWidth

	property real opWidth: opImg.visible ? opImg.width : opTextStripe.width
	property real opHeight: opImg.visible ? opImg.height : opTextStripe.height
	property real opY: opImg.visible ? opImg.y : opTextStripe.y

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

	function checkCompletenessFormulas()
	{
		var leftIsOk = leftDrop.checkCompletenessFormulas()
		var rightIsOk = rightDrop.checkCompletenessFormulas()
		return leftIsOk && rightIsOk
	}

	DropSpot {
		dropKeys: !(opRoot.dropKeysMirrorEachother && rightDrop.containsItem !== null) ? opRoot.dropKeysLeft : rightDrop.containsItem.dragKeys
		id: leftDrop

		anchors.horizontalCenter: parent.horizontalCenter

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

	Item
	{
		id: opTextStripe

		visible: !opImg.visible

		y: leftDrop.y + leftDrop.height + marginStripe

		height: operator === "/" ? marginStripe * 2 + opStripe.height : opText.height
		width: Math.max(leftDrop.width + marginStripe, rightDrop.width + marginStripe, opStripe.visible ? filterConstructor.blockDim : opText.contentWidth)
		property real marginStripe: opStripe.visible ? 2 : 0

		Text
		{
			id: opText

			anchors.left: parent.left
			anchors.right: parent.right

			height: filterConstructor.blockDim * 1.5

			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter

			text: opRoot.operator
			font.pixelSize: filterConstructor.fontPixelSize

			visible: !opStripe.visible

			font.bold: true
		}

		Rectangle
		{
			id: opStripe
			visible: operator === "/"
			color: "black"
			height: 2

			anchors.left:			parent.left
			anchors.right:			parent.right
			anchors.leftMargin:		parent.marginStripe
			anchors.rightMargin:	parent.marginStripe

			anchors.verticalCenter: parent.verticalCenter

		}
	}



	DropSpot {
		dropKeys: !(opRoot.dropKeysMirrorEachother && leftDrop.containsItem !== null) ? opRoot.dropKeysRight : leftDrop.containsItem.dragKeys

		anchors.horizontalCenter: parent.horizontalCenter

		id: rightDrop
		implicitHeight: acceptsDrops ? opRoot.initialHeight / 3 : 0
		y: opY + opHeight

		acceptsDrops: parent.acceptsDrops
		droppedShouldBeNested: false
	}
}
