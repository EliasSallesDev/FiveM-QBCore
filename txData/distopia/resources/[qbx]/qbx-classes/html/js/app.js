const app = document.getElementById("app");
const classList = document.getElementById("class-list");
const statsGrid = document.getElementById("stats-grid");
const abilityList = document.getElementById("ability-list");
const message = document.getElementById("message");
const classesPanel = document.getElementById("classes-panel");
const abilitiesPanel = document.getElementById("abilities-panel");
const tabs = [...document.querySelectorAll(".tab")];
const abilityWidget = document.getElementById("ability-widget");
const abilityHotkey = document.getElementById("ability-hotkey");
const abilityWidgetLabel = document.getElementById("ability-widget-label");
const abilityWidgetState = document.getElementById("ability-widget-state");
const abilityWidgetFill = document.getElementById("ability-widget-fill");
const abilityWidgetTime = document.getElementById("ability-widget-time");

let state = {
  menuData: null,
  abilities: {},
  selectedClassId: null,
  abilityStatus: null,
  abilityStatusSyncedAt: 0,
};

const post = async (name, data = {}) => {
  const resource = typeof GetParentResourceName === "function" ? GetParentResourceName() : "qbx-classes";
  const response = await fetch(`https://${resource}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(data),
  });

  return response.json();
};

const fmt = (value) => `${Number(value || 1).toFixed(2)}x`;

const setMessage = (text = "", type = "") => {
  message.textContent = text;
  message.className = type;
};

const xpPct = (classData) => {
  const xp = Number(classData?.xp || 0);
  const next = Math.max(Number(classData?.xpToNext || 1), 1);
  return Math.max(0, Math.min(100, (xp / next) * 100));
};

const getAbilityForClass = (classId) => {
  const entry = Object.entries(state.abilities || {}).find(([, ability]) => ability.class === classId);

  if (!entry) return null;

  return { id: entry[0], ...entry[1] };
};

const remainingFromStatus = (status, field) => {
  if (!status) return 0;
  const initial = Number(status[field] || 0);
  const elapsed = (Date.now() / 1000) - state.abilityStatusSyncedAt;
  return Math.max(0, initial - elapsed);
};

const costText = () => {
  const data = state.menuData;

  if (!data) return "";
  if (data.freeInitialClassChoice) return "Primeira escolha gratuita";
  if (!data.classChangeCost) return "Classe fixa apos a escolha inicial";

  const cooldown = data.classChangeCooldown > 0 ? ` | ${data.classChangeCooldown}s` : "";

  return `${data.classChangeCost.amount || 1}x ${data.classChangeCost.label || data.classChangeCost.item}${cooldown}`;
};

const classById = (id) => (state.menuData?.classes || []).find((item) => item.id === id);

const renderActive = () => {
  const active = state.menuData?.active;

  if (!active) {
    document.getElementById("active-name").textContent = "Escolha sua classe";
    document.getElementById("active-role").textContent = "A primeira escolha e gratuita.";
    document.getElementById("active-level").textContent = "-";
    document.getElementById("xp-label").textContent = "0 / 0 XP";
    document.getElementById("cost-label").textContent = costText();
    document.getElementById("xp-fill").style.width = "0%";
    document.getElementById("ability-class-name").textContent = "Sem classe";
    state.abilityStatus = null;
    return;
  }

  document.getElementById("active-name").textContent = active.label;
  document.getElementById("active-role").textContent = active.role;
  document.getElementById("active-level").textContent = active.level || 1;
  document.getElementById("xp-label").textContent = `${active.xp || 0} / ${active.xpToNext || 0} XP`;
  document.getElementById("cost-label").textContent = costText();
  document.getElementById("xp-fill").style.width = `${xpPct(active)}%`;
  document.getElementById("ability-class-name").textContent = active.label;
  state.abilityStatus = active.abilityStatus || state.abilityStatus;
  state.abilityStatusSyncedAt = Date.now() / 1000;
};

const renderClassList = () => {
  const activeId = state.menuData?.active?.id;
  classList.innerHTML = "";

  (state.menuData?.classes || []).forEach((classData) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "class-option";
    if (classData.id === activeId) button.classList.add("is-active");
    if (classData.id === state.selectedClassId) button.classList.add("is-selected");

    button.innerHTML = `
      <span class="class-mark">${classData.label.slice(0, 1)}</span>
      <span>
        <span class="class-name">${classData.label}</span>
        <span class="class-role">${classData.role}</span>
      </span>
      <span class="class-level">N${classData.level || 1}</span>
    `;

    button.addEventListener("click", () => {
      state.selectedClassId = classData.id;
      render();
    });

    classList.appendChild(button);
  });
};

const renderDetails = () => {
  const selected = classById(state.selectedClassId) || state.menuData?.active || state.menuData?.classes?.[0];
  if (!selected) return;

  state.selectedClassId = selected.id;

  const activeId = state.menuData?.active?.id;
  const isActive = selected.id === activeId;
  const canConfirmActive = isActive && state.menuData?.freeInitialClassChoice;
  const ability = getAbilityForClass(selected.id);

  document.getElementById("detail-name").textContent = selected.label;
  document.getElementById("detail-role").textContent = selected.role;
  document.getElementById("detail-state").textContent = isActive ? "Atual" : "Disponivel";
  if (!isActive && !state.menuData?.freeInitialClassChoice) {
    document.getElementById("detail-state").textContent = "Requer item";
  }
  document.getElementById("detail-ability").textContent = ability ? ability.label : "Sem habilidade";
  document.getElementById("detail-ability-meta").textContent = ability
    ? `${ability.description || "Sem descricao."} Nivel ${ability.minLevel || 1} | Cooldown ${ability.cooldown || 0}s | Stamina ${ability.staminaCost || 0}`
    : "-";

  const mods = selected.modifiers || {};
  const stats = [
    ["Dano", fmt(mods.damage)],
    ["Defesa", fmt(mods.mitigation)],
    ["Cura", fmt(mods.healing)],
    ["Vigor", fmt(mods.staminaDrain)],
    ["Precisao", fmt(mods.accuracy)],
    ["Rastreio", fmt(mods.tracking)],
    ["Craft", fmt(mods.crafting)],
    ["XP", `${selected.xp || 0}/${selected.xpToNext || 0}`],
  ];

  statsGrid.innerHTML = stats.map(([label, value]) => `<article class="stat"><span>${label}</span><strong>${value}</strong></article>`).join("");

  const selectButton = document.getElementById("select-class");
  selectButton.disabled = isActive && !canConfirmActive;
  selectButton.textContent = canConfirmActive
    ? "Confirmar escolha"
    : isActive
      ? "Classe definida"
      : state.menuData?.freeInitialClassChoice
        ? "Escolher classe"
        : "Trocar com item";
};

const renderAbilities = () => {
  const active = state.menuData?.active;

  if (!active) {
    document.getElementById("ability-count").textContent = "0";
    abilityList.innerHTML = "";
    return;
  }

  const abilities = Object.entries(state.abilities || {})
    .filter(([, ability]) => ability.class === active.id)
    .map(([id, ability]) => ({ id, ...ability }));

  document.getElementById("ability-count").textContent = `${abilities.length}`;
  abilityList.innerHTML = "";

  abilities.forEach((ability) => {
    const disabled = Number(active.level || 1) < Number(ability.minLevel || 1);
    const card = document.createElement("article");
    card.className = "ability-card";
    card.innerHTML = `
      <div>
        <h3>${ability.label}</h3>
        <p>${ability.description || "Sem descricao."}</p>
        <p>Nivel ${ability.minLevel || 1} | Cooldown ${ability.cooldown || 0}s | Stamina ${ability.staminaCost || 0}</p>
      </div>
      <button class="primary-button" type="button" ${disabled ? "disabled" : ""}>Usar</button>
    `;

    card.querySelector("button").addEventListener("click", async () => {
      const result = await post("useAbility", { abilityId: ability.id });
      handleServerResult(result);
    });

    abilityList.appendChild(card);
  });
};

const render = () => {
  if (!state.menuData) return;
  state.selectedClassId ||= state.menuData.active?.id || state.menuData.classes?.[0]?.id || null;
  renderActive();
  renderClassList();
  renderDetails();
  renderAbilities();
};

const hydrate = (payload) => {
  state.menuData = payload?.menuData || null;
  state.abilities = payload?.abilities || {};
  if (!classById(state.selectedClassId)) {
    state.selectedClassId = state.menuData?.active?.id || state.menuData?.classes?.[0]?.id || null;
  }
  state.abilityStatus = state.menuData?.active?.abilityStatus || state.abilityStatus;
  state.abilityStatusSyncedAt = Date.now() / 1000;
  render();
  renderAbilityWidget();
};

const hydrateAbilityStatus = (payload) => {
  state.abilityStatus = payload?.abilityStatus || payload?.active?.abilityStatus || null;
  state.abilityStatusSyncedAt = Date.now() / 1000;
  abilityHotkey.textContent = payload?.hotkey || "H";
  renderAbilityWidget();
};

const renderAbilityWidget = () => {
  const status = state.abilityStatus;

  if (!status) {
    abilityWidget.classList.add("is-hidden");
    return;
  }

  abilityWidget.classList.remove("is-hidden");
  abilityWidgetLabel.textContent = status.label || "Habilidade";

  const activeRemaining = remainingFromStatus(status, "activeRemaining");
  const cooldownRemaining = remainingFromStatus(status, "cooldownRemaining");
  let percent = 100;

  if (activeRemaining > 0) {
    percent = Math.max(0, Math.min(100, (activeRemaining / Math.max(Number(status.duration || 1), 1)) * 100));
    abilityWidgetState.textContent = "Ativa";
    abilityWidgetTime.textContent = `${Math.ceil(activeRemaining)}s`;
  } else if (cooldownRemaining > 0) {
    percent = 100 - Math.max(0, Math.min(100, (cooldownRemaining / Math.max(Number(status.cooldown || 1), 1)) * 100));
    abilityWidgetState.textContent = "Recarregando";
    abilityWidgetTime.textContent = `${Math.ceil(cooldownRemaining)}s`;
  } else {
    abilityWidgetState.textContent = "Pronta";
    abilityWidgetTime.textContent = "OK";
  }

  abilityWidgetFill.style.width = `${percent}%`;
};

const handleServerResult = (result) => {
  if (!result?.ok) {
    setMessage(result?.error || "Acao rejeitada.", "is-error");
    return;
  }

  hydrate(result);
  setMessage("Atualizado.", "is-success");
};

document.getElementById("close").addEventListener("click", () => post("close"));
document.getElementById("refresh").addEventListener("click", async () => {
  const result = await post("refresh");
  handleServerResult(result);
});

document.getElementById("select-class").addEventListener("click", async () => {
  if (!state.selectedClassId) return;
  const result = await post("selectClass", { classId: state.selectedClassId });
  handleServerResult(result);
});

tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    const target = tab.dataset.tab;
    tabs.forEach((item) => item.classList.toggle("is-active", item === tab));
    classesPanel.classList.toggle("is-hidden", target !== "classes");
    abilitiesPanel.classList.toggle("is-hidden", target !== "abilities");
  });
});

window.addEventListener("message", (event) => {
  const { action, payload } = event.data || {};

  if (action === "open") {
    app.classList.add("is-open");
    app.setAttribute("aria-hidden", "false");
    setMessage("");
    hydrate(payload);
  }

  if (action === "hydrate") {
    hydrate(payload);
  }

  if (action === "abilityStatus") {
    hydrateAbilityStatus(payload);
  }

  if (action === "close") {
    app.classList.remove("is-open");
    app.setAttribute("aria-hidden", "true");
  }
});

setInterval(renderAbilityWidget, 500);

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    post("close");
  }
});
