
document.addEventListener("DOMContentLoaded", () => {
    const table = document.querySelector(".table");
    const totalPriceElement = document.getElementById("totalPrice");
    const itemCountElement = document.getElementById("itemCount");
    const checkoutBtn = document.getElementById("checkoutBtn");
    const cartCount = document.getElementById("cart-count");

    const selectAll = document.getElementById("selectAll");
    const checkboxes = document.querySelectorAll(".item-checkbox");

    checkboxes.forEach(ch => ch.checked = true);
    if (selectAll) selectAll.checked = true;

    function getNumberFromText(text) {
        return parseFloat(text.replace(/[^\d.]/g, "")) || 0;
    }

    function updateSummary() {
        let total = 0;
        let count = 0;
        document.querySelectorAll("tbody tr").forEach(row => {
            const checkbox = row.querySelector(".item-checkbox");
            if (checkbox && checkbox.checked) {
                const qty = parseInt(row.querySelector(".qty").value) || 0;
                const price = getNumberFromText(row.querySelector(".price")?.textContent || "0");
                total += price * qty;
                count += qty;
            }
        });
        totalPriceElement.textContent = `${total} ₽`;
        itemCountElement.textContent = count;
        checkoutBtn.disabled = count === 0;
    };

    async function updateCount(row, qty) {
        const itemId = row.dataset.id;
        await fetch("/cart/update-count", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": window.csrfToken || ""
            },
            body: JSON.stringify({
                id: itemId,
                count: qty
            })
        })
        .then(res => res.json())
        .then(data => {
            console.log("Количество обновлено:", data);
        })
        .catch(err => console.error("Ошибка при обновлении количества:", err));
        updateSummary();
    }

    async function updateSelected(row) {
        const itemId = row.dataset.id;
        await fetch("/cart/update-selected", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": window.csrfToken || ""
            },
            body: JSON.stringify({
                id: itemId,
            })
        })
        .then(res => res.json())
        .then(data => {
            console.log("Статус обновлен:", data);
        })
        .catch(err => console.error("Ошибка при обновлении статуса:", err));
    };

    table.addEventListener("click", (e) => {
        if (e.target.classList.contains("plus") || e.target.classList.contains("minus")) {
            const row = e.target.closest("tr");
            const input = row.querySelector(".qty");
            let qty = parseInt(input.value) || 1;

            if (e.target.classList.contains("plus")) qty++;
            if (e.target.classList.contains("minus") && qty > 1) qty--;

            input.value = qty;

            const price = getNumberFromText(row.querySelector(".price")?.textContent || "0");
            const totalCell = row.querySelector(".row-total");
            if (totalCell) {
                totalCell.textContent = `${price * qty} ₽`;
            }
            updateCount(row, qty)
            updateSummary();
        }
    });


    table.addEventListener("input", (e) => {
        if (e.target.classList.contains("qty")) {
            const row = e.target.closest("tr");
            let qty = parseInt(e.target.value) || 1;
            if (qty < 1) qty = 1;
            e.target.value = qty;

            const price = getNumberFromText(row.querySelector(".price")?.textContent || "0");
            const totalCell = row.querySelector(".row-total");
            if (totalCell) {
                totalCell.textContent = `${price * qty} ₽`;
            }
            updateCount(row, qty)
        }
    });


    if (selectAll) {
        selectAll.addEventListener("change", () => {
            checkboxes.forEach(ch => ch.checked = selectAll.checked);
            updateSummary();
        });
    }

    checkboxes.forEach(ch => {
        ch.addEventListener("change", (e) => {
            updateSummary();
            const row = e.target.closest("tr");
            if (!row) {
                console.error("Не найден <tr> для чекбокса", e.target);
                return;
            }
            updateSelected(row);

            });
    });

    updateSummary();
});
