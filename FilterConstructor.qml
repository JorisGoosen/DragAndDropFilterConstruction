import QtQuick.Controls 1.4
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

	id: filterConstructor
	property real blockDim: 24
	property real fontPixelSize: 16
	property var allKeys: ["number", "boolean", "string", "variable"]


	OperatorSelector
	{
		id: columnsRow
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		height: filterConstructor.blockDim

		z: 3

		horizontalCenterX: filterHintsColumns.x + (filterHintsColumns.width * 0.5)

	}

	Item
	{
		id: background

		/*	anchors.top: columnsRow.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom*/
		anchors.fill: parent
		z: -3

		Image
		{
			id: topBack
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			//anchors.bottom: parent.verticalCenter

			height: parent.height / 5

			source: "qrc:/backgrounds/jasp-wave-down-blue-120.svg"
		}

		Image
		{
			id: bottomBack
			//anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom

			height: parent.height / 5

			source: "qrc:/backgrounds/jasp-wave-up-green-120.svg"
		}


	}

	Item
	{
		id: columnList

		//anchors.top: columnsRow.bottom
		anchors.top: columnsRow.bottom
		anchors.left: parent.left
		anchors.bottom: parent.bottom

		width: columns.width

		ElementView
		{
			id: columns
			model: ListModel
			{
				ListElement { type: "column";		columnName: "dummyNominalText";	columnIcon: "qrc:/icons/variable-nominal-text.svg";	}
				ListElement { type: "column";		columnName: "dummyNominal";		columnIcon: "qrc:/icons/variable-nominal.svg";		}
				ListElement { type: "column";		columnName: "dummyOrdinal";		columnIcon: "qrc:/icons/variable-ordinal.svg";		}
				ListElement { type: "column";		columnName: "dummyScale";		columnIcon: "qrc:/icons/variable-scale.svg";		}
			}
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.bottom: parent.bottom
		}
	}

	Item
	{
		id: filterHintsColumns

		anchors.top: columnsRow.bottom
		anchors.left: columnList.right
		anchors.right: funcVarLists.left
		anchors.bottom: parent.bottom
		//border.width: 1
		//border.color: "grey"

		z: -1
		//clip: true



		Rectangle
		{
			id: rectangularColumnContainer
			z: parent.z + 1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: hints.top

			border.width: 1
			border.color: "grey"
			color: "transparent"

			//clip: true

			ScrollView
			{
				id: scrollScriptColumn
				anchors.fill: parent
				anchors.margins: 4

				horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
				verticalScrollBarPolicy: Qt.ScrollBarAsNeeded

				contentItem: Item {
					width: Math.max(rectangularColumnContainer.width-30, scriptColumn.childrenRect.width)
					height: Math.max(rectangularColumnContainer.height-30, scriptColumn.childrenRect.height)

					Column
					{
						z: parent.z + 1
						id: scriptColumn

						anchors.fill: parent
					}

					MouseArea
					{
						anchors.fill: parent
						onClicked: scriptColumn.focus = true
					}

				}
			}

			DropTrash
			{
				id: trashCan

				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.bottomMargin: scrollScriptColumn.__horizontalScrollBar.visible ? 20 : 0
				anchors.rightMargin: scrollScriptColumn.__verticalScrollBar.visible ? 20 : 0

				height: Math.min(110, scrollScriptColumn.height)
			}


		}

		TextArea
		{
			id: hints

			text: "try doubleclicking or dragging some stuff!"

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: printR.top

			height: 60

			backgroundVisible: false

		}

		Text
		{
			id: printR
			text: "Print R"

			MouseArea
			{
				anchors.fill: parent
				onClicked:
				{
					var uit = ""
					for (var i = 0; i < scriptColumn.children.length; ++i)
						uit += scriptColumn.children[i].returnR() + "\n"

					hints.text = uit
				}
			}

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
		}



	}

	Item
	{
		id: funcVarLists

		anchors.top: columnsRow.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		//border.width: 1
		//border.color: "grey"

		width: blockDim * 3

		ElementView
		{
			model: ListModel
			{
				ListElement	{ type: "function";	functionName: "mean";	functionParameters: "values"; functionParamTypes: "number" }
				ListElement	{ type: "function";	functionName: "sd";		functionParameters: "values"; functionParamTypes: "number" }
				ListElement	{ type: "function";	functionName: "var";	functionParameters: "values"; functionParamTypes: "number" }
				ListElement	{ type: "function";	functionName: "abs";	functionParameters: "values"; functionParamTypes: "number" }
				ListElement	{ type: "function";	functionName: "sum";	functionParameters: "values"; functionParamTypes: "number" }

			}
			//anchors.top: parent.top
			//anchors.left: parent.left
			//anchors.bottom: parent.bottom
			anchors.fill: parent
		}
	}
}
