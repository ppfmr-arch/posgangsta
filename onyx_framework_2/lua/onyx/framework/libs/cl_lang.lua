--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[

Author: tochonement
Email: tochonement@gmail.com

28.09.2021

--]]

onyx.lang = onyx.lang or {}
onyx.lang.phrases = onyx.lang.phrases or {}
onyx.lang.id = onyx.lang.id or 'default'

local lang = onyx.lang

function lang:AddPhrase(langID, phraseID, text)
    self.phrases[langID] = self.phrases[langID] or {}
    self.phrases[langID][phraseID] = text
end

function lang:AddPhrases(langID, phrasesTable)
    for phraseID, text in pairs(phrasesTable) do
        self:AddPhrase(langID, phraseID, text)
    end
end

do
    local gsub = string.gsub
    local tostring = tostring
    local pairs = pairs

    function lang:Get(phraseID, arguments, translateArguments)
        local basePhrases = self.phrases.english or {}
        local localPhrases = self.phrases[self.id] or {}
        local text

        -- Search in the local phrases table
        if localPhrases[phraseID] then
            text = localPhrases[phraseID]
            goto process
        end

        -- Search in the base phrases table
        if basePhrases[phraseID] then
            text = basePhrases[phraseID]
            goto process
        end

        ::process::

        -- Place the arguments into the found text
        if text and arguments then
            for key, value in pairs(arguments) do
                value = tostring(value)

                local argument = translateArguments and lang:Get(value) or value

                text = gsub(text, '{' .. key .. '}', argument, 1)
            end
        end

        return text or phraseID
    end

    function lang:GetWFallback(phraseID, fallback)
        local phrase = self:Get(phraseID)
        if (phrase == phraseID) then
            return (fallback or phrase)
        else
            return phrase
        end
    end
end

do
    local languageReference = {
        en = 'english',
        ru = 'russian',
        de = 'german',
        fr = 'french',
        it = 'italian',
        tr = 'turkish',
        da = 'danish',
        pl = 'polish',
        ['es-ES'] = 'spanish'
    }

    function lang:GetGameLanguage()
        local current = GetConVar('gmod_language'):GetString()
        return languageReference[current]
    end

    function lang:SetBestLanguage()
        local found = self:GetGameLanguage()
        if (found) then
            self.id = found
        else
            self.id = 'default'
        end
    end

    lang:SetBestLanguage()

    cvars.AddChangeCallback('gmod_language', function()
        lang:SetBestLanguage()
    end, 'onyx.lang')
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
