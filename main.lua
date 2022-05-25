local fisica = require("physics")--importa a biblioteca
fisica.start()                   --inicia a fisica
fisica.setDrawMode("hybrid")     --difine como será a visualização dos elementos físico
fisica.setGravity(0, 9.8);
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


local tabelaStars = {
    {x=250, y=10, image="Other/starGold.png", nome = "Star"},
    {x=270, y=10, image="Other/starGold.png", nome = "Star"},
    {x=290, y=10, image="Other/starGold.png", nome = "Star"}
}


local listaStars = {}
for i = 1, #tabelaStars do
    local peca = display.newImageRect("images/"..tabelaStars[i].image,30 ,30);
    peca.x = tabelaStars[i].x
    peca.y = tabelaStars[i].y
    peca.nome = tabelaStars[i].nome
   -- peca.collision = colideAlien
    table.insert(listaStars, peca);  

end

-- listaStars[1].rotation = 0

-- local star1 = display.newImageRect("images/Other/starGold.png", 30,30)
-- star1.y = 10
-- star1.x = 250
-- star1.nome = "Star"
-- local star2 = display.newImageRect("images/Other/starGold.png", 30,30)
-- star2.y = 10
-- star2.x = 270
-- star2.nome = "Star"
-- local star3 = display.newImageRect("images/Other/starGold.png", 30,30)
-- star3.y = 10
-- star3.x = 290
-- star3.nome = "Star"


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
points  = 0;
toque = 0
vidaAlien = 6
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
      
        ev.target:removeSelf()
        print(table.maxn(listaStars));
        table.remove(listaStars, peca)  
        display.remove(listaStars, peca) 
    end 
    
    if ev.other.nome == "Pedra" then
        vidaAlien = vidaAlien -1    
        if vidaAlien == 1 then
            ev.target:removeSelf()
            table.remove(listaAliens, alien);  
            print("Remove ", table.maxn(listaAliens));
            -- print("eu"..points)
        end
    end

    
end

local function criaAlien(ev)
    local alien = display.newImageRect("images/Aliens/alienYellow_round.png",50,50)
    alien.x = math.random(_w )
    alien.y = math.random(20)
    fisica.addBody(alien,"dynamic", {density = 1, bounce = 0.7, radius=25});
    alien.nome = "Alien"
    alien.collision = colideAlien
    alien:addEventListener("collision")
    table.insert(listaAliens, alien);  
    print("Insert ", table.maxn(listaAliens));

end


 local scoreText = display.newText( "0000", display.contentCenterX, 60, native.systemFont, 48 )
 
-- local function lerp( v0, v1 )
    
--     return v0 +  v1
-- end
 
-- local function incrementScore( target, amount, duration, startValue )
 
--     local newScore = startValue or 0
--     local passes = (duration/1000) * display.fps
--     local increment = lerp( 1, 1 )
 
--     local count = 0
--     local function updateText()
--         if ( count <= passes ) then
--             newScore = newScore + increment
--             target.text = string.format( "%04d", newScore )
--             count = count + 1
--         else
--             Runtime:removeEventListener( "enterFrame", updateText )
--             target.text = string.format( "%04d", amount + (startValue or 0) )
--         end
--     end
 
--     Runtime:addEventListener( "enterFrame", updateText )
-- end



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


-- incrementScore( scoreText, 1000, 4000 )

--Eventos

Runtime:addEventListener( "touch", pedra )

tictac = timer.performWithDelay(1000, criaAlien, 2)

