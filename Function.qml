import QtQuick 2.0


Item
{
	id: funcRoot

	property int initialWidth: filterConstructor.blockDim * 3
	property string functionName: "sum"
	property bool acceptsDrops: true

	property var parameterNames: ['a', 'b']
	property var parameterDropKeys: [["number"], ["string"]]

	Drag.keys: [ "number" ]

	height: filterConstructor.blockDim
	width: childrenRect.width

	function shouldDrag(mouse)
	{
		return mouse.x <= haakjesLinks.width + haakjesLinks.x || mouse.x > haakjesRechts.x;
	}

	function returnR()
	{
		var compounded = functionName + "("

		for(var i=0; i<funcRoot.parameterNames.length; i++)
				compounded += (i > 1 ? ", " : "") + dropRepeat.itemAt(i) === null ? "null" : dropRepeat.itemAt(i).returnR()

		compounded += ")"

		return compounded
	}

	Item
	{
		id: functionDef
		anchors.top: parent.top
		anchors.bottom: parent.bottom


		width: functionText.width

		Text
		{
			id: functionText

			anchors.top: parent.top
			anchors.bottom: parent.bottom

			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter

			text: functionName
			font.pixelSize: filterConstructor.fontPixelSize
		}
	}

	Text
	{
		id: haakjesLinks
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: filterConstructor.blockDim / 2
		x: functionDef.width + functionDef.x

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: "("
		font.pixelSize: filterConstructor.fontPixelSize
	}

	Row
	{
		id: dropRow

		anchors.top: parent.top
		anchors.bottom: parent.bottom
		x: haakjesLinks.width + haakjesLinks.x
		width: 0
			//dropRepeat.width //(implicitWidthDrops * parent.parameterNames.length) + (4 * ( parent.parameterNames.length - 1))

		property real implicitWidthDrops: parent.acceptsDrops ? funcRoot.initialWidth / 4 : 0

		Repeater
		{
			id: dropRepeat
			model: funcRoot.parameterNames
			//anchors.fill: parent

			property var rowWidthCalc: function()
			{
				var widthOut = 0
				for(var i=0; i<funcRoot.parameterNames.length; i++)
					widthOut += dropRepeat.itemAt(i).width
				return widthOut
			}

			onItemAdded: dropRow.width = Qt.binding(rowWidthCalc)
			onItemRemoved: dropRow.width = Qt.binding(rowWidthCalc)

			Item
			{
				width: spot.width + comma.width
				height: dropRow.height

				function returnR()
				{
					if(spot.containsItem != null)
						return spot.containsItem.returnR();
					else
						return "null"
				}

				DropSpot {
					id: spot

					height: dropRow.height
					//width: implicitWidth
					implicitWidth: originalWidth//  dropRow.implicitWidthDrops

					acceptsDrops: funcRoot.acceptsDrops

					defaultText: funcRoot.parameterNames[index]
					dropKeys: funcRoot.parameterDropKeys[index]
					keys: funcRoot.parameterDropKeys[index]
				}

				Text
				{
					id: comma
					text: index < funcRoot.parameterNames.length - 1 ? "," : ""

					font.pixelSize: filterConstructor.fontPixelSize
					anchors.top: parent.top
					anchors.bottom: parent.bottom

					anchors.left: spot.right
				}
			}
		}
	}

	Text
	{
		id: haakjesRechts
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: filterConstructor.blockDim / 2
		x: dropRow.x + dropRow.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		text: ")"
		font.pixelSize: filterConstructor.fontPixelSize
	}
}
