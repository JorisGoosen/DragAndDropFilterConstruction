import QtQuick 2.0

DragGeneric {
	shownChild: showMe

	property string functionName: "sum"
	property var parameterNames: functionName != "!" ? ["X"] : []
	property var parameterDropKeys: ["???"]

	property bool acceptsDrops: true

	function returnR() { return showMe.returnR(); }

	Function
	{
		id: showMe
		functionName:		parent.functionName
		parameterNames:		parent.parameterNames
		parameterDropKeys:	parent.parameterDropKeys

		x: parent.dragX
		y: parent.dragY

		isNested: parent.nested
		acceptsDrops: parent.acceptsDrops
	}
}
