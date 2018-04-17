import QtQuick 2.0

DragGeneric {
	shownChild: showMe

	readonly property var everythingOperators: ["==", "!=", ]
	readonly property var numberCompareOperators: ["<", ">", "<=", ">="]
	readonly property var booleanOperators: ["&", "|"]
	readonly property bool acceptsBoolean: booleanOperators.indexOf(operator) >= 0
	readonly property bool acceptsEverything: everythingOperators.indexOf(operator) >= 0
	readonly property bool returnsBoolean: booleanOperators.indexOf(operator) >= 0 || numberCompareOperators.indexOf(operator) >= 0 || acceptsEverything

	dragKeys: returnsBoolean ? ["boolean"] : ["number"]

	property string operator: "+"
	property bool acceptsDrops: true

	property var opImages: { '/': 'icons/divide.png'}

	leftDropSpot:		showMe.leftDropSpot

	property alias leftDrop: showMe.leftDrop
	property alias rightDrop: showMe.rightDrop

	OperatorVertical
	{
		id: showMe
		operator: parent.operator
		operatorImageSource: parent.opImages[operator] !== null && parent.opImages[operator] !== undefined ? parent.opImages[operator] : ""

		dropKeysLeft: acceptsEverything ? ["boolean", "string", "number"] : acceptsBoolean ? ["boolean"] : ["number"]
		dropKeysRight: dropKeysLeft
		dropKeysMirrorEachother: acceptsEverything

		x: parent.dragX
		y: parent.dragY
		isNested: parent.nested

		acceptsDrops: parent.acceptsDrops
	}
}
