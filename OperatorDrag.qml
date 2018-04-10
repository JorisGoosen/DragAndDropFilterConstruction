import QtQuick 2.0

DragGeneric {
	shownChild: showMe

	readonly property var everythingOperators: ["==", "!="]
	readonly property var booleanOperators: ["<", ">", "<=", ">=", "!", "&", "|"]
	readonly property bool isBoolean: booleanOperators.indexOf(operator) >= 0
	readonly property bool isEverything: everythingOperators.indexOf(operator) >= 0
	dropKeys: isEverything ? ["boolean", "string", "number", "variable"] : isBoolean ? ["boolean"] : ["number"]
	property string operator: "+"
	property alias acceptsDrops: showMe.acceptsDrops

	property variant opImages: { '==': 'icons/equal.png', '!=': 'icons/notEqual.png', '<': 'icons/lessThan.png', '>': 'icons/greaterThan.png', '<=': 'icons/lessThanEqual.png', '>=': 'icons/greaterThanEqual.png',  '&': 'icons/and.png', '|': 'icons/or.png'}



	function returnR() { return showMe.returnR(); }

	Operator
	{
		id: showMe
		operator: parent.operator
		operatorImageSource: parent.isBoolean || parent.isEverything ? parent.opImages[operator] : ""

		x: parent.dragX
		y: parent.dragY
		isNested: parent.nested
	}
}
