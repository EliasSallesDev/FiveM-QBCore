local Translations = {
    notify = {
        ydhk = 'Voce nao tem as chaves deste veiculo.',
        nonear = 'Nao ha ninguem por perto para entregar as chaves.',
        vlock = 'Veiculo trancado!',
        vunlock = 'Veiculo destrancado!',
        vlockpick = 'Voce conseguiu abrir a fechadura!',
        fvlockpick = 'Voce nao encontrou as chaves e ficou frustrado.',
        vgkeys = 'Voce entregou as chaves.',
        vgetkeys = 'Voce recebeu as chaves do veiculo!',
        vlkeys = 'Voce emprestou chaves temporarias.',
        vborrowkeys = 'Voce recebeu chaves emprestadas temporariamente!',
        fpid = 'Preencha o ID do jogador e a placa.',
        cjackfail = 'Falha ao roubar o veiculo!',
        vehclose = 'Nao ha nenhum veiculo por perto!',
    },
    progress = {
        takekeys = 'Pegando as chaves do corpo...',
        hskeys = 'Procurando as chaves do veiculo...',
        acjack = 'Tentando roubar o veiculo...',
    },
    info = {
        skeys = '~g~[H]~w~ - Procurar chaves',
        tlock = 'Trancar/destrancar veiculo',
        palert = 'Roubo de veiculo em andamento. Tipo: ',
        engine = 'Ligar/desligar motor',
    },
    addcom = {
        givekeys = 'Entregar as chaves para alguem. Sem ID, entrega para a pessoa mais proxima ou para todos no veiculo.',
        givekeys_id = 'id',
        givekeys_id_help = 'ID do jogador',
        lendkeys = 'Emprestar chaves temporarias para alguem por perto. A chave nao fica salva e some ao relogar ou reiniciar.',
        lendkeys_id = 'id',
        lendkeys_id_help = 'ID do jogador',
        addkeys = 'Adicionar chaves de um veiculo para alguem.',
        addkeys_id = 'id',
        addkeys_id_help = 'ID do jogador',
        addkeys_plate = 'placa',
        addkeys_plate_help = 'Placa do veiculo',
        rkeys = 'Remover chaves de um veiculo de alguem.',
        rkeys_id = 'id',
        rkeys_id_help = 'ID do jogador',
        rkeys_plate = 'placa',
        rkeys_plate_help = 'Placa do veiculo',
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
