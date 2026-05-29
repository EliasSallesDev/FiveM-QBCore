window.QBPhoneLocale = (function () {
    const dictionary = {
        "Phone": "Telefone",
        "Whatsapp": "Whatsapp",
        "Settings": "Configurações",
        "Twitter": "Twitter",
        "Vehicles": "Veículos",
        "Mail": "E-mail",
        "Advertisements": "Anúncios",
        "New advertisement": "Novo anúncio",
        "Picture URL": "URL da imagem",
        "Bank": "Banco",
        "Crypto": "Cripto",
        "Racing": "Corridas",
        "Houses": "Casas",
        "Services": "Serviços",
        "Gallery": "Galeria",
        "Camera": "Câmera",
        "MDT": "MDT",
        "Territorium": "Território",
        "Territory": "Território",

        "Background": "Plano de fundo",
        "Default": "Padrão",
        "Avatar": "Avatar",
        "My phone number": "Meu número",
        "Serial Number": "Número de série",
        "Call Anonymously": "Ligar anonimamente",
        "Off": "Desligado",
        "On": "Ligado",
        "Default background": "Plano de fundo padrão",
        "Custom": "Personalizado",
        "Personalize your background": "Personalize seu plano de fundo",
        "Confirm": "Confirmar",
        "Cancel": "Cancelar",
        "Personalized Background": "Plano de fundo personalizado",
        "Default avatar": "Avatar padrão",
        "Personalize your avatar": "Personalize seu avatar",
        "Photo - Coming Soon": "Foto - em breve",
        "Set your profile picture with a photo": "Defina sua foto de perfil com uma foto",
        "Personalized Avatar": "Avatar personalizado",

        "Incoming Call": "Chamada recebida",
        "Calling...": "Chamando...",
        "Ongoing": "Em chamada",
        "Unknown Number": "Número desconhecido",
        "Outgoing call": "Chamada realizada",
        "Incoming call": "Chamada recebida",

        "Contacts": "Contatos",
        "Contact name": "Nome do contato",
        "Contactname": "Nome do contato",
        "Recent Call History": "Histórico de chamadas",
        "Suggested Contacts": "Contatos sugeridos",
        "Add Contact": "Adicionar contato",
        "Contact Name": "Nome do contato",
        "Phone number": "Número de telefone",
        "Bank nr. (Not required)": "Conta bancária (opcional)",
        "Save": "Salvar",
        "Delete": "Excluir",
        "Edit Contact": "Editar contato",

        "My Houses": "Minhas casas",
        "My Keys": "Minhas chaves",
        "TRANSFER": "TRANSFERIR",
        "KEYS": "CHAVES",
        "CLOSE": "FECHAR",
        "Transfer House": "Transferir casa",
        "CONFIRM": "CONFIRMAR",
        "RETURN": "VOLTAR",
        "Click to set GPS": "Clique para marcar no GPS",

        "My Garage": "Minha garagem",
        "Brand": "Marca",
        "Model": "Modelo",
        "License Plate": "Placa",
        "Garage": "Garagem",
        "Status": "Status",
        "Fuel": "Combustível",
        "Engine": "Motor",
        "Bodywork": "Lataria",
        "TRACK": "RASTREAR",

        "My Gallery": "Minha galeria",
        "POST": "POSTAR",
        "Message": "Mensagem",
        "Photo": "Foto",
        "Location": "Localização",
        "Shared location": "Localização compartilhada",
        "Shared Location": "Localização compartilhada",

        "Welcome": "Bem-vindo",
        "Current: 100 REP": "Atual: 100 REP",
        "Next: 200 REP": "Próximo: 200 REP",
        "Your current progression": "Sua progressão atual",
        "You are currently not working": "Você não está trabalhando no momento",
        "Available services": "Serviços disponíveis",

        "Wallet": "Carteira",
        "Value": "Valor",
        "Volume": "Volume",
        "General": "Geral",
        "Transactions": "Transações",
        "Buy Qbit": "Comprar Qbit",
        "Sell Qbit": "Vender Qbit",
        "Transfer Qbit": "Transferir Qbit",
        "BUY": "COMPRAR",
        "SELL": "VENDER",
        "You can buy crypto here.": "Você pode comprar cripto aqui.",
        "You can sell crypto here.": "Você pode vender cripto aqui.",
        "You can transfer crypto here.": "Você pode transferir cripto aqui.",
        "Wallet ID": "ID da carteira",

        "Person": "Pessoa",
        "Vehicle": "Veículo",
        "House": "Casa",
        "Alerts": "Alertas",
        "Most recent alert": "Alerta mais recente",
        "You don't have any alerts!": "Você não tem alertas!",
        "CLEAR": "LIMPAR",
        "Welcome Jay Nandes": "Bem-vindo Jay Nandes",

        "Available Races": "Corridas disponíveis",
        "Create Race": "Criar corrida",
        "Setup Race": "Configurar corrida",
        "Setup": "Configurar",
        "Racing - Setup": "Corridas",
        "Race Overview": "Visão geral da corrida",
        "Racing - Overview": "Corridas - Menu",
        "Racing - Leaderboards": "Corridas - Top 10",
        "Leaderboards": "Top 10",
        "Leaderboard": "Top 10",
        "Race Track": "Pista de corrida",
        "Select a Track": "Selecione uma pista",
        "Laps": "Voltas",
        "Number of laps (0 is Sprint)": "Número de voltas (0 é sprint)",
        "Race Information": "Informações da corrida",
        "Track Name": "Nome da pista",
        "Name of your track": "Nome da sua pista",
        "Last Tracks": "Últimas pistas",
        "Top 10": "Top 10",
        "Racer": "Corredor",
        "Piloto": "Piloto",
        "Race name": "Nome da corrida",
        "Amount of laps": "Quantidade de voltas",
        "Create": "Criar",
        "Join": "Entrar",
        "Start": "Iniciar",
        "Stop": "Parar",
        "Leave": "Sair",

        "QBank": "Banco",
        "Accounts": "Contas",
        "Invoices": "Faturas",
        "Account": "Conta",
        "Balance": "Saldo",
        "Transfer": "Transferir",
        "Amount": "Valor",
        "Invoice": "Fatura",
        "Sender": "Remetente",
        "Transfer Money": "Transferir dinheiro",
        "My Contacts": "Meus contatos",
        "Return": "Voltar",

        "Inbox": "Entrada",
        "New Mail": "Novo e-mail",
        "Subject": "Assunto",
        "From": "De",
        "To": "Para",
        "Send": "Enviar",
        "Read": "Ler",
        "Last synchronization 18:31": "Última sincronização 18:31",

        "App Store": "Loja de apps",
        "Security": "Segurança",
        "To download this application you must enter a password.": "Para baixar este aplicativo, informe uma senha.",

        "New Tweet!": "Novo tweet!",
        "This is a test notification": "Esta é uma notificação de teste",
        "New Tweet": "Novo tweet",
        "Twitter message": "Mensagem do Twitter",
        "Take Pic": "Tirar foto",
        "No tweets": "Nenhum tweet",
        "No mentions": "Nenhuma menção",
        "No hashtags": "Nenhuma hashtag",
        "Fill a message!": "Preencha uma mensagem!",
        "Trending in City": "Em alta na cidade",
        "Not trending in City": "Fora dos assuntos em alta",
        "Tweet": "Tweet",
        "Tweets": "Tweets",
        "Mentions": "Menções",
        "Hashtags": "Hashtags",

        "System": "Sistema",
        "is not available!": "não está disponível!",
        "You can't send a empty message!": "Você não pode enviar uma mensagem vazia!",
        "Hmm, I shouldn't be able to do this...": "Hmm, eu não deveria conseguir fazer isso...",
        "Today": "Hoje",
        "TODAY": "HOJE",
        "nothing": "nada",
        "Anonymous": "Anônimo",
        "In conversation": "Em conversa",
        "Calling with": "Ligando com",
        "with": "com",
        "You started a anonymous call!": "Você iniciou uma chamada anônima!",
        "You're already in a call!": "Você já está em uma chamada!",
        "This person is busy!": "Essa pessoa está ocupada!",
        "This person is not available!": "Essa pessoa não está disponível!",
        "You can't call yourself!": "Você não pode ligar para si mesmo!",
        "You can't whatsapp yourself..": "Você não pode mandar mensagem para si mesmo.",
        "Fill out all fields!": "Preencha todos os campos!",
        "No one nearby!": "Ninguém por perto!",
        "Camera not setup": "Câmera não configurada",
        "You don't have a phone": "Você não tem um celular",
        "Action not available at the moment..": "Ação indisponível no momento.",
        "Your vehicle has been marked": "Seu veículo foi marcado",
        "This vehicle cannot be located": "Este veículo não pode ser localizado",
        "GPS has been set!": "GPS marcado!",
        "No Vehicle Nearby": "Nenhum veículo por perto",
        "Account does not exist!": "A conta não existe!",
        "This account number doesn't exist!": "Esse número de conta não existe!",
        "You cannot ping yourself": "Você não pode marcar a si mesmo",
        "Invoice Successfully Sent": "Fatura enviada com sucesso",
        "New Invoice Received": "Nova fatura recebida",
        "Must Be A Valid Amount Above 0": "Informe um valor válido acima de 0",
        "You Cannot Bill Yourself": "Você não pode cobrar a si mesmo",
        "Player Not Online": "Jogador offline",
        "No Access": "Sem acesso",
        "The call has been ended": "A chamada foi encerrada",
        "You have an incoming call from Test": "Você tem uma chamada recebida de Test",
        "Last synchronized": "Última sincronização",
        "You don't have any mails..": "Você não tem nenhum e-mail.",
        "You don't have rights to make Race Tracks..": "Você não tem permissão para criar pistas de corrida.",
        "You don't have any rights to create Race Tracks..": "Você não tem permissão para criar pistas de corrida.",
        "Race Tracks": "pistas de corrida",
        "You have been mentioned in a Tweet!": "Você foi mencionado em um tweet!",
        "New message from": "Nova mensagem de",
        "Messaged yourself": "Você enviou mensagem para si mesmo",
        "Account number. copied!": "Número da conta copiado!",
        "You have transfered": "Você transferiu",
        "You don't have enough balance!": "Saldo insuficiente!",
        "You have paid": "Você pagou",
        "You declined the invoice": "Você recusou a fatura",
        "Couldnt decline this invoice...": "Não foi possível recusar esta fatura...",
        "There is no bank account attached to this number!": "Não há conta bancária vinculada a este número!",
        "Lawyers": "Advogados",
        "Real Estate": "Imobiliária",
        "Mechanic": "Mecânicos",
        "Police": "Polícia",
        "Ambulance": "Ambulância",
        "There are no lawyers available.": "Não há advogados disponíveis.",
        "There are no real estate agents available.": "Não há corretores disponíveis.",
        "There are no mechanics available.": "Não há mecânicos disponíveis.",
        "There are no taxis available.": "Não há taxistas disponíveis.",
        "There is no police available.": "Não há policiais disponíveis.",
        "There is no ems available.": "Não há ambulâncias disponíveis.",
        "There are no polices a available.": "Não há policiais disponíveis.",
        "There are no ambulance personnel a available.": "Não há ambulâncias disponíveis.",

        "January": "Janeiro",
        "February": "Fevereiro",
        "March": "Março",
        "April": "Abril",
        "May": "Maio",
        "June": "Junho",
        "JulY": "Julho",
        "July": "Julho",
        "August": "Agosto",
        "September": "Setembro",
        "October": "Outubro",
        "November": "Novembro",
        "December": "Dezembro",
    };

    function translateText(value) {
        if (value === null || value === undefined) return value;

        let text = String(value);
        const leading = text.match(/^\s*/)[0];
        const trailing = text.match(/\s*$/)[0];
        const trimmed = text.trim();
        if (trimmed === "") return value;

        if (dictionary[trimmed]) return leading + dictionary[trimmed] + trailing;

        let translated = trimmed
            .replace(/^(\d+)\scontacts$/i, "$1 contatos")
            .replace(/^0 contacten #SAD$/i, "0 contatos")
            .replace(/^Sender:\s*/i, "Remetente: ")
            .replace(/\(Sender:\s*([^)]+)\)/i, "(Remetente: $1)")
            .replace(/^Wallet:\s*/i, "Carteira: ")
            .replace(/Qbit\('s\)/g, "Qbit(s)")
            .replace(/\bDollars\b/g, "Dólares")
            .replace(/^In conversation \(([^)]+)\)$/i, "Em conversa ($1)")
            .replace(/^Calling with\s+/i, "Ligando com ")
            .replace(/^with\s+/i, "com ")
            .replace(/^New message from\s+/i, "Nova mensagem de ")
            .replace(/^GPS Location set:\s*/i, "Localização GPS marcada: ")
            .replace(/^GPS has been set to\s+(.+)!$/i, "GPS marcado para $1!")
            .replace(/^You're too far away from the race\. GPS has been set to the race\.$/i, "Você está longe demais da corrida. O GPS foi marcado para a corrida.")
            .replace(/^You have transfered &#36;\s*(.+)!$/i, "Você transferiu &#36; $1!")
            .replace(/^You have paid &#36;\s*(.+)!$/i, "Você pagou &#36; $1!")
            .replace(/^&#36;(.+) has been added to your account!$/i, "&#36;$1 foi adicionado à sua conta!")
            .replace(/^Invoice Has Been Paid From\s+(.+)\s+In The Amount Of \$([0-9.,]+)$/i, "A fatura foi paga por $1 no valor de $$2")
            .replace(/^Invoice Has Been Declined From\s+(.+)\s+In The Amount Of \$([0-9.,]+)$/i, "A fatura foi recusada por $1 no valor de $$2")
            .replace(/^You received a commission check of \$([0-9.,]+) when (.+) paid a bill of \$([0-9.,]+)\.$/i, "Você recebeu uma comissão de $$1 quando $2 pagou uma fatura de $$3.")
            .replace(/^(.+) paid a bill of \$([0-9.,]+)$/i, "$1 pagou uma fatura de $$2")
            .replace(/^New Tweet \(@(.+)\)$/i, "Novo tweet (@$1)");

        return leading + translated + trailing;
    }

    function translateElement(element) {
        if (!element || element.nodeType !== Node.ELEMENT_NODE) return;

        ["placeholder", "title", "aria-label"].forEach(function (attr) {
            if (element.hasAttribute(attr)) {
                const current = element.getAttribute(attr);
                const translated = translateText(current);
                if (translated !== current) element.setAttribute(attr, translated);
            }
        });

        element.childNodes.forEach(function (node) {
            if (node.nodeType === Node.TEXT_NODE) {
                const current = node.nodeValue;
                const translated = translateText(current);
                if (translated !== current) node.nodeValue = translated;
            } else if (node.nodeType === Node.ELEMENT_NODE) {
                translateElement(node);
            }
        });
    }

    function translatePage() {
        translateElement(document.body);
    }

    function start() {
        translatePage();

        const observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (mutation) {
                if (mutation.type === "childList") {
                    mutation.addedNodes.forEach(function (node) {
                        if (node.nodeType === Node.TEXT_NODE) {
                            const translated = translateText(node.nodeValue);
                            if (translated !== node.nodeValue) node.nodeValue = translated;
                        } else if (node.nodeType === Node.ELEMENT_NODE) {
                            translateElement(node);
                        }
                    });
                } else if (mutation.type === "attributes") {
                    translateElement(mutation.target);
                } else if (mutation.type === "characterData") {
                    const translated = translateText(mutation.target.nodeValue);
                    if (translated !== mutation.target.nodeValue) mutation.target.nodeValue = translated;
                }
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true,
            characterData: true,
            attributes: true,
            attributeFilter: ["placeholder", "title", "aria-label"],
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", start);
    } else {
        start();
    }

    return {
        t: translateText,
        translatePage: translatePage,
    };
})();
