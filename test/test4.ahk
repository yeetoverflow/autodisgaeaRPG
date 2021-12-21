#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

;https://www.autohotkey.com/docs/commands/TreeView.htm

;Gui Add, TreeView, checked AltSubmit gHandleGo vTestTreeView
Gui Add, ListView, checked AltSubmit gHandleGo vTestTreeView, Name
LV_Add("", "Test1")
LV_Add("", "Test2")
; TV_Add("Test1")
; x := TV_Add("Test2")
; TV_Add("TestA", x)
; TV_Add("TestB", x)
; TV_Add("Test3")

Gui Add, Button, gHandleGo, Go
Gui Show

HandleGo() {
    MsgBox, % A_GuiEvent
    if (A_GuiEvent = "Normal") {
        items := []
        checkedItem := TV_GetNext(0, "Checked")

        while (checkedItem) {
            TV_GetText(name, checkedItem)
            parentId := TV_GetParent(checkedItem)

            if (parentId = "0") {
                items.Push(name)
            }
            checkedItem := TV_GetNext(checkedItem, "Checked")
        }
    }
}