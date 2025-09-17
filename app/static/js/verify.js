const verifyForm = document.querySelector('.verify-form');
const verifyContainer = document.getElementById("verify-container");
const messageEl = document.getElementById("message")
const input = document.querySelector("#phone");

const getCodeBtn = document.querySelector("#getCode")

getCodeBtn.addEventListener("click", async() => {
    const formData = {
            phone: input.value,
    };



    const res = await fetch("/send_code", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(formData)
    });

    if (res.ok) {
        const result = await res.json();
        if (result.success) {
            alert(result.message);
            getCodeBtn.style.display = "none";
            verifyContainer.style.display = "block";
        } else {
            alert(JSON.stringify(result.errors));
        }
    } else {
        const text = await res.text();
        console.error("Сервер вернул не JSON:", text);
        alert("Произошла ошибка на сервере. Проверьте консоль.");
    }
});

verifyForm.addEventListener("submit", async (e) => {
    e.preventDefault();

    const phone = input.value;
    const code = document.getElementById("code").value;

    const res = await fetch("/verify_ajax", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({phone, code})
    });

    const result = await res.json();
    console.log(result)
    console.log(result.success)

    if (result.success) {
        messageEl.style.color = "green";
        messageEl.textContent = result.message;
        setTimeout(() => window.location.href = "/login", 2000);
    } else {
        messageEl.style.color = "red";
        messageEl.textContent = result.message;
    }
});
