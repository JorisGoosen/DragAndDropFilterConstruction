import QtQuick 2.0

Item
{
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

	function shouldDrag(mouse)
	{
		return true;
	}
}
