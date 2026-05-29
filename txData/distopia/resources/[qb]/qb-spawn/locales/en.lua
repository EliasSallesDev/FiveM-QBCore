local Translations = {
    ui = {
        last_location = "Ultima localizacao",
        confirm = "Confirmar",
        where_would_you_like_to_start = "Onde voce gostaria de comecar?",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
