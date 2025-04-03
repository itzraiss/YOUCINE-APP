sub init()
    print "MainScene - init()"
    
    ' Configuração do WebView
    m.webView = m.top.findNode("webView")
    m.webView.setFocus(true)
    m.webView.uri = "http://www.youcinetv.vip/"
    
    ' Configuração do teclado virtual
    m.keyboardDialog = m.top.findNode("keyboardDialog")
    m.keyboardDialog.observeField("text", "onKeyboardDialogText")
    
    ' Observadores de eventos
    m.global.observeField("keyPressed", "onKeyPressed")
    
    ' Variáveis de estado
    m.activeElement = invalid
    m.searchInputFocused = false
    m.currentFocusX = 0
    m.currentFocusY = 0
    
    ' Configurar interceptadores de JavaScript para navegação
    setupJavascriptInterceptors()
end sub

sub setupJavascriptInterceptors()
    ' Este código JavaScript vai mapear elementos de navegação no site
    jsCode = "
    (function() {
        window.rokuNavigation = {
            elements: [],
            searchInput: null,
            
            mapElements: function() {
                // Mapeamento de elementos navegáveis (links, botões, etc.)
                const links = document.querySelectorAll('a, button, .movie-item, .serie-item');
                this.elements = Array.from(links);
                
                // Identificar campos de pesquisa
                this.searchInput = document.querySelector('input[type=search], input[type=text].search-input');
                
                return {
                    elements: this.elements.length,
                    hasSearchInput: this.searchInput !== null
                };
            },
            
            selectElement: function(x, y) {
                if (this.elements.length > 0) {
                    // Algoritmo para selecionar elemento com base em coordenadas virtuais
                    let targetIndex = 0;
                    // Implementação simplificada - na prática precisaria de mais lógica
                    if (y > 0) targetIndex = Math.min(Math.floor(y * this.elements.length / 10), this.elements.length - 1);
                    
                    // Remove destaque anterior
                    this.elements.forEach(el => {
                        el.style.outline = '';
                    });
                    
                    // Destaca novo elemento
                    this.elements[targetIndex].style.outline = '3px solid #ff6600';
                    this.elements[targetIndex].style.outlineOffset = '2px';
                    
                    // Scroll para o elemento se necessário
                    this.elements[targetIndex].scrollIntoView({behavior: 'smooth', block: 'center'});
                    
                    return {
                        success: true,
                        element: targetIndex
                    };
                }
                return {success: false};
            },
            
            clickCurrentElement: function() {
                const selectedElement = document.querySelector('[style*=\'outline: 3px solid #ff6600\']');
                if (selectedElement) {
                    selectedElement.click();
                    return {success: true};
                }
                return {success: false};
            },
            
            focusSearchInput: function() {
                if (this.searchInput) {
                    this.searchInput.focus();
                    return {success: true};
                }
                return {success: false};
            }
        };
        
        // Executar o mapeamento inicial após o carregamento da página
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const result = window.rokuNavigation.mapElements();
                return result;
            }, 1000);
        });
        
        // Refazer o mapeamento após mudanças na página (AJAX)
        const observer = new MutationObserver(function(mutations) {
            setTimeout(function() {
                window.rokuNavigation.mapElements();
            }, 500);
        });
        
        observer.observe(document.body, {childList: true, subtree: true});
        
        return 'Roku navigation helpers initialized';
    })();
    "
    
    m.webView.executeJavaScript(jsCode)
end sub

sub onKeyPressed(event)
    key = event.getData()
    
    if key = "up" then
        moveSelection(0, -1)
    else if key = "down" then
        moveSelection(0, 1)
    else if key = "left" then
        moveSelection(-1, 0)
    else if key = "right" then
        moveSelection(1, 0)
    else if key = "OK" then
        if m.searchInputFocused then
            showKeyboard()
        else
            selectCurrentElement()
        end if
    else if key = "search" then
        focusSearchInput()
    else if key = "back" then
        navigateBack()
    end if
end sub

sub moveSelection(deltaX, deltaY)
    m.currentFocusX = m.currentFocusX + deltaX
    m.currentFocusY = m.currentFocusY + deltaY
    
    ' Normalizando valores
    if m.currentFocusX < 0 then m.currentFocusX = 0
    if m.currentFocusY < 0 then m.currentFocusY = 0
    if m.currentFocusX > 9 then m.currentFocusX = 9
    if m.currentFocusY > 9 then m.currentFocusY = 9
    
    jsCode = "window.rokuNavigation.selectElement(" + Str(m.currentFocusX) + "," + Str(m.currentFocusY) + ");"
    m.webView.executeJavaScript(jsCode)
end sub

sub selectCurrentElement()
    jsCode = "window.rokuNavigation.clickCurrentElement();"
    m.webView.executeJavaScript(jsCode)
end sub

sub focusSearchInput()
    jsCode = "window.rokuNavigation.focusSearchInput();"
    result = m.webView.executeJavaScript(jsCode)
    
    if result <> invalid and result.success = true then
        m.searchInputFocused = true
        showKeyboard()
    end if
end sub

sub showKeyboard()
    if m.searchInputFocused then
        m.keyboardDialog.visible = true
        m.keyboardDialog.setFocus(true)
    end if
end sub

sub onKeyboardDialogText()
    text = m.keyboardDialog.text
    
    ' Enviar o texto para o campo de pesquisa
    jsCode = "if (window.rokuNavigation.searchInput) { " + 
             "window.rokuNavigation.searchInput.value = '" + text + "'; " +
             "window.rokuNavigation.searchInput.dispatchEvent(new Event('input')); " +
             "window.rokuNavigation.searchInput.form.submit(); " +
             "}"
    
    m.webView.executeJavaScript(jsCode)
    
    ' Esconder o teclado
    m.keyboardDialog.visible = false
    m.webView.setFocus(true)
    m.searchInputFocused = false
end sub

sub navigateBack()
    jsCode = "history.back();"
    m.webView.executeJavaScript(jsCode)
end sub