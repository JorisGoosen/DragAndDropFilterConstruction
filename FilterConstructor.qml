import QtQuick.Controls 2.3
import QtQuick 2.0

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

			source: "qrc:/backgrounds/jasp-wave-down-light-blue-120.svg"
		}

		Image
		{
			id: bottomBack
			//anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom

			height: parent.height / 5

			source: "qrc:/backgrounds/jasp-wave-up-light-green-120.svg"
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
				clip: true

				//horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
				//verticalScrollBarPolicy: Qt.ScrollBarAsNeeded

				contentWidth: scriptColumn.childrenRect.width
				contentHeight: scriptColumn.childrenRect.height

				Item {

					//width: Math.max(rectangularColumnContainer.width-30, scriptColumn.childrenRect.width)
					//height: Math.max(rectangularColumnContainer.height-30, scriptColumn.childrenRect.height)

					Column
					{
						z: parent.z + 1
						id: scriptColumn

						anchors.fill: parent

						function convertToR()
						{
							var uit = ""
							for (var i = 0; i < children.length; ++i)
								uit += ( i > 0 ? "&& ": "") + children[i].returnR() + "\n"

							return uit
						}

						function convertToJSON()
						{
							var jsonObj = { "formulas": [] }
							for (var i = 0; i < children.length; ++i)
								jsonObj.formulas.push(children[i].convertToJSON())

							return jsonObj
						}
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
				//anchors.bottomMargin: scrollScriptColumn.__horizontalScrollBar.visible ? 20 : 0
				//anchors.rightMargin: scrollScriptColumn.__verticalScrollBar.visible ? 20 : 0

				height: Math.min(110, scrollScriptColumn.height)
			}


		}

		TextArea
		{
			id: hints
			text: "try doubleclicking or dragging some stuff!\n"

			//backgroundVisible: false
			background: Item{}

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: printR.top

			height: font.pixelSize + contentHeight

			wrapMode: TextArea.WordWrap
			horizontalAlignment: TextArea.AlignHCenter

		}

		FilterConstructorButton
		{
			id: printR
			text: "Print R"

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: printJSON.top

			onClickedFunction: function() { hints.text = scriptColumn.convertToR() }

		}

		FilterConstructorButton
		{
			id: printJSON
			text: "Print JSON"

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: convertJSON.top

			onClickedFunction: function() { hints.text = JSON.stringify(scriptColumn.convertToJSON()) }
		}

		FilterConstructorButton
		{
			id: convertJSON
			text: "Convert JSON"

			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: applyFilter.top

			onClickedFunction: function()
			{
				jsonConverter.convertJSONtoFormulas(JSON.parse(hints.text))
			}
		}

		FilterConstructorButton
		{
			id: applyFilter
			text: "Check & Apply Filter"

			onClickedFunction: function()
			{
				var allCorrect = true
				var allBoolean = true
				var noFormulas = true

				for (var i = 0; i < scriptColumn.children.length; ++i)
				{
					if(!scriptColumn.children[i].checkCompletenessFormulas())
						allCorrect = false

					if(scriptColumn.children[i].dragKeys.indexOf("boolean") < 0)
						allBoolean = false

					noFormulas = false
				}

				hints.text = ""

				if(allCorrect && allBoolean && !noFormulas)
					hints.text += "Your filter is fine!\n"

				if(noFormulas)
					hints.text += "There are no formulas to be checked or applied..\nClick or drag any of the visible operators, columns or functions around the view to add some.\n"


				if(!allCorrect)
					hints.text += "You did not fill in all the arguments yet, see the fields marked in red.\n"



				if(!allBoolean)
					hints.text += (!allCorrect ? "\n" : "" ) + "Not every formula returns a set of logicals and thus cannot be used in the filter, to remedy this try to place comparison-operators such as '=' or '<' and the like as the roots of each formula.\n"
			}

			anchors.horizontalCenter: parent.horizontalCenter
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

	JSONtoFormulas
	{
		id: jsonConverter
	}

}
