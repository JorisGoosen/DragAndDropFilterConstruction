import QtQuick.Controls 1.4
import QtQuick 2.0

Item {

	id: filterConstructor
	property real blockDim: 20
	property real fontPixelSize: 16
	property var allKeys: ["number", "boolean", "string", "variable"]

	Rectangle
	{
		id: operatorLists

		anchors.top: parent.top
		anchors.left: parent.left
		anchors.bottom: parent.bottom

		border.width: 1
		border.color: "grey"

		width: blockDim * 2

		ElementView
		{
			model: ListModel
			{
				ListElement	{ type: "operator";	operator: "+";	}
				ListElement	{ type: "operator";	operator: "-";	}
				ListElement	{ type: "operator";	operator: "*";	}
				ListElement	{ type: "operator";	operator: "/";	}
				ListElement	{ type: "operator";	operator: "^";	}
				ListElement	{ type: "operator";	operator: "%";	}
				ListElement	{ type: "separator" }
				ListElement	{ type: "operator";	operator: "=";	}
				ListElement	{ type: "operator";	operator: "!=";	}
				ListElement	{ type: "operator";	operator: "<";	}
				ListElement	{ type: "operator";	operator: ">";	}
				ListElement	{ type: "operator";	operator: "<=";	}
				ListElement	{ type: "operator";	operator: ">=";	}
				ListElement	{ type: "operator";	operator: "&";	}
				ListElement	{ type: "operator";	operator: "|";	}
				ListElement	{ type: "function";	functionName: "!"; functionParameters: "..."; functionParamTypes: "boolean"	}

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

		anchors.top: parent.top
		anchors.left: operatorLists.right
		anchors.right: funcVarLists.left
		anchors.bottom: parent.bottom
		border.width: 1
		border.color: "grey"

		z: 2

		ColumnsSelector
		{
			id: columnsRow
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: 2

			height: filterConstructor.blockDim

		}

		Rectangle
		{
			z: parent.z + 1
			anchors.top: columnsRow.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: hints.top

			border.width: 1
			border.color: "grey"

			Column
			{
				z: parent.z + 1
				id: scriptColumn

				anchors.fill: parent
				anchors.margins: 4

				OperatorDrag { operator: "-" }
				OperatorDrag { operator: "*" }

				NumberDrag { value: 1 }
				NumberDrag { value: 2 }
				NumberDrag { value: 3 }



			}
		}

		TextArea
		{
			id: hints

			text: "try doubleclicking or dragging some stuff!"

			anchors.left: parent.left
			anchors.right: trashCan.right
			anchors.bottom: printR.top

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
			anchors.right: trashCan.right
			anchors.bottom: parent.bottom
		}

		DropTrash
		{
			id: trashCan

			anchors.top: hints.top
			anchors.bottom: parent.bottom
			anchors.right: parent.right
		}

	}

	Rectangle
	{
		id: funcVarLists

		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		border.width: 1
		border.color: "grey"

		width: blockDim * 6

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
