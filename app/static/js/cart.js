
document.addEventListener("DOMContentLoaded", () => {
    const table = document.querySelector(".table");
    const totalPriceElement = document.getElementById("totalPrice");
    const itemCountElement = document.getElementById("itemCount");
    const checkoutBtn = document.getElementById("checkoutBtn");
    const cartCount = document.getElementById("cart-count");

    const selectAll = document.getElementById("selectAll");
    const checkboxes = document.querySelectorAll("input[name='selected-items']");

    checkboxes.forEach(ch => ch.checked = true);
    if (selectAll) selectAll.checked = true;


    //cartCount.textContent = "";

    /*const deleteBtn = document.getElementById("basketDelete");
    const cartCount = document.getElementById("cart-count");
    const elementsToHide = document.getElementById("manageLine")

    deleteBtn.addEventListener("click", async () => {
        const userId = deleteBtn.dataset.id;

        const response = await fetch("/api/cart/delete", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ user_id: userId })
        });

        const data = await response.json();
        if (response.ok) {
            cartCount.textContent = data.cart_count;
            document.querySelectorAll(".cart-item").forEach(el => {
                el.remove()
            });
        } else {
            alert(data.error || "Ошибка добавления");
        }
    });*/

    function getNumberFromText(text) {
        return parseFloat(text.replace(/[^\d.]/g, "")) || 0;
    }

    function updateSummary() {
        let total = 0;
        let count = 0;
        document.querySelectorAll("tbody tr").forEach(row => {
            const checkbox = row.querySelector("input[name='selected-items']");
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
    }

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

            updateSummary();
        }
    });

    if (selectAll) {
        selectAll.addEventListener("change", () => {
            checkboxes.forEach(ch => ch.checked = selectAll.checked);
            updateSummary();
        });
    }

    checkboxes.forEach(ch => {
        ch.addEventListener("change", updateSummary);
    });

    updateSummary();
});
