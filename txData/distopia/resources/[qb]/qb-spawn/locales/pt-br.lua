local Translations = {
    ui = {
        last_location = "Ultima localizacao",
        confirm = "Confirmar",
        where_would_you_like_to_start = "Onde voce gostaria de comecar?",
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
