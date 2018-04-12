import QtQuick 2.0

Item
{
	objectName: "String"
	property string text: ""

	height:	filterConstructor.blockDim
	width:	stringObj.contentWidth


	Text
	{
		id: stringObj
		text: parent.text

		anchors.horizontalCenter:	parent.horizontalCenter
		anchors.verticalCenter:		parent.verticalCenter

		font.pixelSize: filterConstructor.fontPixelSize
	}

	function shouldDrag(mouseX, mouseY)			{ return true }
	function returnEmptyRightMostDropSpot()		{ return null }
	function returnFilledRightMostDropSpot()	{ return null }
	function returnR()							{ return "'" + text + "'"; }
	function checkCompletenessFormulas()		{ return true }
	function convertToJSON()
	{
		var jsonObj = { "nodeType":"String", "text":text }
		return jsonObj
	}
}
