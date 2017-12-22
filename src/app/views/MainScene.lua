
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

local pukeEffect = import(".pokerEffects")

--MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    
    -- you can create scene with following comment code instead of using csb file.
    -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    -- -- add HelloWorld label
    -- local s = cc.Label:createWithSystemFont("Hello World", "Arial", 60)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)

    -- self:cutpuc("vsc.png",s,function( path )
    --     -- body
    -- end)

    local pukeLayer = pukeEffect("paibei.png","1.png")
    pukeLayer:addTo(self)

end


function MainScene:cutpuc(path,node,call_func)
    local  size = node:getContentSize()
    local _render_texture = cc.RenderTexture:create(size.width,size.height)
    local x,y = node:getPosition()
    --node:setPosition(0,0)
    _render_texture:beginWithClear(0,0,0,0)
    node:visit()
    _render_texture:endToLua()
     node:setPosition(x,y)
    _render_texture:saveToFile(path,cc.IMAGE_FORMAT_PNG,true,function(_save)
        Log.d("render texture save succeed:".._save)
        call_func(_save)
    end)
end

return MainScene
