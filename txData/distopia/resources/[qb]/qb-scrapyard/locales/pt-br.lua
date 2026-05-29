local Translations = {
    error = {
        smash_own = "Voce nao pode destruir um veiculo que voce possui.",
        cannot_scrap = "Este veiculo nao pode ser desmontado.",
        not_driver = "Voce nao e o motorista.",
        demolish_vehicle = "Voce nao tem permissao para demolir veiculos agora.",
        canceled = "Cancelado",
        active_job = "Voce ja tem um servico de sucata ativo.",
        no_active_job = "Voce nao tem nenhum servico de sucata ativo.",
        cooldown = "Aguarde %{value} minuto(s) antes de pedir outro servico.",
        not_enough_money = "Voce precisa de $%{value} em dinheiro para aluguel e caucao.",
        wrong_vehicle = "Esse nao e o veiculo solicitado.",
        vehicle_missing = "O veiculo do servico nao foi encontrado.",
        vehicle_too_far = "Traga o veiculo solicitado ate a area de entrega.",
        too_far = "Voce esta muito longe da area de entrega.",
        expired = "O servico expirou.",
        job_canceled = "Servico de sucata cancelado. A caucao foi perdida.",
    },
    success = {
        tow_rented = "Guincho alugado. Verifique o e-mail com a pista do veiculo.",
        job_started = "Servico iniciado: procure um %{vehicle} em %{zone}.",
        job_complete = "Servico concluido. Voce recebeu $%{value} incluindo a devolucao da caucao.",
    },
    text = {
        scrapyard = 'Sucata',
        request_job = '[E] - Pedir servico de guincho | [G] - Cancelar servico',
        request_job_target = 'Pedir servico de guincho',
        cancel_job_target = 'Cancelar servico',
        disassemble_vehicle = '[E] - Entregar e desmontar veiculo',
        disassemble_vehicle_target = 'Entregar e desmontar veiculo',
        demolish_vehicle = 'Desmontando veiculo',
        search_area = 'Area de busca da sucata',
    },
    email = {
        sender = 'Sucata Turner',
        subject = 'Servico de recuperacao',
        message = 'Tenho uma informacao para voce.<br /><br /><strong>Veiculo:</strong> %{vehicle}<br /><strong>Raridade:</strong> %{rarity}<br /><strong>Regiao:</strong> %{zone}<br /><strong>Placa:</strong> %{plate}<br /><br />%{hint}<br /><br />Leve o carro para a sucata em ate %{minutes} minutos. O guincho ja esta separado para voce.',
    },
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
