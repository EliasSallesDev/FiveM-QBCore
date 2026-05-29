local Translations = {
    notify = {
        ["hud_settings_loaded"] = "Configuracoes da HUD carregadas!",
        ["hud_restart"] = "A HUD esta reiniciando!",
        ["hud_start"] = "A HUD foi iniciada!",
        ["hud_command_info"] = "Este comando redefine suas configuracoes atuais da HUD!",
        ["load_square_map"] = "Carregando mapa quadrado...",
        ["loaded_square_map"] = "Mapa quadrado carregado!",
        ["load_circle_map"] = "Carregando mapa redondo...",
        ["loaded_circle_map"] = "Mapa redondo carregado!",
        ["cinematic_on"] = "Modo cinematico ativado!",
        ["cinematic_off"] = "Modo cinematico desativado!",
        ["engine_on"] = "Motor ligado!",
        ["engine_off"] = "Motor desligado!",
        ["low_fuel"] = "Nivel de combustivel baixo!",
        ["access_denied"] = "Voce nao tem autorizacao!",
        ["stress_gain"] = "Voce esta ficando mais estressado!",
        ["stress_removed"] = "Voce esta ficando mais relaxado!"
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
