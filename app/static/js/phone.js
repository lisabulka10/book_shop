document.addEventListener("DOMContentLoaded", function () {
    const input = document.querySelector("#phone"); // твой input с телефоном

    if (!input) return; // защита, если input не найден

    const iti = window.intlTelInput(input, {
        initialCountry: "auto",      // автоопределение страны
        geoIpLookup: function (callback) {
            fetch("https://ipapi.co/json")
                .then(res => res.json())
                .then(data => callback(data.country_code))
                .catch(() => callback("ru")); // если не удалось определить
        },
        utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.19/js/utils.js",
        nationalMode: false,          // международный формат
        autoHideDialCode: false,      // код страны всегда виден
        formatOnDisplay: true,        // форматирование при показе
    });

    // Валидация телефона перед отправкой формы
    const form = input.closest("form");
    if (form) {
        form.addEventListener("submit", function (e) {
            if (input.value.trim() === "" || !iti.isValidNumber()) {
                e.preventDefault();
                alert("Пожалуйста, введите корректный номер телефона!");
                input.focus();
            } else {
                // Подставляем полный формат для сервера
                input.value = iti.getNumber(); // +7xxxxxxx
            }
        });
    }
});


/*document.addEventListener("DOMContentLoaded", function() {
    const input = document.querySelector("#phone");

    if (input) {
        window.intlTelInput(input, {
            initialCountry: "ru", // дефолтная страна
            utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.19/js/utils.js",
            separateDialCode: true // показывает код отдельно, удобно
        });
    }
});*/



/*$(document).ready(function(){
    function setMask() {
        let selected = $('#country-select option:selected');
        let mask = selected.data('mask');
        $('#phone-input').val('').unmask().mask(mask);

        // Обновляем hidden перед сабмитом
        $('#country-code').val(selected.val());
    }

    setMask(); // при загрузке
    $('#country-select').change(setMask);

    // На случай, если форма сабмитится до выбора
    $('form').on('submit', function(){
        $('#country-code').val($('#country-select').val());
    });
});*/



 /*   $(document).ready(function(){
    function setMask() {
        let selected = $('#country option:selected');
        let mask = selected.data('mask');
        $('#country_code').val(selected.val());
        $('#phone').val('').unmask().mask(mask);
    }

    setMask();

    $('#country').change(function(){
        setMask();
    });

});*/