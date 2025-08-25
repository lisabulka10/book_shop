const deliveryRadio = document.querySelectorAll('.delivery-radio');
const payMethodTd = document.querySelector('#pay_method_summary');
const payMethodRadio = document.querySelectorAll('.pay-wrapper input[class="mb-2 form-check-input"]');

if (deliveryRadio.length > 0) {
    deliveryRadio[0].checked = true;
}

function setSummaryPay() {
    for (const radio of payMethodRadio) {
        if (radio.checked) {
            switch (radio.value) {
                case 'SBP':
                    payMethodTd.textContent = 'СБП Онлайн';
                    break;
                case 'CARD':
                    payMethodTd.textContent = 'Картой Онлайн';
                    break;
                case 'RECEIPT':
                    payMethodTd.textContent = 'При получении';
                    break;
            }
        }
    }
}

payMethodRadio.forEach(radio => {
    radio.addEventListener('change', function() {
        setSummaryPay();
        if (this.checked) {
            console.log(`Выбрана опция: ${this.value}`);
        }
    });
});

setSummaryPay();
