import QtQuick 2.0

ListView {
	id: listOfColumns
	orientation: ListView.Horizontal
	clip: true


	model: ListModel {
		ListElement { name: "dummyNominalText";	type: "qrc:/icons/variable-nominal-text.svg";	}
		ListElement { name: "dummyNominal";		type: "qrc:/icons/variable-nominal.svg";		}
		ListElement { name: "dummyOrdinal";		type: "qrc:/icons/variable-ordinal.svg";		}
		ListElement { name: "dummyScale";		type: "qrc:/icons/variable-scale.svg";			}
	}

	delegate: MouseArea
	{
		width: col.width
		height: col.height

		ColumnDrag {  id: col; columnName: name; columnIcon: type; canBeDragged: false	}

		onDoubleClicked:
		{
			columnComp.createObject(scriptColumn, { "columnName": name, "columnIcon": type})
		}
	}

	Component
	{
		id: columnComp
		ColumnDrag {}
	}
}
