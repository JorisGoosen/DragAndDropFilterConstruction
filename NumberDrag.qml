import QtQuick 2.0

DragGeneric {
	property real value: 0
	//property alias canBeDragged: canBeDragged

	dropKeys: ["number"]
	shownChild: showMe

	function returnR() { return value; }

	Number
	{
		id: showMe
		value: parent.value
		x: parent.dragX
		y: parent.dragY

	}
}
