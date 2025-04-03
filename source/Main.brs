sub Main()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    scene = screen.CreateScene("MainScene")
    
    ' Criar um nó para permitir sair do aplicativo
    exitApp = CreateObject("roSGNode", "ContentNode")
    exitApp.addField("exit", "funcNode", false)
    exitApp.observeField("exitTriggered", m.port)
    exitApp.exit = function() : m.exitTriggered = true : end function
    scene.addChild(exitApp)
    scene.id = "exitApp"
    
    screen.show()
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        else if msgType = "roSGNodeEvent"
            if msg.getField() = "exitTriggered" then
                return
            end if
        end if
    end while
end sub 