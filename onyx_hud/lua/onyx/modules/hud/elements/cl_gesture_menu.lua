--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

16/08/2024

--]]

local animationsTable = {}
animationsTable[ ACT_GMOD_GESTURE_BOW ] = 'bow'
animationsTable[ ACT_GMOD_TAUNT_MUSCLE ] = 'sexy_dance'
animationsTable[ ACT_GMOD_GESTURE_BECON ] = 'follow_me'
animationsTable[ ACT_GMOD_TAUNT_LAUGH ] = 'laugh'
animationsTable[ ACT_GMOD_TAUNT_PERSISTENCE ] = 'lion_pose'
animationsTable[ ACT_GMOD_GESTURE_DISAGREE ] = 'nonverbal_no'
animationsTable[ ACT_GMOD_GESTURE_AGREE ] = 'thumbs_up'
animationsTable[ ACT_GMOD_GESTURE_WAVE ] = 'wave'
animationsTable[ ACT_GMOD_TAUNT_DANCE ] = 'dance'

local animationsFrame
local function openGestureMenu()
    if ( IsValid( animationsFrame ) ) then
        return
    end

    local size = onyx.hud.ScaleTall( 512 )

    local choiceWheel = vgui.Create( 'onyx.hud.ChoiceWheel' )
    animationsFrame = choiceWheel
    choiceWheel:SetSize( size, size )
    choiceWheel:SetShowLabel( false )
    choiceWheel:MakePopup()
    choiceWheel:Center()
    choiceWheel.OnRemove = function()
        animationsFrame = nil
    end

    choiceWheel:AddChoice( { name = onyx.lang:Get( 'close' ) } )
    
    for animID, animName in pairs( animationsTable ) do
        choiceWheel:AddChoice( {
            name = DarkRP.getPhrase( animName ),
            callback = function()
                RunConsoleCommand( '_DarkRP_DoAnimation', animID )                                                                                                                                                                                                                                                              -- b7fe7d19-18c9-42a0-823d-06e7663479ef
            end
        } )
    end
end

onyx.hud.OverrideGamemode( 'onyx.hud.OverrideGesturesMenu', function()
    concommand.Add( '_DarkRP_AnimationMenu', openGestureMenu )
end )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
