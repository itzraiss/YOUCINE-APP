' Arquivo KeyboardScreen.brs
function init()
    m.keyboard = m.top.findNode("keyboard")
    m.doneButton = m.top.findNode("doneButton")
    m.background = m.top.findNode("background")
    
    ' Configurar observadores
    m.keyboard.observeField("text", "onKeyboardTextChanged")
    m.doneButton.observeField("buttonSelected", "onDoneButtonSelected")
    
    ' Definir o foco inicial
    m.keyboard.setFocus(true)
end function

function onKeyboardTextChanged()
    ' Atualizar texto conforme o usuário digita
    m.searchText = m.keyboard.text
end function

function onDoneButtonSelected()
    ' Quando o botão "Pesquisar" é pressionado
    if m.searchText <> invalid and m.searchText <> ""
        ' Enviar texto de pesquisa de volta para a cena principal
        m.top.searchText = m.searchText
        ' Fechar tela de teclado
        m.top.close = true
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "back"
            ' Fechar teclado sem pesquisar
            m.top.close = true
            return true
        else if key = "down" and m.keyboard.hasFocus()
            ' Navegar do teclado para o botão
            m.doneButton.setFocus(true)
            return true
        else if key = "up" and m.doneButton.hasFocus()
            ' Navegar de volta para o teclado
            m.keyboard.setFocus(true)
            return true
        end if
    end if
    return false
end function
