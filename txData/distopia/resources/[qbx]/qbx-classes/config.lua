Config = Config or {}

Config.ClassXpBase = 90
Config.MaxClassLevel = 30
Config.NotifyClassChange = true
Config.NotifyClassXpGain = false
Config.NotifyClassLevelUp = true

Config.MinGrantAmount = 1
Config.MaxGrantAmount = 2500
Config.SingleClassOnly = true
Config.ResetTargetProgressOnClassChange = true
Config.FreeInitialClassChoice = true
Config.ClassChangeCooldown = 0
Config.BlockClassChangeWhileInCombat = true
Config.CombatStateKeys = {
    'inCombat',
    'isInCombat',
}

Config.ClassChangeItem = {
    enabled = true,
    inventory = 'qb-inventory',
    item = 'class_change_token',
    label = 'Token de Troca de Classe',
    description = 'Permite trocar de classe uma vez. O item e consumido na troca.',
    image = 'certificate.png',
    weight = 0,
    amount = 1,
}

Config.AbilityHotkey = {
    command = 'classabilityquick',
    description = 'Usar habilidade ativa da classe',
    defaultKey = 'H',
}

Config.AbilityResourceCheck = function(_src, _ability, _classData)
    return true
end

Config.AbilityResourceConsume = function(_src, _ability, _classData)
    return true
end

Config.AllowedReasons = {
    admin = true,
    combat = true,
    quest = true,
    training = true,
    survival = true,
}

Config.RateLimits = {
    default = { window = 60, max = 20 },
    combat = { window = 30, max = 10 },
    training = { window = 60, max = 8 },
}

Config.Classes = {
    warrior = {
        label = 'Guerreiro',
        role = 'Tanque / corpo a corpo',
        description = 'Especialista em mitigacao e presenca na linha de frente.',
    },
    hunter = {
        label = 'Cacador',
        role = 'Dano a distancia / tracking',
        description = 'Especialista em precisao, rastreio e combate a distancia.',
    },
    medic = {
        label = 'Medico',
        role = 'Suporte / cura',
        description = 'Especialista em cura e sustentacao de equipe.',
    },
    survivor = {
        label = 'Sobrevivente',
        role = 'Utilidade / resistencia',
        description = 'Perfil equilibrado para exploracao e sobrevivencia geral.',
    },
    engineer = {
        label = 'Engenheiro',
        role = 'Craft de campo / suporte tecnico',
        description = 'Especialista em utilidade tecnica e equipamentos de campo.',
    },
}

Config.ClassMods = {
    warrior = {
        damage = 1.05,
        mitigation = 1.12,
        healing = 0.95,
        staminaDrain = 0.95,
        accuracy = 1.0,
        tracking = 0.9,
        crafting = 0.95,
    },
    hunter = {
        damage = 1.08,
        mitigation = 0.98,
        healing = 0.95,
        staminaDrain = 0.98,
        accuracy = 1.12,
        tracking = 1.15,
        crafting = 0.95,
    },
    medic = {
        damage = 0.95,
        mitigation = 1.0,
        healing = 1.18,
        staminaDrain = 1.0,
        accuracy = 1.0,
        tracking = 1.0,
        crafting = 1.0,
    },
    survivor = {
        damage = 1.0,
        mitigation = 1.04,
        healing = 1.0,
        staminaDrain = 0.9,
        accuracy = 1.0,
        tracking = 1.0,
        crafting = 1.0,
    },
    engineer = {
        damage = 0.98,
        mitigation = 1.02,
        healing = 1.0,
        staminaDrain = 1.0,
        accuracy = 1.0,
        tracking = 0.95,
        crafting = 1.15,
    },
}

Config.DefaultModifiers = {
    damage = 1.0,
    mitigation = 1.0,
    healing = 1.0,
    staminaDrain = 1.0,
    accuracy = 1.0,
    tracking = 1.0,
    crafting = 1.0,
}

Config.Abilities = {
    guard_stance = {
        label = 'Postura defensiva',
        description = 'Reduz o impacto recebido por alguns segundos e ajuda o guerreiro a segurar a linha de frente.',
        class = 'warrior',
        minLevel = 1,
        staminaCost = 25,
        duration = 12,
        cooldown = 45,
    },
    mark_prey = {
        label = 'Marcar presa',
        description = 'Marca um alvo prioritario, facilitando rastreio e dano coordenado a distancia.',
        class = 'hunter',
        minLevel = 1,
        staminaCost = 20,
        duration = 10,
        cooldown = 40,
    },
    field_triage = {
        label = 'Triagem de campo',
        description = 'Aplica uma janela curta de suporte medico para estabilizar aliados em situacoes criticas.',
        class = 'medic',
        minLevel = 1,
        staminaCost = 30,
        duration = 8,
        cooldown = 60,
    },
    grit = {
        label = 'Tenacidade',
        description = 'Ativa foco de sobrevivencia para resistir melhor a desgaste, fadiga e pressao ambiental.',
        class = 'survivor',
        minLevel = 1,
        staminaCost = 20,
        duration = 12,
        cooldown = 50,
    },
    field_rig = {
        label = 'Improviso tecnico',
        description = 'Prepara um ajuste tecnico rapido para melhorar utilidade de campo e suporte a equipamentos.',
        class = 'engineer',
        minLevel = 1,
        staminaCost = 25,
        duration = 10,
        cooldown = 55,
    },
}
