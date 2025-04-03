' MainScene.brs - Lógica para controlar navegação
function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "up" then
            ' Simular navegação para cima na página
            m.webView.ExecuteJavaScript("simulateKeyUp();")
            return true
        else if key = "down" then
            ' Simular navegação para baixo
            m.webView.ExecuteJavaScript("simulateKeyDown();")
            return true
        else if key = "left" then
            ' Simular navegação para esquerda
            m.webView.ExecuteJavaScript("simulateKeyLeft();")
            return true
        else if key = "right" then
            ' Simular navegação para direita
            m.webView.ExecuteJavaScript("simulateKeyRight();")
            return true
        else if key = "OK" then
            ' Simular clique no item selecionado
            m.webView.ExecuteJavaScript("simulateClick();")
            return true
        end if
    end if
    return false
end function
' No arquivo MainScene.brs
function init()
    m.webView = m.top.findNode("webView")
    
    ' Configurar o WebView com o site
    m.webView.url = "https://www.youcinetv.vip/"
    
    ' Injetar JavaScript para detectar quando o usuário clica em um campo de pesquisa
    m.webView.callFunc("injectSearchDetection", invalid)
    
    ' Observar mensagens do WebView
    m.webView.observeField("urlEvent", "onUrlEvent")
end function

' Esta função é chamada quando o usuário clica em um elemento de pesquisa no site
function onUrlEvent(event as Object)
    data = event.getData()
    
    ' Verificar se o evento é um clique em um campo de pesquisa
    if data.reason = "search_field_clicked" then
        ' Abrir teclado virtual
        showKeyboard()
    end if
end function

function showKeyboard()
    ' Criar e mostrar a tela de teclado
    keyboardScreen = CreateObject("roSGNode", "KeyboardScreen")
    keyboardScreen.observeField("searchText", "onSearchTextReceived")
    keyboardScreen.observeField("close", "onKeyboardClosed")
    m.top.appendChild(keyboardScreen)
    keyboardScreen.setFocus(true)
end function

function onSearchTextReceived(event as Object)
    searchText = event.getData()
    
    ' Enviar o texto de pesquisa para o WebView
    m.webView.callFunc("executeSearch", {searchText: searchText})
    
    ' Remover a tela de teclado
    m.top.removeChild(m.top.findNode("KeyboardScreen"))
    m.webView.setFocus(true)
end function

function onKeyboardClosed(event as Object)
    if event.getData() = true then
        ' Remover a tela de teclado sem pesquisar
        m.top.removeChild(m.top.findNode("KeyboardScreen"))
        m.webView.setFocus(true)
    end if
end function
