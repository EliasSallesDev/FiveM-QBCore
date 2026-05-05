const app = document.getElementById("app");
const professionList = document.getElementById("profession-list");
const activityList = document.getElementById("activity-list");
const message = document.getElementById("message");

let state = {
  menuData: null,
  selectedProfessionId: null,
};

const post = async (name, data = {}) => {
  const resource = typeof GetParentResourceName === "function" ? GetParentResourceName() : "qbx-professions";
  const response = await fetch(`https://${resource}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(data),
  });

  return response.json();
};

const setMessage = (text = "", type = "") => {
  message.textContent = text;
  message.className = type;
};

const xpPct = (profession) => {
  const xp = Number(profession?.xp || 0);
  const next = Math.max(Number(profession?.xpToNext || 1), 1);
  return Math.max(0, Math.min(100, (xp / next) * 100));
};

const activeNames = () => (state.menuData?.active || []).map((item) => item.label).join(", ");

const professionById = (id) => (state.menuData?.professions || []).find((item) => item.id === id);

const renderHeader = () => {
  const data = state.menuData;
  if (!data) return;

  const activeCount = (data.active || []).length;
  document.getElementById("slot-count").textContent = `${activeCount} / ${data.unlockedSlots}`;
  document.getElementById("active-slots").textContent = data.unlockedSlots || 1;
  document.getElementById("active-title").textContent = activeNames() || "Nenhuma";

  const item = data.slotItem;
  const count = Number(item?.count || 0);
  document.getElementById("slot-help").textContent = item
    ? `Use ${item.amount || 1}x ${item.label || item.item} para liberar mais uma profissão ativa. Você possui ${count}.`
    : "Slots extras estao desativados nesta configuracao.";
};

const renderProfessionList = () => {
  const selectedId = state.selectedProfessionId;
  professionList.innerHTML = "";

  (state.menuData?.professions || []).forEach((profession) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "profession-option";
    if (profession.active) button.classList.add("is-active");
    if (profession.id === selectedId) button.classList.add("is-selected");

    button.innerHTML = `
      <span class="profession-mark">${profession.label.slice(0, 1)}</span>
      <span>
        <span class="profession-name">${profession.label}</span>
        <span class="profession-copy">${profession.description || ""}</span>
      </span>
      <span class="profession-level">N${profession.level || 1}</span>
    `;

    button.addEventListener("click", () => {
      state.selectedProfessionId = profession.id;
      render();
    });

    professionList.appendChild(button);
  });
};

const renderDetails = () => {
  const selected = professionById(state.selectedProfessionId) || state.menuData?.professions?.[0];
  if (!selected) return;

  state.selectedProfessionId = selected.id;

  document.getElementById("detail-name").textContent = selected.label;
  document.getElementById("detail-description").textContent = selected.description || "";
  document.getElementById("detail-level").textContent = selected.level || 1;
  document.getElementById("detail-xp").textContent = selected.xp || 0;
  document.getElementById("detail-next").textContent = selected.xpToNext || 0;
  document.getElementById("detail-active").textContent = selected.active ? "Ativa" : "Inativa";
  document.getElementById("detail-state").textContent = selected.active ? "Ativa" : "Disponivel";
  document.getElementById("selected-xp").textContent = `${selected.xp || 0} / ${selected.xpToNext || 0} XP`;
  document.getElementById("selected-state").textContent = selected.active ? "Ativa" : "Inativa";
  document.getElementById("selected-xp-fill").style.width = `${xpPct(selected)}%`;

  const activities = selected.activities?.length ? selected.activities : ["Coleta", "Craft", "Economia"];
  activityList.innerHTML = activities.map((item) => `<span class="activity-chip">${item}</span>`).join("");

  const activeCount = (state.menuData?.active || []).length;
  const unlockedSlots = Number(state.menuData?.unlockedSlots || 1);
  const maxSlots = Number(state.menuData?.maxSlots || unlockedSlots);
  const slotItem = state.menuData?.slotItem;
  const itemCount = Number(slotItem?.count || 0);
  const activateButton = document.getElementById("activate-profession");
  const hasFreeSlot = activeCount < unlockedSlots;
  const canUnlockMore = unlockedSlots < maxSlots;

  activateButton.disabled = selected.active || !hasFreeSlot;
  activateButton.textContent = selected.active
    ? "Ja ativa"
    : !hasFreeSlot
      ? canUnlockMore && slotItem
        ? `Use ${slotItem.label || slotItem.item} (${itemCount})`
        : "Limite maximo"
      : "Ativar profissão";

  if (!selected.active && !hasFreeSlot) {
    document.getElementById("selected-state").textContent = canUnlockMore
      ? `Precisa de slot | ${itemCount} licenca(s)`
      : "Limite maximo";
  }
};

const render = () => {
  if (!state.menuData) return;
  state.selectedProfessionId ||= state.menuData.professions?.find((item) => item.active)?.id || state.menuData.professions?.[0]?.id || null;
  renderHeader();
  renderProfessionList();
  renderDetails();
};

const hydrate = (payload) => {
  state.menuData = payload?.menuData || null;
  if (!professionById(state.selectedProfessionId)) {
    state.selectedProfessionId = state.menuData?.professions?.find((item) => item.active)?.id || state.menuData?.professions?.[0]?.id || null;
  }
  render();
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

document.getElementById("activate-profession").addEventListener("click", async () => {
  if (!state.selectedProfessionId) return;
  const result = await post("activateProfession", { professionId: state.selectedProfessionId });
  handleServerResult(result);
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

  if (action === "close") {
    app.classList.remove("is-open");
    app.setAttribute("aria-hidden", "true");
  }
});

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    post("close");
  }
});
