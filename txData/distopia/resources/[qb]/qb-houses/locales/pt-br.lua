local Translations = {
    error = {
        ["no_keys"] = "VocÃƒÂª nÃƒÂ£o possui as chaves da casa...",
        ["not_in_house"] = "VocÃƒÂª nÃƒÂ£o estÃƒÂ¡ em uma casa!",
        ["out_range"] = "VocÃƒÂª saiu do alcance",
        ["no_key_holders"] = "Nenhum detentor de chaves encontrado...",
        ["invalid_tier"] = "Nivel de casa invalido",
        ["no_house"] = "NÃƒÂ£o hÃƒÂ¡ uma casa perto de vocÃƒÂª",
        ["no_door"] = "VocÃƒÂª nÃƒÂ£o estÃƒÂ¡ perto o suficiente da porta...",
        ["locked"] = "A casa estÃƒÂ¡ trancada!",
        ["no_one_near"] = "NinguÃƒÂ©m por perto!",
        ["not_owner"] = "VocÃƒÂª nÃƒÂ£o ÃƒÂ© dono desta casa.",
        ["no_police"] = "NÃƒÂ£o hÃƒÂ¡ forÃƒÂ§a policial presente...",
        ["already_open"] = "Esta casa jÃƒÂ¡ estÃƒÂ¡ aberta...",
        ["failed_invasion"] = "Falhou, tente novamente",
        ["inprogress_invasion"] = "AlguÃƒÂ©m jÃƒÂ¡ estÃƒÂ¡ trabalhando na porta...",
        ["no_invasion"] = "Esta porta nÃƒÂ£o estÃƒÂ¡ arrombada...",
        ["realestate_only"] = "Somente agentes imobiliÃƒÂ¡rios podem usar este comando",
        ["emergency_services"] = "Isso sÃƒÂ³ ÃƒÂ© possÃƒÂ­vel para serviÃƒÂ§os de emergÃƒÂªncia!",
        ["already_owned"] = "Esta casa jÃƒÂ¡ estÃƒÂ¡ ocupada!",
        ["not_enough_money"] = "VocÃƒÂª nÃƒÂ£o tem dinheiro suficiente...",
        ["remove_key_from"] = "As chaves foram removidas de %{firstname} %{lastname}",
        ["already_keys"] = "Essa pessoa jÃƒÂ¡ tem as chaves da casa!",
        ["something_wrong"] = "Algo deu errado, tente novamente!",
        ["nobody_at_door"] = 'NÃƒÂ£o hÃƒÂ¡ ninguÃƒÂ©m na porta...'
    },
    success = {
        ["unlocked"] = "A casa estÃƒÂ¡ destrancada!",
        ["home_invasion"] = "A porta estÃƒÂ¡ agora aberta.",
        ["lock_invasion"] = "VocÃƒÂª trancou a casa novamente...",
        ["recieved_key"] = "VocÃƒÂª recebeu as chaves de %{value}!",
        ["house_purchased"] = "VocÃƒÂª comprou a casa com sucesso!"
    },
    info = {
        ["door_ringing"] = "AlguÃƒÂ©m estÃƒÂ¡ tocando a campainha!",
        ["speed"] = "Velocidade ÃƒÂ© %{value}",
        ["added_house"] = "VocÃƒÂª adicionou uma casa: %{value}",
        ["added_garage"] = "VocÃƒÂª adicionou uma garagem: %{value}",
        ["exit_camera"] = "Sair da CÃƒÂ¢mera",
        ["house_for_sale"] = "Casa ÃƒÂ  venda",
        ["decorate_interior"] = "Decorar Interior",
        ["create_house"] = "Criar Casa (Apenas para agentes imobiliÃƒÂ¡rios)",
        ["price_of_house"] = "PreÃƒÂ§o da casa",
        ["tier_number"] = "Numero do nivel da casa",
        ["add_garage"] = "Adicionar Garagem ÃƒÂ  Casa (Apenas para agentes imobiliÃƒÂ¡rios)",
        ["ring_doorbell"] = "Tocar a Campainha"
    },
    menu = {
        ["house_options"] = "OpÃƒÂ§ÃƒÂµes da Casa",
        ["close_menu"] = "Ã¢Â¬â€¦ Fechar Menu",
        ["enter_house"] = "Entrar na Sua Casa",
        ["give_house_key"] = "Dar Chave da Casa",
        ["exit_property"] = "Sair da Propriedade",
        ["front_camera"] = "CÃƒÂ¢mera Frontal",
        ["back"] = "Voltar",
        ["remove_key"] = "Remover Chave",
        ["open_door"] = "Abrir Porta",
        ["view_house"] = "Ver Casa",
        ["ring_door"] = "Tocar a Campainha",
        ["exit_door"] = "Sair da Propriedade",
        ["open_stash"] = "Abrir Esconderijo",
        ["stash"] = "Esconderijo",
        ["change_outfit"] = "Mudar Visual",
        ["outfits"] = "Visuais",
        ["change_character"] = "Mudar Personagem",
        ["characters"] = "Personagens",
        ["enter_unlocked_house"] = "Entrar em uma Casa Destrancada",
        ["lock_door_police"] = "Trancar Porta"
    },
    target = {
        ["open_stash"] = "[E] Abrir Esconderijo",
        ["outfits"] = "[E] Mudar Visuais",
        ["change_character"] = "[E] Mudar Personagem",
    },
    log = {
        ["house_created"] = "Casa Criada:",
        ["house_address"] = "**EndereÃƒÂ§o**: %{label}\n\n**PreÃƒÂ§o de Venda**: %{price}\n\n**Nivel**: %{tier}\n\n**Agente de Vendas**: %{agent}",
        ["house_purchased"] = "Casa Comprada:",
        ["house_purchased_by"] = "**EndereÃƒÂ§o**: %{house}\n\n**PreÃƒÂ§o da Compra**: %{price}\n\n**Comprador**: %{firstname} %{lastname}"
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end