local Translations = {
    success = {
        withdraw = 'Saque realizado com sucesso',
        deposit = 'Depósito realizado com sucesso',
        transfer = 'Transferência realizada com sucesso',
        account = 'Conta criada',
        rename = 'Conta renomeada',
        delete = 'Conta excluída',
        userAdd = 'Usuário adicionado',
        userRemove = 'Usuário removido',
        card = 'Cartão criado',
        give = '$%s em dinheiro entregue',
        receive = '$%s em dinheiro recebido',
    },
    error = {
        error = 'Ocorreu um erro',
        access = 'Sem autorização',
        account = 'Conta não encontrada',
        accounts = 'Limite máximo de contas atingido',
        user = 'Usuário já adicionado',
        noUser = 'Usuário não encontrado',
        money = 'Dinheiro insuficiente',
        pin = 'PIN inválido',
        card = 'Nenhum cartão bancário encontrado',
        amount = 'Valor inválido',
        toofar = 'Você está muito longe',
    },
    progress = {
        atm = 'Acessando caixa eletrônico',
    },
    target = {
        bank = 'Abrir banco',
        atm = 'Abrir caixa eletrônico',
    },
    text = {
        bank = 'Abrir banco',
    },
    command = {
        givecash = 'Dar dinheiro',
        id = 'ID do jogador',
        amount = 'Valor',
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
