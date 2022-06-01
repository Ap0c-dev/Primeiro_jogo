local fisica = require("physics")--importa a biblioteca
fisica.start()                   --inicia a fisica
fisica.setDrawMode("hybrid")     --difine como será a visualização dos elementos físico
fisica.setGravity(0, 10.8);
display.setStatusBar(display.HiddenStatusBar);

_w = display.contentWidth
_h = display.contentHeight

local tictac

display.setDefault("anchorX",-1)
display.setDefault("anchorY",-1)

local fundo = display.newImageRect("images/Backgrounds/blue_grass.png", _h, _h);

local madeira = display.newImageRect("images/Wood/elementWood014.png", (_w/3), 30)
fisica.addBody(madeira, "static");
madeira.nome = "Madeira"
madeira.y = _h - madeira.height

local madeira1 = display.newImageRect("images/Wood/elementWood014.png", (_w/3), 30)
fisica.addBody(madeira1, "static");
madeira1.nome = "Madeira"
madeira1.y = _h - madeira1.height
madeira1.x = _w - madeira1.width

local metal = display.newImageRect("images/Metal/elementMetal012.png", (_w/3), 30)
fisica.addBody(metal, "static");
metal.nome = "Metal"
metal.y = _h - metal.height
metal.x = 107

local pedra = display.newImageRect("images/Stone/elementStone015.png", 80, 30)
fisica.addBody(pedra, "static");
pedra.nome = "Pedra"
pedra.y = 400
pedra.x = 122


pontos = 0;
local pontos = display.newText("000", 10, 10, 240, 300, native.systemFontBold, 23)
pontos.text = "000"
pontos:setFillColor( 0, 0, 0);


local star1 = display.newImageRect("images/Other/starGold.png", 30,30)
star1.y = 10
star1.x = 250
star1.nome = "Star"
local star2 = display.newImageRect("images/Other/starGold.png", 30,30)
star2.y = 10
star2.x = 270
star2.nome = "Star"
local star3 = display.newImageRect("images/Other/starGold.png", 30,30)
star3.y = 10
star3.x = 290
star3.nome = "Star"


local paredeEsq = display.newRect(-10, 0, 10, _h);
fisica.addBody(paredeEsq, "static");
paredeEsq.nome = "Parede"
local paredeDir = display.newRect(_w, 0, 10, _h);
fisica.addBody(paredeDir, "static");
paredeDir.nome = "Parede"

local chao = display.newRect(0,500, _w, _h);
fisica.addBody(chao, "static");
chao.nome = "Chao"

local listaAliens = {}

--Funções
vidaMetal = 0
vidaAlien = 0
vidaChao = 0;
colide = 0
contador = -1;

local function colideAlien(self, ev)
       
    if ev.other.nome == "Madeira" then 
        ev.other:removeSelf();  
    end

    if ev.other.nome == "Metal" then       
        vidaMetal = vidaMetal + 1
        if vidaMetal == 3 then
            ev.other:removeSelf(); 
            
        end
    end

    if ev.other.nome == "Chao" then
        vidaChao = vidaChao + 1;     
        ev.target:removeSelf()
        if vidaChao == 1 then
            display.remove(star1)
        end

        if vidaChao == 2 then
            display.remove(star2)
        end

        if vidaChao == 3 then
            display.remove(star3)
            timer.cancel(tictac)
            display.remove(pedra);
            display.remove(chao);
            local gameOver display.newImageRect("images/gameOver.png", _w, _h)
        end        
    end 
    
    if (ev.target.nome == "Alien" and ev.other.nome == "Pedra") then
        vidaAlien = vidaAlien + 1;
        if (vidaAlien == 6) then
            contador = contador + 10;
            ev.target:removeSelf();
            pontos:removeSelf();
            pontos = contador + 1;
            pontos = display.newText(pontos, 10, 10, native.systemFontBold, 23)
            pontos:setFillColor( 0, 0, 0);
            vidaAlien = 0;
        end
    end 
end


local function criaAlien(ev)
    local alien = display.newImageRect("images/Aliens/alienYellow_round.png",50,50)
    alien.x = math.random(_w )
    alien.y = math.random(20)
    fisica.addBody(alien,"dynamic", {density = 2, bounce = 0.6, radius=25});
    alien.nome = "Alien"
    alien.collision = colideAlien
    alien:addEventListener("collision")
    table.insert(listaAliens, alien);  
    print("Insert ", table.maxn(listaAliens));

end

function pedra:touch( event )
    if ( event.phase == "began" ) then        
        display.getCurrentStage():setFocus( self )
        self.isFocus = true
 
    elseif ( self.isFocus ) then
        if ( event.phase == "moved" ) then
            pedra.x = event.x
            
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            pedra.x = 107
                      
        end
    end
    return true
end

local function cancelaJogo()
    if( tictac ~= nill )then
        timer.cancel(tictac);
    end
end

--Eventos

Runtime:addEventListener( "touch", pedra )

tictac = timer.performWithDelay(4000, criaAlien, 10)
 