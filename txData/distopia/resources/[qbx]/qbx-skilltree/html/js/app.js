const app = document.getElementById("app");
const treeList = document.getElementById("tree-list");
const graph = document.getElementById("graph");
const message = document.getElementById("message");
const respecModal = document.getElementById("respec-modal");

let state = {
  menuData: null,
  selectedTreeId: null,
  selectedNodeId: null,
  panX: 0,
  panY: 0,
  pointerDown: false,
  dragging: false,
  dragStartX: 0,
  dragStartY: 0,
  dragOriginX: 0,
  dragOriginY: 0,
};

const post = async (name, data = {}) => {
  const resource = typeof GetParentResourceName === "function" ? GetParentResourceName() : "qbx-skilltree";
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

const setRespecModal = (open) => {
  respecModal.classList.toggle("is-hidden", !open);
};

const selectedTree = () => (state.menuData?.trees || []).find((tree) => tree.id === state.selectedTreeId);

const selectedNode = () => {
  const tree = selectedTree();
  return tree?.nodes?.[state.selectedNodeId] ? { ...tree.nodes[state.selectedNodeId], id: state.selectedNodeId } : null;
};

const nodeEntries = (tree) => Object.entries(tree?.nodes || {}).map(([id, node]) => ({ ...node, id }));

const allocatedRank = (tree, nodeId) => Number(tree?.allocated?.[nodeId] || 0);

const maxRank = (node) => Math.max(Number(node?.maxRank || 1), 1);

const effectLabels = {
  accuracy: "Precisao",
  crafting: "Craft",
  damage: "Dano",
  healing: "Cura",
  mitigation: "Mitigacao",
  staminaDrain: "Gasto de folego",
  tracking: "Rastreio",
};

const nextCost = (node, rank) => {
  const costs = node?.costPerRank || [];
  return Number(costs[rank] || node?.cost || 1);
};

const requirementMet = (tree, requirement) => {
  const [nodeId, rankText] = String(requirement).split(":rank");
  const rank = Number(rankText || 1);
  return allocatedRank(tree, nodeId) >= rank;
};

const formatRequirement = (tree, requirement) => {
  const [nodeId, rankText] = String(requirement).split(":rank");
  const rank = Number(rankText || 1);
  const node = tree?.nodes?.[nodeId];
  const label = node?.label || nodeId;
  return `${label} rank ${rank}`;
};

const formatEffect = ([key, value]) => {
  const label = effectLabels[key] || key;
  const numeric = Number(value || 0);
  const percent = Math.round(Math.abs(numeric) * 1000) / 10;
  const sign = numeric > 0 ? "+" : "-";
  if (key === "staminaDrain" && numeric < 0) {
    return `${label} reduz ${percent}%`;
  }

  return `${label} ${sign}${percent}%`;
};

const canUseTree = (tree) => !tree?.class || tree.class === state.menuData?.activeClass;

const canAllocate = (tree, node) => {
  if (!tree || !node || !canUseTree(tree)) return false;
  const rank = allocatedRank(tree, node.id);
  if (rank >= maxRank(node)) return false;
  if ((state.menuData?.skillPoints || 0) < nextCost(node, rank)) return false;
  return (node.requires || []).every((requirement) => requirementMet(tree, requirement));
};

const graphCanvas = () => graph.querySelector(".graph-canvas");

const clampPan = () => {
  const canvas = graphCanvas();
  if (!canvas) return;

  const minX = Math.min(0, graph.clientWidth - canvas.offsetWidth);
  const minY = Math.min(0, graph.clientHeight - canvas.offsetHeight);
  state.panX = Math.max(minX, Math.min(0, state.panX));
  state.panY = Math.max(minY, Math.min(0, state.panY));
};

const applyPan = () => {
  clampPan();
  const canvas = graphCanvas();
  if (!canvas) return;
  canvas.style.transform = `translate3d(${state.panX}px, ${state.panY}px, 0)`;
};

const resetPan = () => {
  state.panX = 0;
  state.panY = 0;
  applyPan();
};

const renderHeader = () => {
  const data = state.menuData;
  const tree = selectedTree();
  if (!data || !tree) return;

  const nodes = nodeEntries(tree);
  const unlocked = nodes.filter((node) => allocatedRank(tree, node.id) > 0).length;

  document.getElementById("point-count").textContent = data.skillPoints || 0;
  document.getElementById("tree-title").textContent = tree.label || tree.id;
  document.getElementById("tree-description").textContent = tree.description || "";
  document.getElementById("node-count").textContent = `${unlocked}/${nodes.length}`;
  document.getElementById("active-class").textContent = `Classe ativa: ${data.activeClass || "nenhuma"}`;
  document.getElementById("respec-tax").textContent = `Taxa ${Math.round(Number(data.respecTax || 0) * 100)}%`;
  document.getElementById("unlock-fill").style.width = `${nodes.length ? (unlocked / nodes.length) * 100 : 0}%`;
  document.getElementById("detail-name").textContent = tree.label || tree.id;
  document.getElementById("detail-state").textContent = canUseTree(tree) ? "Disponivel" : "Bloqueada";
};

const renderTreeList = () => {
  treeList.innerHTML = "";

  (state.menuData?.trees || []).forEach((tree) => {
    const nodes = nodeEntries(tree);
    const unlocked = nodes.filter((node) => allocatedRank(tree, node.id) > 0).length;
    const button = document.createElement("button");
    button.type = "button";
    button.className = "tree-option";
    if (tree.id === state.selectedTreeId) button.classList.add("is-selected");
    if (!canUseTree(tree)) button.classList.add("is-locked");

    button.innerHTML = `
      <span class="tree-mark">${(tree.label || tree.id).slice(0, 1)}</span>
      <span>
        <span class="tree-name">${tree.label || tree.id}</span>
        <span class="tree-copy">${tree.category || "Arvore"}</span>
      </span>
      <span class="tree-count">${unlocked}/${nodes.length}</span>
    `;

    button.addEventListener("click", () => {
      state.selectedTreeId = tree.id;
      state.selectedNodeId = nodeEntries(tree)[0]?.id || null;
      render();
    });

    treeList.appendChild(button);
  });
};

const drawEdge = (from, to) => {
  const canvas = graphCanvas();
  const edge = document.createElement("span");
  edge.className = "edge";

  const width = canvas.offsetWidth || 1320;
  const height = canvas.offsetHeight || 620;
  const x1 = (Number(from.x || 0) / 100) * width;
  const y1 = (Number(from.y || 0) / 100) * height;
  const x2 = (Number(to.x || 0) / 100) * width;
  const y2 = (Number(to.y || 0) / 100) * height;
  const dx = x2 - x1;
  const dy = y2 - y1;
  const length = Math.sqrt(dx * dx + dy * dy);
  const angle = Math.atan2(dy, dx) * (180 / Math.PI);

  edge.style.left = `${x1}px`;
  edge.style.top = `${y1}px`;
  edge.style.width = `${length}px`;
  edge.style.transform = `rotate(${angle}deg)`;
  canvas.appendChild(edge);
};

const renderGraph = () => {
  const tree = selectedTree();
  const nodes = nodeEntries(tree);
  graph.innerHTML = '<div class="graph-canvas"></div>';

  nodes.forEach((node) => {
    (node.requires || []).forEach((requirement) => {
      const [requiredId] = String(requirement).split(":rank");
      const from = tree.nodes?.[requiredId];
      if (from) drawEdge(from, node);
    });
  });

  nodes.forEach((node) => {
    const rank = allocatedRank(tree, node.id);
    const button = document.createElement("button");
    button.type = "button";
    button.className = "skill-node";
    if (node.id === state.selectedNodeId) button.classList.add("is-selected");
    if (rank > 0) button.classList.add("is-unlocked");
    if (!canAllocate(tree, node) && rank === 0) button.classList.add("is-locked");

    button.style.left = `${Number(node.x || 50)}%`;
    button.style.top = `${Number(node.y || 50)}%`;
    button.innerHTML = `
      <strong>${node.label || node.id}</strong>
      <span>${rank}/${maxRank(node)} | ${node.type || "passive"}</span>
    `;
    button.addEventListener("click", () => {
      if (state.dragging) return;
      state.selectedNodeId = node.id;
      render();
    });

    graphCanvas().appendChild(button);
  });

  applyPan();
};

const renderNodePanel = () => {
  const tree = selectedTree();
  const node = selectedNode() || nodeEntries(tree)[0];
  if (!tree || !node) return;

  state.selectedNodeId = node.id;

  const rank = allocatedRank(tree, node.id);
  const cost = nextCost(node, rank);
  const reqs = (node.requires || []).length
    ? node.requires.map((requirement) => formatRequirement(tree, requirement)).join(", ")
    : "Nenhum";
  const effects = node.effects
    ? Object.entries(node.effects).map(formatEffect).join(", ")
    : node.ability
      ? `Habilidade: ${node.ability}`
      : "Passiva";

  document.getElementById("node-title").textContent = node.label || node.id;
  document.getElementById("node-copy").textContent = node.description || "";
  document.getElementById("node-meta").innerHTML = `
    <span>Rank <strong>${rank}/${maxRank(node)}</strong></span>
    <span>Custo <strong>${rank >= maxRank(node) ? "-" : cost}</strong></span>
    <span>Requer <strong>${reqs}</strong></span>
    <span>Efeito <strong>${effects}</strong></span>
  `;

  const allocateButton = document.getElementById("allocate-node");
  allocateButton.disabled = !canAllocate(tree, node);
  allocateButton.textContent = rank >= maxRank(node) ? "Rank maximo" : `Alocar ${cost} ponto(s)`;
};

const render = () => {
  if (!state.menuData) return;
  state.selectedTreeId ||= state.menuData.trees?.[0]?.id || null;
  const tree = selectedTree();
  state.selectedNodeId ||= nodeEntries(tree)[0]?.id || null;

  renderHeader();
  renderTreeList();
  renderGraph();
  renderNodePanel();
};

const hydrate = (payload) => {
  state.menuData = payload?.menuData || null;
  if (!selectedTree()) {
    state.selectedTreeId = state.menuData?.trees?.[0]?.id || null;
  }
  if (!selectedNode()) {
    state.selectedNodeId = nodeEntries(selectedTree())[0]?.id || null;
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

document.getElementById("allocate-node").addEventListener("click", async () => {
  if (!state.selectedTreeId || !state.selectedNodeId) return;
  const result = await post("allocateNode", {
    treeId: state.selectedTreeId,
    nodeId: state.selectedNodeId,
  });
  handleServerResult(result);
});

document.getElementById("respec").addEventListener("click", async () => {
  const allocated = (state.menuData?.trees || []).reduce((total, tree) => {
    return total + Object.keys(tree.allocated || {}).length;
  }, 0);

  if (allocated < 1) {
    setMessage("Voce nao possui nos alocados.", "is-error");
    return;
  }

  const tax = Math.round(Number(state.menuData?.respecTax || 0) * 100);
  document.getElementById("respec-copy").textContent = `Todos os nos alocados serao removidos. Os pontos gastos voltam com taxa de ${tax}%.`;
  setRespecModal(true);
});

document.getElementById("cancel-respec").addEventListener("click", () => {
  setRespecModal(false);
});

document.getElementById("confirm-respec").addEventListener("click", async () => {
  setRespecModal(false);
  const result = await post("respec");
  handleServerResult(result);
});

graph.addEventListener("mousedown", (event) => {
  if (event.button !== 0) return;

  state.pointerDown = true;
  state.dragging = false;
  state.dragStartX = event.clientX;
  state.dragStartY = event.clientY;
  state.dragOriginX = state.panX;
  state.dragOriginY = state.panY;
});

window.addEventListener("mousemove", (event) => {
  if (!state.pointerDown) return;
  if (event.buttons !== 1) return;

  const dx = event.clientX - state.dragStartX;
  const dy = event.clientY - state.dragStartY;

  if (Math.abs(dx) < 4 && Math.abs(dy) < 4) return;

  state.dragging = true;
  graph.classList.add("is-dragging");
  state.panX = state.dragOriginX + dx;
  state.panY = state.dragOriginY + dy;
  applyPan();
});

window.addEventListener("mouseup", () => {
  state.pointerDown = false;
  graph.classList.remove("is-dragging");
  window.setTimeout(() => {
    state.dragging = false;
  }, 0);
});

window.addEventListener("message", (event) => {
  const { action, payload } = event.data || {};

  if (action === "open") {
    app.classList.add("is-open");
    app.setAttribute("aria-hidden", "false");
    setMessage("");
    resetPan();
    hydrate(payload);
  }

  if (action === "hydrate") {
    hydrate(payload);
  }

  if (action === "close") {
    app.classList.remove("is-open");
    app.setAttribute("aria-hidden", "true");
    setRespecModal(false);
  }
});

window.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    if (!respecModal.classList.contains("is-hidden")) {
      setRespecModal(false);
      return;
    }

    post("close");
  }
});
