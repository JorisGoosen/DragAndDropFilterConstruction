import QtQuick 2.0

DragGeneric {
	shownChild: showMe

	property string operator: "+"

	Operator
	{
		id: showMe
		operator: parent.operator
		x: parent.dragX
		y: parent.dragY
	}
}
