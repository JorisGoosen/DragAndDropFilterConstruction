import QtQuick 2.0

DragGeneric {
	shownChild: showMe

	property string functionName: "sum"
	property var parameterNames: []
	property var parameterDropKeys: []

	property alias acceptsDrops: showMe.acceptsDrops

	function returnR() { return showMe.returnR(); }



	Function
	{
		id: showMe
		functionName:		parent.functionName
		parameterNames:		parent.parameterNames
		parameterDropKeys:	parent.parameterDropKeys

		x: parent.dragX
		y: parent.dragY
	}
}
