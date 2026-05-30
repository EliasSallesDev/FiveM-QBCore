Config = Config or {}

Config.Toggle = true
Config.OpenKey = 'F9'
Config.ShowIDforALL = false
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48)

Config.IllegalActions = {
    ['storerobbery'] = {
        minimumPolice = 1,
        busy = false,
        label = 'Roubo a loja',
    },
    ['bankrobbery'] = {
        minimumPolice = 3,
        busy = false,
        label = 'Roubo a banco'
    },
    ['jewellery'] = {
        minimumPolice = 2,
        busy = false,
        label = 'Joalheria'
    },
    ['pacific'] = {
        minimumPolice = 5,
        busy = false,
        label = 'Banco Pacific'
    },
    ['paleto'] = {
        minimumPolice = 4,
        busy = false,
        label = 'Banco Paleto Bay'
    }
}
