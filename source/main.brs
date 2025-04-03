sub Main()
    print "YouCineTV Iniciando"
    
    ' Configuração da tela inicial
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    ' Criando a cena principal
    scene = screen.CreateScene("MainScene")
    screen.show()
    
    ' Loop principal do aplicativo
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then
                return
            end if
        end if
    end while
end sub