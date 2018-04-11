import QtQuick.Controls 1.4
import QtQuick 2.0

Item {

	id: filterConstructor
	property real blockDim: 24
	property real fontPixelSize: 16
	property var allKeys: ["number", "boolean", "string", "variable"]

	Rectangle
	{
		id: clippingAvoider
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right

		height: filterConstructor.blockDim
		color: "white"
		z: 3

		ElementView
		{
			id: columnsRow

			orientation: ListView.Horizontal
			anchors.horizontalCenter: parent.horizontalCenter
			height: filterConstructor.blockDim
			width: model.length * filterConstructor.blockDim

			model: ListModel
			{
				ListElement	{ type: "operator";		operator: "+";	}
				ListElement	{ type: "operator";		operator: "-";	}
				ListElement	{ type: "operator";		operator: "*";	}
				ListElement	{ type: "operatorvert";	operator: "/";	}
				ListElement	{ type: "operator";		operator: "^";	}
				ListElement	{ type: "operator";		operator: "%";	}

				ListElement	{ type: "operator";		operator: "==";	}
				ListElement	{ type: "operator";		operator: "!=";	}
				ListElement	{ type: "operator";		operator: "<";	}
				ListElement	{ type: "operator";		operator: ">";	}
				ListElement	{ type: "operator";		operator: "<=";	}
				ListElement	{ type: "operator";		operator: ">=";	}
				ListElement	{ type: "operator";		operator: "&";	}
				ListElement	{ type: "operator";		operator: "|";	}
				ListElement	{ type: "function";		functionName: "!"; functionParameters: "logical"; functionParamTypes: "boolean"	}

			}
		}
	}

	Rectangle
	{
		id: operatorLists

		anchors.top: clippingAvoider.bottom
		anchors.left: parent.left
		anchors.bottom: parent.bottom

		border.width: 1
		border.color: "grey"

		width: blockDim * 2

		ElementView
		{
			model: ListModel
			{
				ListElement	{ type: "operator";		operator: "+";	}
				ListElement	{ type: "operator";		operator: "-";	}
				ListElement	{ type: "operator";		operator: "*";	}
				ListElement	{ type: "operatorvert";	operator: "/";	}
				ListElement	{ type: "operator";		operator: "^";	}
				ListElement	{ type: "operator";		operator: "%";	}
				ListElement	{ type: "separator" }
				ListElement	{ type: "operator";		operator: "==";	}
				ListElement	{ type: "operator";		operator: "!=";	}
				ListElement	{ type: "operator";		operator: "<";	}
				ListElement	{ type: "operator";		operator: ">";	}
				ListElement	{ type: "operator";		operator: "<=";	}
				ListElement	{ type: "operator";		operator: ">=";	}
				ListElement	{ type: "operator";		operator: "&";	}
				ListElement	{ type: "operator";		operator: "|";	}
				ListElement	{ type: "function";		functionName: "!"; functionParameters: "logical"; functionParamTypes: "boolean"	}

				ListElement	{ type: "separator" }
				ListElement { type: "column";		columnName: "dummyNominalText";	columnIcon: "qrc:/icons/variable-nominal-text.svg";	}
				ListElement { type: "column";		columnName: "dummyNominal";		columnIcon: "qrc:/icons/variable-nominal.svg";		}
				ListElement { type: "column";		columnName: "dummyOrdinal";		columnIcon: "qrc:/icons/variable-ordinal.svg";		}
				ListElement { type: "column";		columnName: "dummyScale";		columnIcon: "qrc:/icons/variable-scale.svg";		}
			}
			//anchors.top: parent.top
			//anchors.left: parent.left
			//anchors.bottom: parent.bottom
			anchors.fill: parent
		}
	}

	Rectangle
	{
		id: filterHintsColumns

		anchors.top: clippingAvoider.bottom
		anchors.left: operatorLists.right
		anchors.right: funcVarLists.left
		anchors.bottom: parent.bottom
		border.width: 1
		border.color: "grey"

		z: -1
		clip: true



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

			clip: true

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

				height: 110
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

		}

		Button
		{
			id: printR
			text: "Print R"
			onClicked:
			{
				var uit = ""
				for (var i = 0; i < scriptColumn.children.length; ++i)
					uit += scriptColumn.children[i].returnR() + "\n"

				hints.text = uit
			}


			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
		}



	}

	Rectangle
	{
		id: funcVarLists

		anchors.top: clippingAvoider.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		border.width: 1
		border.color: "grey"

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
