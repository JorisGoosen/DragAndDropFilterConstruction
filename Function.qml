import QtQuick 2.0


Item
{
	id: funcRoot

	property int initialWidth: filterConstructor.blockDim * 3
	property string functionName: "sum"
	property bool acceptsDrops: true

	property var parameterNames: ['a', 'b']
	property var parameterDropKeys: [["number"], ["string"]]

	property variant functionNameToImageSource: { "sum": "icons/sum.png", "sd": "icons/sigma.png", "var": "icons/variance.png", "!": "icons/negative.png"}
	property string functionImageSource: functionNameToImageSource[functionName] !== undefined ? functionNameToImageSource[functionName] : ""
	property bool isNested: false

	Drag.keys: [ "number" ]

	height: filterConstructor.blockDim + meanBar.height
	width: functionDef.width + haakjesLinks.width + dropRow.width + haakjesRechts.width + extraMeanWidth
	property real extraMeanWidth: (functionName === "mean" ? 10 : 0)

	function shouldDrag(mouse)
	{
		if(!acceptsDrops)
			return true

		return mouse.x <= functionDef.x + functionDef.width || ( showParentheses && ( mouse.x <= haakjesLinks.width + haakjesLinks.x || mouse.x > haakjesRechts.x)) || (meanBar.visible  && mouse.y < meanBar.height + 6);
	}

	function returnR()
	{
		var compounded = functionName + "("

		for(var i=0; i<funcRoot.parameterNames.length; i++)
				compounded += (i > 1 ? ", " : "") + dropRepeat.itemAt(i) === null ? "null" : dropRepeat.itemAt(i).returnR()

		compounded += ")"

		return compounded
	}

	readonly property bool showParentheses: functionName !== "mean" && (parameterNames.length > 1 || functionName === "abs")

	Item
	{
		id: meanBar
		visible: functionName === "mean"
		height: visible ? 6 : 0

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top

		Rectangle
		{

			color: "black"

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.topMargin: 2

			height: 2
		}
	}

	Item
	{
		id: functionDef
		anchors.top: meanBar.top
		anchors.bottom: parent.bottom

		x: extraMeanWidth / 2
		width: functionText.visible ? functionText.width : functionImg.width

		Text
		{
			id: functionText

			anchors.top: parent.top
			anchors.bottom: parent.bottom

			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter

			text: functionName === "mean" || functionName === "abs" ? "" : functionName
			font.pixelSize: filterConstructor.fontPixelSize

			visible: !functionImg.visible
		}


		Image
		{
			id: functionImg

			visible: functionImageSource !== ""

			source: functionImageSource

			height: filterConstructor.blockDim
			width: height
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Text
	{
		id: haakjesLinks
		anchors.top: meanBar.top
		anchors.bottom: parent.bottom

		x: functionDef.width + functionDef.x

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		width: showParentheses ? filterConstructor.blockDim / 3 : 0
		text: ! showParentheses ? "" : functionName === "abs" ? "|" : "("
		font.pixelSize: filterConstructor.fontPixelSize * (functionName === "abs" ? 1.2 : 1)
		font.bold: functionName === "abs"

	}

	Row
	{
		id: dropRow

		anchors.topMargin: functionName === "abs" ? 3 : 0
		anchors.top: meanBar.bottom
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

			property var rowHeightCalc: function()
			{
				var heightOut = filterConstructor.blockDim
				for(var i=0; i<funcRoot.parameterNames.length; i++)
					heightOut = Math.max(dropRepeat.itemAt(i).height, heightOut)

				return heightOut
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

					height: implicitHeight
					implicitWidth: originalWidth
					implicitHeight: dropRow.height

					acceptsDrops: funcRoot.acceptsDrops

					defaultText: funcRoot.parameterNames[index]
					dropKeys: funcRoot.parameterDropKeys[index]
					keys: funcRoot.parameterDropKeys[index]

					droppedShouldBeNested: funcRoot.parameterNames.length === 1 && functionName !== "abs" && functionName !== "mean"
					shouldShowX: true
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
		anchors.top: meanBar.top
		anchors.bottom: parent.bottom
		x: dropRow.x + dropRow.width

		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter

		width: showParentheses ? filterConstructor.blockDim / 3 : 0
		text: ! showParentheses ? "" : functionName === "abs" ? "|" : ")"
		font.pixelSize: filterConstructor.fontPixelSize * (functionName === "abs" ? 1.2 : 1)
		font.bold: functionName === "abs"
	}
}
