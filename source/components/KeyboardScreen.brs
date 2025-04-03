function init()
    m.keyboard = m.top.findNode("keyboard")
    m.doneButton = m.top.findNode("doneButton")
    m.background = m.top.findNode("background")
    
    m.keyboard.observeField("text", "onKeyboardTextChanged")
    m.doneButton.observeField("buttonSelected", "onDoneButtonSelected")
    
    m.keyboard.setFocus(true)
end function

function onKeyboardTextChanged()
    m.searchText = m.keyboard.text
end function

function onDoneButtonSelected()
    if m.searchText <> invalid and m.searchText <> ""
        m.top.searchText = m.searchText
        m.top.close = true
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "back"
            m.top.close = true
            return true
        else if key = "down" and m.keyboard.hasFocus()
            m.doneButton.setFocus(true)
            return true
        else if key = "up" and m.doneButton.hasFocus()
            m.keyboard.setFocus(true)
            return true
        end if
    end if
    return false
end function 