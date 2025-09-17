document.addEventListener("DOMContentLoaded", function () {
    const input = document.querySelector("#phone");

    if (!input) return;

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
        formatOnDisplay: true,
    });

    const form = input.closest("form");
    if (form) {
        form.addEventListener("submit", function (e) {
            if (input.value.trim() === "" || !iti.isValidNumber()) {
                e.preventDefault();
                alert("Пожалуйста, введите корректный номер телефона!");
                input.focus();
            } else {
                input.value = iti.getNumber();
            }
        });
    }
});

