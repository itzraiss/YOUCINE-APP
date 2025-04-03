sub init()
    m.background = m.top.findNode("background")
    m.keyboard = m.top.findNode("keyboard")
    
    ' Configurar o teclado
    m.keyboard.textEditBox.hintText = "Digite para pesquisar..."
    m.keyboard.observeField("text", "onKeyboardText")
end sub

sub onKeyboardText()
    m.top.text = m.keyboard.text
end sub