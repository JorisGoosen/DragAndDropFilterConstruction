import QtQuick 2.0

//! [0]
DropArea {
	id: dragTarget
	objectName: "DropSpot"

	property var dropKeys: [ "number", "boolean", "string", "variable" ]
	property alias dropProxy: dragTarget

	width:  dropText.contentWidth
	height: 64
	keys: dropKeys
	property real originalWidth: defaultText.length * filterConstructor.blockDim * 0.4
	property bool acceptsDrops: true
	property string defaultText: acceptsDrops ? "..." : shouldShowX ? "X" : ""
	property bool droppedShouldBeNested: false
	property bool shouldShowX: false

	onEntered:
	{
		if(containsItem != null || !acceptsDrops)
		{
			drag.accepted = false
			return
		}

		var ancestry = parent

		while(ancestry !== null)
		{
			if((ancestry.objectName == "DragGeneric" && ancestry.dragChild === drag.source) || ancestry == drag.source)
			{
				drag.accepted = false
				return
			}

			ancestry = ancestry.parent
		}

		originalWidth = width
		width = drag.source.width
	}

	onExited:
	{
		if(containsItem == null)
			width = originalWidth
	}

	onDropped: containsItem = drop.drag.source

	property var containsItem: null

	Item
	{
		id: dropText

		property string text: dragTarget.defaultText

		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter

		width: dropTextStatic.visible ? dropTextStatic.width : dropTextInput.width
		//height: dropTextStatic.visible ? dropTextStatic.height : dropTextInput.height

		states: [
			State {
				when: dragTarget.containsDrag
				PropertyChanges {
					target: dropText
					text: ""
				}
			},
			State {
				when: !dragTarget.containsDrag
				PropertyChanges {
					target: dropText
					text: dragTarget.defaultText
				}
			}
		]

		//visible: (parent.acceptsDrops || shouldShowX) && dragTarget.containsItem === null
		//readOnly: dragTarget.containsItem !== null || !parent.acceptsDrops

		Text
		{
			id: dropTextStatic

			text: dragTarget.containsItem === null ? dropText.text : ""
			font.pixelSize: filterConstructor.fontPixelSize
			anchors.top: parent.top

			visible: !dropTextInput.visible
		}

		TextInput
		{
			id: dropTextInput

			text: dropText.text
			font.pixelSize: filterConstructor.fontPixelSize
			anchors.top: parent.top

			visible: dragTarget.acceptsDrops && dragTarget.containsItem === null


			validator: DoubleValidator{}
			//readonly property var numberRegex: "^[0-9]+(?.[0.9]+)?$"

			onAccepted: {
				createNumber(text)
				dropText.text = dragTarget.defaultText
			}

			onFocusChanged: {
				if(!focus && acceptableInput)
						createNumber(text)
				dropText.text = !readOnly && focus ? "" : dragTarget.defaultText

				if(!focus) text = Qt.binding(function(){return dropText.text})
			}

			function createNumber(value)
			{
				if(dragTarget.containsItem !== null) return
				var numberCreated = numberComp.createObject(dragTarget, {"value": value,	"canBeDragged": true,  "acceptsDrops": true})

				dragTarget.originalWidth = dragTarget.width
				dragTarget.width = Qt.binding(function(){ return numberCreated.width } )
				numberCreated.releaseHere(dragTarget)
				dragTarget.containsItem = numberCreated
			}
		}
	}

	Component { id: numberComp; NumberDrag {}}


}
//! [0]
