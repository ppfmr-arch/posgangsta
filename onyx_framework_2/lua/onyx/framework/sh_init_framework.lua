--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

AddCSLuaFile('onyx/framework/libs/thirdparty/data/utf8_chunk_1.lua')
AddCSLuaFile('onyx/framework/libs/thirdparty/data/utf8_chunk_2.lua')
AddCSLuaFile('onyx/framework/libs/thirdparty/data/utf8_chunk_3.lua')
AddCSLuaFile('onyx/framework/libs/thirdparty/data/utf8_chunk_4.lua')

onyx.IncludeFolder('onyx/framework/libs/thirdparty/')
onyx.IncludeFolder('onyx/framework/libs/')
onyx.IncludeFolder('onyx/framework/core/')

if (SERVER) then
    onyx.lang = {Get = function(phraseID)
        return phraseID
    end}
    onyx.lang.GetWFallback = onyx.lang.Get
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
