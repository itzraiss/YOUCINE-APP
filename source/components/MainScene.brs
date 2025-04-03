function init()
    m.webView = m.top.findNode("webView")
    m.loadingMessage = m.top.findNode("loadingMessage")
    
    ' Observar o status de carregamento para ocultar a mensagem
    m.webView.observeField("loadStatus", "onLoadStatusChanged")
    
    m.navigationJS = "
        // Função para destacar visualmente elementos interativos
        function setupHighlighting() {
            let style = document.createElement('style');
            style.textContent = `
                *:focus {
                    outline: 4px solid #ffcc00 !important;
                    box-shadow: 0 0 15px #ffcc00 !important;
                    border-radius: 5px !important;
                }
            `;
            document.head.appendChild(style);
            
            // Destacar o primeiro elemento interativo
            setTimeout(function() {
                let firstElement = document.querySelector('a, button, [role=button], .card, .movie-item, .poster, .play-button');
                if(firstElement) firstElement.focus();
            }, 2000);
        }
        
        // Chamar a configuração após o carregamento da página
        if(document.readyState === 'complete') {
            setupHighlighting();
        } else {
            window.addEventListener('load', setupHighlighting);
        }
        
        // Função para navegar para cima
        function simulateKeyUp() {
            let elements = document.querySelectorAll('a, button, [role=button], .card, .movie-item, .poster, .item, .thumb, .play-button, .episode-item');
            let currentFocus = document.activeElement;
            let closestAbove = null;
            let minDistance = Infinity;
            
            if (!currentFocus || currentFocus === document.body) {
                // Se nenhum elemento estiver em foco, encontre um próximo ao centro da tela
                let centerElement = document.elementFromPoint(window.innerWidth/2, window.innerHeight/2);
                if (centerElement) currentFocus = centerElement;
            }
            
            let currentRect = currentFocus.getBoundingClientRect();
            let currentY = currentRect.top + currentRect.height/2;
            
            for(let elem of elements) {
                let rect = elem.getBoundingClientRect();
                // Verificar se o elemento está visível na tela
                if (rect.height > 0 && rect.width > 0 && rect.bottom > 0 && rect.right > 0) {
                    let elemY = rect.top + rect.height/2;
                    let distance = currentY - elemY;
                    
                    if(distance > 10 && distance < minDistance) {
                        minDistance = distance;
                        closestAbove = elem;
                    }
                }
            }
            
            if(closestAbove) closestAbove.focus();
        }
        
        // Função para navegar para baixo
        function simulateKeyDown() {
            let elements = document.querySelectorAll('a, button, [role=button], .card, .movie-item, .poster, .item, .thumb, .play-button, .episode-item');
            let currentFocus = document.activeElement;
            let closestBelow = null;
            let minDistance = Infinity;
            
            if (!currentFocus || currentFocus === document.body) {
                // Se nenhum elemento estiver em foco, encontre um próximo ao centro da tela
                let centerElement = document.elementFromPoint(window.innerWidth/2, window.innerHeight/2);
                if (centerElement) currentFocus = centerElement;
            }
            
            let currentRect = currentFocus.getBoundingClientRect();
            let currentY = currentRect.top + currentRect.height/2;
            
            for(let elem of elements) {
                let rect = elem.getBoundingClientRect();
                // Verificar se o elemento está visível na tela
                if (rect.height > 0 && rect.width > 0 && rect.bottom > 0 && rect.right > 0) {
                    let elemY = rect.top + rect.height/2;
                    let distance = elemY - currentY;
                    
                    if(distance > 10 && distance < minDistance) {
                        minDistance = distance;
                        closestBelow = elem;
                    }
                }
            }
            
            if(closestBelow) closestBelow.focus();
        }
        
        // Função para navegar para a esquerda
        function simulateKeyLeft() {
            let elements = document.querySelectorAll('a, button, [role=button], .card, .movie-item, .poster, .item, .thumb, .play-button, .episode-item');
            let currentFocus = document.activeElement;
            let closestLeft = null;
            let minDistance = Infinity;
            
            if (!currentFocus || currentFocus === document.body) {
                // Se nenhum elemento estiver em foco, encontre um próximo ao centro da tela
                let centerElement = document.elementFromPoint(window.innerWidth/2, window.innerHeight/2);
                if (centerElement) currentFocus = centerElement;
            }
            
            let currentRect = currentFocus.getBoundingClientRect();
            let currentX = currentRect.left + currentRect.width/2;
            
            for(let elem of elements) {
                let rect = elem.getBoundingClientRect();
                // Verificar se o elemento está visível na tela
                if (rect.height > 0 && rect.width > 0 && rect.bottom > 0 && rect.right > 0) {
                    let elemX = rect.left + rect.width/2;
                    let distance = currentX - elemX;
                    
                    if(distance > 10 && distance < minDistance) {
                        minDistance = distance;
                        closestLeft = elem;
                    }
                }
            }
            
            if(closestLeft) closestLeft.focus();
        }
        
        // Função para navegar para a direita
        function simulateKeyRight() {
            let elements = document.querySelectorAll('a, button, [role=button], .card, .movie-item, .poster, .item, .thumb, .play-button, .episode-item');
            let currentFocus = document.activeElement;
            let closestRight = null;
            let minDistance = Infinity;
            
            if (!currentFocus || currentFocus === document.body) {
                // Se nenhum elemento estiver em foco, encontre um próximo ao centro da tela
                let centerElement = document.elementFromPoint(window.innerWidth/2, window.innerHeight/2);
                if (centerElement) currentFocus = centerElement;
            }
            
            let currentRect = currentFocus.getBoundingClientRect();
            let currentX = currentRect.left + currentRect.width/2;
            
            for(let elem of elements) {
                let rect = elem.getBoundingClientRect();
                // Verificar se o elemento está visível na tela
                if (rect.height > 0 && rect.width > 0 && rect.bottom > 0 && rect.right > 0) {
                    let elemX = rect.left + rect.width/2;
                    let distance = elemX - currentX;
                    
                    if(distance > 10 && distance < minDistance) {
                        minDistance = distance;
                        closestRight = elem;
                    }
                }
            }
            
            if(closestRight) closestRight.focus();
        }
        
        // Função para simular clique no elemento em foco
        function simulateClick() {
            let elem = document.activeElement;
            if(elem && elem.tagName) {
                if(elem.tagName.toLowerCase() === 'input' && (elem.type === 'text' || elem.type === 'search')) {
                    window.rokuBridge.fireSearchEvent();
                } else {
                    // Verificar se é um elemento de vídeo
                    if(document.querySelector('video') && (elem.closest('.player-container') || elem.closest('video'))) {
                        let video = document.querySelector('video');
                        if(video.paused) video.play(); else video.pause();
                    } else {
                        elem.click();
                    }
                }
            }
        }
        
        // Controles de reprodução de vídeo
        document.addEventListener('keydown', function(e) {
            if (document.querySelector('video')) {
                let video = document.querySelector('video');
                // Verificar se estamos em modo de reprodução de vídeo
                if (video.parentElement.clientWidth > (window.innerWidth * 0.5)) {
                    if (e.key === 'MediaPlayPause' || e.keyCode === 13) {
                        if (video.paused) video.play(); else video.pause();
                        return true;
                    }
                    if (e.key === 'MediaRewind' || e.keyCode === 37) {
                        video.currentTime -= 10;
                        return true;
                    }
                    if (e.key === 'MediaFastForward' || e.keyCode === 39) {
                        video.currentTime += 10;
                        return true;
                    }
                    
                    // Salvar posição para continuar assistindo depois
                    localStorage.setItem('lastVideo', window.location.href);
                    localStorage.setItem('lastPosition', video.currentTime);
                    localStorage.setItem('videoTitle', document.title);
                }
            }
        });
    "
    
    m.webView.addFunction("fireSearchEvent", function()
        m.top.searchClicked = true
    end function)
    
    ' Injetar o JavaScript após um breve atraso para garantir que a página carregou
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 1
    m.timer.observeField("fire", "onTimerFire")
    m.timer.control = "start"
    
    m.top.observeField("searchClicked", "onSearchClicked")
end function

function onTimerFire()
    m.webView.injectJavaScript(m.navigationJS)
end function

function onLoadStatusChanged()
    if m.webView.loadStatus = "loading" then
        m.loadingMessage.visible = true
    else if m.webView.loadStatus = "complete" then
        m.loadingMessage.visible = false
        m.webView.setFocus(true)
        
        ' Injetar o JavaScript novamente após o carregamento completo
        m.webView.injectJavaScript(m.navigationJS)
    else if m.webView.loadStatus = "failed" then
        ' Mostrar caixa de diálogo de erro
        showErrorDialog("Erro ao carregar o site. Verifique sua conexão com a internet.")
    end if
end function

function showErrorDialog(message as String)
    dialog = CreateObject("roSGNode", "Dialog")
    dialog.title = "Erro de Conexão"
    dialog.message = message
    dialog.buttons = ["Tentar Novamente", "Sair"]
    m.top.dialog = dialog
    
    ' Observar a resposta do diálogo
    m.top.observeField("dialogResponse", "onDialogResponse")
end function

function onDialogResponse(event as Object)
    response = event.getData()
    
    if response = 0 then
        ' Tentar novamente - recarregar a página
        m.webView.url = "https://www.youcinetv.vip/"
    else
        ' Sair do aplicativo
        m.top.findNode("exitApp").callFunc("exit", invalid)
    end if
end function

function onSearchClicked()
    if m.top.searchClicked = true then
        showKeyboard()
    end if
end function

function showKeyboard()
    keyboardScreen = CreateObject("roSGNode", "KeyboardScreen")
    keyboardScreen.observeField("searchText", "onSearchTextReceived")
    keyboardScreen.observeField("close", "onKeyboardClosed")
    m.top.appendChild(keyboardScreen)
    keyboardScreen.setFocus(true)
end function

function onSearchTextReceived(event as Object)
    searchText = event.getData()
    
    searchJS = "
        let searchInputs = document.querySelectorAll('input[type=search], input[type=text].search, .search-input, input[placeholder*=\"Buscar\"], input[placeholder*=\"Pesquisar\"]');
        if(searchInputs.length > 0) {
            searchInputs[0].value = '" + searchText + "';
            searchInputs[0].dispatchEvent(new Event('input'));
            searchInputs[0].form ? searchInputs[0].form.submit() : searchInputs[0].dispatchEvent(new Event('change'));
        }
    "
    
    m.webView.injectJavaScript(searchJS)
    
    m.top.removeChild(m.top.findNode("KeyboardScreen"))
    m.webView.setFocus(true)
end function

function onKeyboardClosed(event as Object)
    if event.getData() = true then
        m.top.removeChild(m.top.findNode("KeyboardScreen"))
        m.webView.setFocus(true)
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "up" then
            m.webView.injectJavaScript("simulateKeyUp()")
            return true
        else if key = "down" then
            m.webView.injectJavaScript("simulateKeyDown()")
            return true
        else if key = "left" then
            m.webView.injectJavaScript("simulateKeyLeft()")
            return true
        else if key = "right" then
            m.webView.injectJavaScript("simulateKeyRight()")
            return true
        else if key = "OK" then
            m.webView.injectJavaScript("simulateClick()")
            return true
        end if
    end if
    return false
end function 