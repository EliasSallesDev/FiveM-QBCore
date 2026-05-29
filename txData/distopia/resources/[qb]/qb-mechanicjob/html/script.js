const navbarOptions = {
    // https://forums.gta5-mods.com/topic/3842/tutorial-handling-meta
    potencia: [
        { id: "fMass", label: "Peso", description: "Peso do veículo em kg", min: 0, max: 10000 },
        { id: "fInitialDragCoeff", label: "Arrasto aerodinâmico", description: "Aumente para simular maior resistência do ar", min: 0, max: 100 },
        { id: "fDownforceModifier", label: "Pressão aerodinâmica", description: "Quantidade de pressão aplicada ao veículo", min: 0, max: 100 },
        { id: "nInitialDriveGears", label: "Marchas", description: "Quantidade de marchas do veículo", min: 1, max: 10 },
        { id: "fInitialDriveForce", label: "Força de tração", description: "Força enviada pela transmissão", min: 0, max: 100 },
        { id: "fDriveInertia", label: "Inércia do motor", description: "Velocidade com que o motor chega ao limite de giro", min: 0, max: 2 },
        { id: "fDriveBiasFront", label: "Distribuição da tração", description: "Traseira: 0.0 | Integral: 0.5 | Dianteira: 1.0", min: 0, max: 1 },
        { id: "fInitialDriveMaxFlatVel", label: "Velocidade máxima", description: "Velocidade no limite de giro na última marcha", min: 0, max: 1000 },
        { id: "fClutchChangeRateScaleUpShift", label: "Troca de marcha", description: "Valor maior = trocas mais rápidas", min: 0, max: 100 },
        { id: "fClutchChangeRateScaleDownShift", label: "Redução de marcha", description: "Valor maior = reduções mais rápidas", min: 0, max: 100 },
    ],
    freios: [
        { id: "fSteeringLock", label: "Ângulo de direção", description: "Ângulo máximo de esterço das rodas", min: 0, max: 1 },
        { id: "fBrakeForce", label: "Força dos freios", description: "Potência geral de frenagem", min: 0, max: 100 },
        { id: "fBrakeBiasFront", label: "Distribuição dos freios", description: "Traseira: 0.0 | Igual: 0.5 | Dianteira: 1.0", min: 0, max: 1 },
        { id: "fHandBrakeForce", label: "Força do freio de mão", description: "Define a força do freio de mão", min: 0, max: 100 },
    ],
    tracao: [
        { id: "fTractionCurveMax", label: "Tração máxima", description: "Aderência do veículo em curvas", min: 0, max: 100 },
        { id: "fTractionCurveMin", label: "Tração mínima", description: "Aderência ao acelerar e frear", min: 0, max: 100 },
        { id: "fTractionCurveLateral", label: "Tração lateral", description: "Formato da curva de tração lateral", min: 0, max: 100 },
        { id: "fTractionSpringDeltaMax", label: "Perda de tração", description: "Altura do solo em que o carro perde tração", min: 0, max: 100 },
        { id: "fLowSpeedTractionLossMult", label: "Perda em baixa velocidade", description: "Menor: menos burnout | Maior: mais burnout", min: 0, max: 100 },
        { id: "fTractionBiasFront", label: "Distribuição da tração", description: "Traseira: 0.1 | Igual: 0.5 | Dianteira: 0.99", min: 0, max: 1 },
        { id: "fCamberStiffnesss", label: "Rigidez do cambagem", description: "Aderência para drift", min: 0, max: 100 },
        { id: "fTractionLossMult", label: "Multiplicador de perda de tração", description: "Aderência no asfalto e na lama", min: 0, max: 100 },
    ],
    suspensao: [
        { id: "vecCentreOfMassOffset", label: "Centro de massa", description: "Move o centro de gravidade para direita, frente ou cima", min: 0, max: 100 },
        { id: "vecInertiaMultiplier", label: "Multiplicador de inércia", description: "Inércia de rotação", min: 0, max: 100 },
        { id: "fSuspensionForce", label: "Força da suspensão", description: "Rigidez da suspensão", min: 0, max: 100 },
        { id: "fSuspensionCompDamp", label: "Amortecimento de compressão", description: "Valores maiores deixam mais rígido", min: 0, max: 100 },
        { id: "fSuspensionReboundDamp", label: "Amortecimento de retorno", description: "Valores maiores deixam mais rígido", min: 0, max: 100 },
        { id: "fSuspensionUpperLimit", label: "Limite superior", description: "Limite visual de quanto as rodas podem subir", min: 0, max: 100 },
        { id: "fSuspensionLowerLimit", label: "Limite inferior", description: "Limite visual de quanto as rodas podem descer", min: 0, max: 100 },
        { id: "fSuspensionRaise", label: "Altura da suspensão", description: "Altura da carroceria em relação às rodas", min: 0, max: 100 },
        { id: "fSuspensionBiasFront", label: "Distribuição da suspensão", description: "Força da suspensão dianteira/traseira", min: 0, max: 1 },
        { id: "fAntiRollBarForce", label: "Barra estabilizadora", description: "Números maiores reduzem rolagem da carroceria", min: 0, max: 100 },
        { id: "fAntiRollBarBiasFront", label: "Distribuição da barra", description: "Dianteira: 0 | Traseira: 1", min: 0, max: 1 },
        { id: "fRollCentreHeightFront", label: "Centro de rolagem dianteiro", description: "Números maiores reduzem capotagens", min: -0.15, max: 0.15 },
        { id: "fRollCentreHeightRear", label: "Centro de rolagem traseiro", description: "Números maiores reduzem capotagens", min: -0.15, max: 0.15 },
    ],
    outros: [
        { id: "fPercentSubmerged", label: "Percentual submerso", description: "Percentual submerso antes do veículo afogar", min: 0, max: 100 },
        { id: "fCollisionDamageMult", label: "Dano de colisão", description: "Multiplica o dano de colisão", min: 0, max: 10 },
        { id: "fDeformationDamageMult", label: "Dano na lataria", description: "Multiplica o dano de deformação da carroceria", min: 0, max: 10 },
        { id: "fWeaponDamageMult", label: "Dano por arma", description: "Multiplica o dano causado por armas", min: 0, max: 10 },
        { id: "fEngineDamageMult", label: "Dano no motor", description: "Multiplica o dano recebido pelo motor", min: 0, max: 10 },
        { id: "fPetrolTankVolume", label: "Volume do tanque", description: "Quantidade de combustível que vaza após dano no tanque", min: 0, max: 100 },
        { id: "fOilVolume", label: "Volume de óleo", description: "Quantidade de óleo", min: 0, max: 100 },
        { id: "nMonetaryValue", label: "Valor monetário", description: "Define a reação dos NPCs ao veículo", min: 0, max: 1000000 },
    ],
};

let currentStats = {};

const generateNavbarItems = () => {
    const navbar = document.querySelector(".navbar");
    navbar.innerHTML = "";

    Object.keys(navbarOptions).forEach((option) => {
        const button = document.createElement("button");
        button.classList.add("nav-item");
        button.id = option;
        button.textContent = option.charAt(0).toUpperCase() + option.slice(1);
        navbar.appendChild(button);
    });
};

const displayFieldsForNavbarOption = (option) => {
    const contentArea = document.getElementById("content-area");
    contentArea.innerHTML = "";
    const selectedOptions = navbarOptions[option];

    selectedOptions.forEach((option) => {
        const inputContainer = document.createElement("div");
        inputContainer.classList.add("input-container");

        const inputLabel = document.createElement("label");
        inputLabel.classList.add("input-label");
        inputLabel.htmlFor = option.id;
        inputLabel.textContent = option.label || option.id;

        const numberInput = document.createElement("input");
        numberInput.type = "number";
        numberInput.id = option.id;
        numberInput.classList.add("number-input");
        numberInput.value = currentStats[option.id] !== undefined ? currentStats[option.id] : "";

        if (option.min !== undefined) {
            numberInput.min = option.min;
        }
        if (option.max !== undefined) {
            numberInput.max = option.max;
        }

        if (option.description) {
            inputLabel.addEventListener("mouseover", () => {
                document.getElementById("table-description").textContent = option.description;
            });

            inputLabel.addEventListener("mouseout", () => {
                document.getElementById("table-description").textContent = "";
            });
        }

        inputContainer.appendChild(inputLabel);
        inputContainer.appendChild(numberInput);
        contentArea.appendChild(inputContainer);
    });
};

const openTuner = (stats) => {
    currentStats = stats;
    document.querySelector(".tablet").style.display = "block";
    generateNavbarItems();
    displayFieldsForNavbarOption("potencia");
};

const saveSettings = () => {
    const contentArea = document.getElementById("content-area");
    let data = {};
    let isInputValid = true;

    const inputContainers = contentArea.querySelectorAll(".input-container");
    inputContainers.forEach((container) => {
        const inputElement = container.querySelector(".number-input");
        if (inputElement) {
            const value = parseFloat(inputElement.value);
            const min = parseFloat(inputElement.min);
            const max = parseFloat(inputElement.max);

            if (value < min || value > max) {
                console.log(inputElement.id + " out of range");
                isInputValid = false;
            } else {
                data[inputElement.id] = value;
            }
        }
    });

    if (isInputValid) {
        fetch("https://qb-mechanicjob/saveTune", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
        });
    }
};

const resetSettings = () => {
    fetch("https://qb-mechanicjob/reset", { method: "POST" });
    closeTuner();
};

const closeTuner = () => {
    document.querySelector(".tablet").style.display = "none";
    fetch("https://qb-mechanicjob/closeTuner", { method: "POST" });
};

document.addEventListener("click", function (event) {
    const targetId = event.target.id;
    const targetClass = event.target.className;

    if (targetClass === "nav-item") {
        displayFieldsForNavbarOption(targetId);
        return;
    }

    switch (targetId) {
        case "save-button":
            saveSettings();
            break;
        case "reset-button":
            resetSettings();
            break;
        case "cancel":
            closeTuner();
            break;
    }
});

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeTuner();
    }
});

window.addEventListener("message", function (event) {
    var eventData = event.data;
    if (eventData.action == "openTuner") {
        openTuner(eventData.stats);
    }
});
