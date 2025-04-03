' Arquivo Main.brs - Ponto de entrada do aplicativo
sub Main()
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("MainScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    
    while true
        msg = wait(0, port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
