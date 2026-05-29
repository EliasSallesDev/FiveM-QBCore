local Translations = {
    info = {
        open_shop = '[E] Loja',
        deliver_e = '~g~E~w~ - Entregar Produtos',
        deliver = 'Entregar Produtos',
    },
    error = {
        missing_license = 'Falta uma licença %s para certos produtos',
        no_deposit = 'Depósito de $%{value} requerido',
        cancelled = 'Cancelado',
        vehicle_not_correct = 'Este não é um veículo comercial!',
        no_driver = 'Você deve ser o motorista para fazer isso.',
        no_work_done = 'Você ainda não fez nenhum trabalho.',
        not_trucker = 'Você precisa ser caminhoneiro para fazer entregas',
        backdoors_not_open = 'As portas traseiras do veículo não estão abertas',
        get_out_vehicle = 'Você precisa sair do veículo para executar esta ação',
        too_far_from_trunk = 'Você precisa pegar as caixas no porta-malas do seu veículo',
        too_far_from_delivery = 'Você precisa estar mais perto do ponto de entrega'
    },
    success = {
        dealer_verify = 'O comerciante verificou sua licença',
        paid_with_cash = 'Depósito de $%{value} pago em dinheiro',
        paid_with_bank = 'Depósito de $%{value} pago pelo banco',
        refund_to_cash = 'Depósito de $%{value} devolvido em dinheiro',
        you_earned = 'Você ganhou $%{value}',
        payslip_time = 'Você visitou todas as lojas. Hora do seu pagamento!',
    },
    mission = {
        store_reached = 'Loja alcançada. Pegue uma caixa no porta-malas com [E] e entregue no marcador',
        take_box = 'Pegar uma caixa de produtos',
        deliver_box = 'Entregar a caixa de produtos',
        another_box = 'Pegue outra caixa de produtos',
        goto_next_point = 'Você entregou todos os produtos. Vá para o próximo ponto',
        return_to_station = 'Você entregou todos os produtos. Retorne à estação',
        job_started = 'Emprego de caminhoneiro iniciado. Vá até o Go Postal para começar as entregas',
        job_completed = 'Você completou sua rota'
    },
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end