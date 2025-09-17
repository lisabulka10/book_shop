document.addEventListener("DOMContentLoaded", function () {
    const input = document.querySelector("#phone");
    const form = document.querySelector("#registerForm");
    const verifyContainer = document.getElementById("verify-container");
    const registerContainer = document.getElementById("register-container");
    const messageEl = document.getElementById("message");

    if (!input || !form) return;

    const iti = window.intlTelInput(input, {
        initialCountry: "auto",
        geoIpLookup: function (callback) {
            fetch("https://ipapi.co/json")
                .then(res => res.json())
                .then(data => callback(data.country_code))
                .catch(() => callback("ru"));
        },
        utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.19/js/utils.js",
        nationalMode: false,
        autoHideDialCode: false,
        formatOnDisplay: true
    });


    form.addEventListener("submit", async function (e) {
        e.preventDefault();

        if (input.value.trim() === "" || !iti.isValidNumber()) {
            alert("Пожалуйста, введите корректный номер телефона!");
            input.focus();
            return;
        }

        input.value = iti.getNumber();

        const formData = {
            first_name: document.getElementById("first_name").value,
            last_name: document.getElementById("last_name").value,
            email: document.getElementById("email").value,
            phone: input.value,
            password: document.getElementById("password").value,
            confirm_password: document.getElementById("confirm_password").value,
            csrf_token: document.querySelector('[name="csrf_token"]').value
        };



        const res = await fetch("/register_ajax", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(formData)
        });

        if (res.ok) {
            const result = await res.json();
            if (result.success) {
                alert(result.message);
                registerContainer.style.display = "none";
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


    const verifyForm = document.querySelector('.verify-form');
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
});
