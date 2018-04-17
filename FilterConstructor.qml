import QtQuick.Controls 2.3
import QtQuick 2.0

Item {

	id: filterConstructor
	property real blockDim: 20
	property real fontPixelSize: 14
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
				ListElement { type: "column";		columnName: "dummyNominalText";	columnIcon: "qrc:/icons/variable-nominal-text.svg";	toolTip: "a column from your dataset"}
				ListElement { type: "column";		columnName: "dummyNominal";		columnIcon: "qrc:/icons/variable-nominal.svg";		toolTip: "a column from your dataset"}
				ListElement { type: "column";		columnName: "dummyOrdinal";		columnIcon: "qrc:/icons/variable-ordinal.svg";		toolTip: "a column from your dataset"}
				ListElement { type: "column";		columnName: "dummyScale";		columnIcon: "qrc:/icons/variable-scale.svg";		toolTip: "a column from your dataset"}
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

				contentWidth: scriptColumn.childrenRect.width
				contentHeight: scriptColumn.childrenRect.height

				Item {

					Column
					{
						z: parent.z + 1
						id: scriptColumn
						objectName: "scriptColumn"

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

		width: functieLijst.width + 4

		ElementView
		{
			id: functieLijst
			model: ListModel
			{
				ListElement	{ type: "function";	functionName: "mean";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "mean" }
				ListElement	{ type: "function";	functionName: "median";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "median" }
				ListElement	{ type: "function";	functionName: "sd";		functionParameters: "values";	functionParamTypes: "number";			toolTip: "standard deviation" }
				ListElement	{ type: "function";	functionName: "var";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "variance" }
				ListElement	{ type: "function";	functionName: "abs";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "absolute value" }
				ListElement	{ type: "function";	functionName: "sum";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "summation" }
				ListElement	{ type: "function";	functionName: "prod";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "product of values" }

				ListElement	{ type: "function";	functionName: "max";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "returns maximum of values" }
				ListElement	{ type: "function";	functionName: "min";	functionParameters: "values";	functionParamTypes: "number";			toolTip: "returns minimum of values" }

				ListElement	{ type: "function";	functionName: "length";	functionParameters: "x";		functionParamTypes: "any";				toolTip: "returns number of elements in X" }
				ListElement	{ type: "function";	functionName: "round";	functionParameters: "x,n";		functionParamTypes: "number,number";	toolTip: "rounds x to n decimals" }

				ListElement	{ type: "separator" }
				ListElement	{ type: "function";	functionName: "rnorm";	functionParameters: "n,mean,sd";functionParamTypes: "number,number,number";	toolTip: "generates a guassian distribution of n elements with specified mean and standard deviation sd" }
				ListElement	{ type: "function";	functionName: "rexp";	functionParameters: "n,rate";	functionParamTypes: "number,number,number";	toolTip: "generates a exponential distribution of n elements with specified rate" }

				ListElement	{ type: "separator" }

				ListElement	{ type: "function";	functionName: "sin";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "sine" }
				ListElement	{ type: "function";	functionName: "cos";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "cosine" }
				ListElement	{ type: "function";	functionName: "tan";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "tangent" }

				ListElement	{ type: "function";	functionName: "asin";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "arc or inverse sine" }
				ListElement	{ type: "function";	functionName: "acos";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "arc or inverse cosine" }
				ListElement	{ type: "function";	functionName: "atan";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "arc or inverse tangent" }
				ListElement	{ type: "function";	functionName: "atan2";	functionParameters: "x,y";		functionParamTypes: "number,number";	toolTip: "arc or inverse tangent that returns angle of x,y within a full circle" }

				ListElement	{ type: "separator" }

				ListElement	{ type: "function";	functionName: "log";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "natural logarithm" }
				ListElement	{ type: "function";	functionName: "log2";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "base 2 logarithm" }
				ListElement	{ type: "function";	functionName: "log10";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "base 10 logarithm" }
				ListElement	{ type: "function";	functionName: "logb";	functionParameters: "x,base";	functionParamTypes: "number";			toolTip: "logarithm of x in 'base'" }
				ListElement	{ type: "function";	functionName: "exp";	functionParameters: "x";		functionParamTypes: "number";			toolTip: "exponential" }

				ListElement	{ type: "function";	functionName: "match";	functionParameters: "x,y";		functionParamTypes: "any,any";			toolTip: "returns the list X with NA for each element that is not in Y" }


			}
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: 2
		}
	}

	JSONtoFormulas
	{
		id: jsonConverter
	}

}
