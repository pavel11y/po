const statuses = ["todo","inprogress","review","done"];
const statusNames = { todo:"Нужно сделать", inprogress:"В процессе", review:"Проверка", done:"Готово" };
const borderColors = { todo:"#f39c12", inprogress:"#3498db", review:"#9b59b6", done:"#2ecc71" };

let tasks = JSON.parse(localStorage.getItem("kanban_tasks") || "[]");
let currentFilter = "all";
let sortByDate = false;
let draggedId = null;

const $ = s => document.querySelector(s);
const $$ = s => document.querySelectorAll(s);
const titleInp = $("#taskTitle");
const descInp = $("#taskDesc");
const statusSelect = $("#taskStatus");
const addBtn = $("#addBtn");
const counterSpan = $("#counter");
const notifySpan = $("#notify");
const sortBtn = $("#sortBtn");

function notify(msg, isErr = false) {
    notifySpan.textContent = msg;
    notifySpan.style.background = isErr ? "rgba(220,53,69,0.2)" : "rgba(201,170,75,0.2)";
    notifySpan.style.color = isErr ? "#f8d7da" : "#f0cf8c";
    setTimeout(() => {
        if (notifySpan.textContent === msg) {
            notifySpan.style.background = "rgba(201,170,75,0.12)";
            notifySpan.style.color = "#f0cf8c";
            notifySpan.textContent = "✅ Готово";
        }
    }, 2000);
}

function save() {
    localStorage.setItem("kanban_tasks", JSON.stringify(tasks));
}

function getFiltered() {
    let filtered = currentFilter === "all" ? [...tasks] : tasks.filter(t => t.status === currentFilter);
    return filtered.sort((a, b) => sortByDate ? b.createdAt - a.createdAt : a.createdAt - b.createdAt);
}

function escapeHtml(str) {
    if (!str) return "";
    return str.replace(/[&<>]/g, m => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;' }[m]));
}

function createCard(task) {
    const card = document.createElement("div");
    card.className = "task";
    card.setAttribute("data-id", task.id);
    card.setAttribute("draggable", "true");
    card.style.borderLeftColor = borderColors[task.status];
    card.innerHTML = `
        <div class="task-title">${escapeHtml(task.title)}</div>
        <div class="task-desc">${task.description ? escapeHtml(task.description) : "—"}</div>
        <div class="task-date">📅 ${new Date(task.createdAt).toLocaleDateString()}</div>
        <div class="task-actions">
            <button class="edit-btn">✏️</button>
            <button class="delete-btn">🗑️</button>
        </div>
    `;
    card.addEventListener("dragstart", e => {
        draggedId = task.id;
        e.dataTransfer.setData("text/plain", draggedId);
        card.classList.add("dragging");
    });
    card.addEventListener("dragend", () => {
        card.classList.remove("dragging");
        $$(".column").forEach(c => c.classList.remove("drag-over"));
        draggedId = null;
    });
    card.querySelector(".edit-btn").onclick = () => editTask(task.id);
    card.querySelector(".delete-btn").onclick = () => deleteTask(task.id);
    return card;
}

function render() {
    statuses.forEach(st => $(`#${st}List`).innerHTML = "");
    const filtered = getFiltered();
    const grouped = { todo:[], inprogress:[], review:[], done:[] };
    filtered.forEach(t => grouped[t.status].push(t));
    for (let st of statuses) {
        const container = $(`#${st}List`);
        if (grouped[st].length === 0) {
            container.innerHTML = '<div class="empty-msg">— нет задач —</div>';
        } else {
            grouped[st].forEach(task => container.appendChild(createCard(task)));
        }
        $(`#${st}Count`).innerText = tasks.filter(t => t.status === st).length;
    }
    counterSpan.innerText = `${tasks.length} задач`;
}

function addTask() {
    const title = titleInp.value.trim();
    if (!title) return notify("Введите название!", true);
    tasks.push({
        id: Date.now(),
        title: title,
        description: descInp.value.trim(),
        status: statusSelect.value,
        createdAt: Date.now()
    });
    save();
    render();
    titleInp.value = "";
    descInp.value = "";
    notify(`➕ Добавлено: ${title}`);
}

function deleteTask(id) {
    const task = tasks.find(t => t.id === id);
    if (task) {
        tasks = tasks.filter(t => t.id !== id);
        save();
        render();
        notify(`🗑️ Удалено: ${task.title}`);
    }
}

function editTask(id) {
    const task = tasks.find(t => t.id === id);
    if (!task) return;
    let newTitle = prompt("Изменить название:", task.title);
    if (newTitle !== null && newTitle.trim()) task.title = newTitle.trim();
    else if (newTitle === "") return notify("Название не может быть пустым", true);
    let newDesc = prompt("Описание:", task.description || "");
    if (newDesc !== null) task.description = newDesc.trim();
    save();
    render();
    notify(`✏️ Задача обновлена`);
}

function setFilter(filter) {
    currentFilter = filter;
    $$(".filter-btn").forEach(btn => {
        btn.classList.toggle("active", btn.getAttribute("data-filter") === filter);
    });
    render();
    notify(`Фильтр: ${filter === "all" ? "все задачи" : statusNames[filter]}`);
}

function toggleSort() {
    sortByDate = !sortByDate;
    sortBtn.textContent = sortByDate ? "📅 Новые" : "📅 По порядку";
    render();
    notify(sortByDate ? "Сортировка: новые сверху" : "Сортировка: по дате");
}

function initDropZones() {
    $$(".column").forEach(col => {
        col.addEventListener("dragover", e => {
            e.preventDefault();
            col.classList.add("drag-over");
        });
        col.addEventListener("dragleave", () => col.classList.remove("drag-over"));
        col.addEventListener("drop", e => {
            e.preventDefault();
            col.classList.remove("drag-over");
            const newStatus = col.getAttribute("data-status");
            if (!newStatus || !draggedId) return;
            const task = tasks.find(t => t.id === draggedId);
            if (task && task.status !== newStatus) {
                task.status = newStatus;
                save();
                render();
                notify(`Перемещено в "${statusNames[newStatus]}"`);
            }
            draggedId = null;
        });
    });
}

function init() {
    tasks.forEach(t => { if (!t.createdAt) t.createdAt = Date.now(); });
    save();
    render();
    initDropZones();
    addBtn.onclick = addTask;
    sortBtn.onclick = toggleSort;
    $$("[data-filter]").forEach(btn => {
        btn.onclick = () => setFilter(btn.getAttribute("data-filter"));
    });
    titleInp.onkeypress = e => { if (e.key === "Enter") addTask(); };
    notify(tasks.length ? `Загружено ${tasks.length} задач` : "Доска пуста. Добавьте первую задачу!");
}

init();