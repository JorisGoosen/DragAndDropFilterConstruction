import QtQuick 2.0

Item
{
	objectName: "Number"
	property real value: 0

	height:	filterConstructor.blockDim
	width:	nummer.contentWidth


	Text
	{
		id: nummer
		text: value

		anchors.horizontalCenter:	parent.horizontalCenter
		anchors.verticalCenter:		parent.verticalCenter

		font.pixelSize: filterConstructor.fontPixelSize
	}

	function shouldDrag(mouseX, mouseY)			{ return true }
	function returnEmptyRightMostDropSpot()		{ return null }
	function returnFilledRightMostDropSpot()	{ return null }
	function returnR()							{ return value; }
	function checkCompletenessFormulas()		{ return true }
}
