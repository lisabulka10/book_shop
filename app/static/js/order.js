const deliveryRadio = document.querySelectorAll('.delivery-radio');
const payMethodTd = document.querySelector('#pay_method_summary');
const payMethodRadio = document.querySelectorAll('.pay-wrapper input.mb-2.form-check-input');
const detailsDiv = document.querySelector('.details')
const officeInput = document.querySelector('#office-input')
const entranceInput = document.querySelector('#entrance-input')
const intercomInput = document.querySelector('#intercom-input')
const floorInput = document.querySelector('#floor-input')


function handleDeliveryChange(radio) {
    const delivery_type = radio.dataset.type;
    const address_id = radio.value;

    fetch('/order/details', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify({ delivery_type, address_id })
    })
    .then(res => res.json())
    .then(data => {
        if (!data.shop) {
            detailsDiv.style.display = 'block';
            officeInput.value = data.office || "";
            entranceInput.value = data.entrance || "";
            intercomInput.value = data.intercom || "";
            floorInput.value = data.floor || "";
        } else {
            detailsDiv.style.display = 'none';
        }
    })
    .catch(err => console.error(err));
}


deliveryRadio.forEach(radio => {
    radio.addEventListener('change', () => handleDeliveryChange(radio));
});

if (deliveryRadio.length > 0) {
    deliveryRadio[0].checked = true;
    handleDeliveryChange(deliveryRadio[0]);
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


const form = document.querySelector('form');

form.addEventListener('submit', (e) => {
    const anyChecked = Array.from(deliveryRadio).some(r => r.checked);
    if (!anyChecked) {
        e.preventDefault();
        alert('Пожалуйста, выберите способ доставки');
    }
});
