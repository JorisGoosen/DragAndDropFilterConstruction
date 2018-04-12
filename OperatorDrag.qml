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

	property var opImages: { '==': 'icons/equal.png', '!=': 'icons/notEqual.png', '<': 'icons/lessThan.png', '>': 'icons/greaterThan.png', '<=': 'icons/lessThanEqual.png', '>=': 'icons/greaterThanEqual.png',  '&': 'icons/and.png', '|': 'icons/or.png'}

	leftDropSpot:		showMe.leftDropSpot

	Operator
	{
		id: showMe
		operator: parent.operator
		operatorImageSource: parent.opImages[operator] !== null && parent.opImages[operator] !== undefined ? parent.opImages[operator] : ""

		dropKeysLeft: acceptsEverything ? ["boolean", "string", "number"] : acceptsBoolean ? ["boolean"] : ["number"]
		dropKeysRight: acceptsEverything ? ["boolean", "string", "number"] : acceptsBoolean ? ["boolean"] : ["number"]
		dropKeysMirrorEachother: acceptsEverything

		x: parent.dragX
		y: parent.dragY
		isNested: parent.nested

		acceptsDrops: parent.acceptsDrops
	}
}
