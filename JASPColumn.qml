import QtQuick 2.9

Item
{
	objectName: "Column"
	property string columnName: "?"
	property string columnIcon: ""

	height:	filterConstructor.blockDim
	width:	colIcon.width + colName.width
	property bool isNumerical: columnIcon.indexOf("nominal-text") < 0
		//columnIcon.indexOf("scale") >= 0 || columnIcon.indexOf("ordinal") >= 0

	property var dragKeys: isNumerical ? ["number"] : ["string"]

	Image
	{
		id: colIcon
		source: columnIcon
		width: height

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.bottom: parent.bottom

		anchors.margins: 4
	}

	Text
	{
		id:colName
		anchors.top: parent.top
		anchors.left: colIcon.right
		anchors.bottom: parent.bottom
		width: contentWidth + 10

		font.pixelSize: filterConstructor.fontPixelSize

		leftPadding: 2

		text: columnName
	}

	function shouldDrag(mouseX, mouseY)
	{
		return true;
	}

	function returnEmptyRightMostDropSpot()
	{
		return null
	}

	function returnFilledRightMostDropSpot()
	{
		return null
	}

	function returnR() { return columnName; }
}
