document.addEventListener('DOMContentLoaded', function () {
    const DADATA_API_KEY = "6661d5e80a299237581cdf62d7ceb8391cd2e864";

    const deliveryTypeSelect = document.querySelector('[name="delivery_type"]');
    const acceptButton = document.getElementById('accept');
    const cityInput = document.getElementById('city');
    const addressInput = document.getElementById('address');
    const cityShopSelect = document.getElementById('city_shop_select');
    const shopSelect = document.getElementById('shops_select');

    courierCity = document.getElementById('courier_city')
    courierAddress = document.getElementById('courier_address')
    pickupCity = document.getElementById('pickup_city')
    pickupShop = document.getElementById('pickup_shop')


    pickupCity.style.display = 'none';
    pickupShop.style.display = 'none';

    let myMap, myPlacemark;
    let citySelected = false;
    let addressSelected = false;
    let selectedCity = "";
    let pickupSelect;

    ymaps.ready(function() {
        myMap = new ymaps.Map("map", {
            center: [59.938784, 30.314997],
            zoom: 10
        });
    });


    function setMapPoint(coords, text) {
        if (myPlacemark) myMap.geoObjects.remove(myPlacemark);
        myPlacemark = new ymaps.Placemark(coords, { balloonContent: text });
        myMap.geoObjects.add(myPlacemark);
        myMap.setCenter(coords, 14);
    }

    function geocodeAddress(address, zoom=14) {
        if (!address) return;
        ymaps.geocode(address).then(function(res) {
        const geo = res.geoObjects.get(0);
        if (!geo) return;
        const coords = geo.geometry.getCoordinates();
        setMapPoint(coords, address);
        });
    }

    function updateAcceptState() {
        acceptButton.disabled = !(citySelected && addressSelected);
    }


    function getSuggestions(query, type, callback) {
        fetch("https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Token " + DADATA_API_KEY
        },
        body: JSON.stringify({
            query: query,
            count: 5,
            from_bound: { value: type === "city" ? "city" : "street" },
            to_bound: { value: type === "city" ? "city" : "house" }
        })
    })
        .then(r => r.json())
        .then(data => callback(data.suggestions || []))
        .catch(err => {
            console.error('Dadata error', err);
            callback([]);
        });
    }

    function clearContainer(id) {
        const el = document.getElementById(id);
        if (el) el.innerHTML = "";
    }

    function renderSuggestions(containerId, suggestions, onSelect) {
        const container = document.getElementById(containerId);
        if (!container) return;
        container.innerHTML = "";
        suggestions.forEach(item => {
            const div = document.createElement("div");
            div.className = "suggestion-item";
            div.textContent = item.value;
            div.addEventListener('mousedown', function (e) {
                e.preventDefault();
                onSelect(item);
            });
        container.appendChild(div);
        });
    }


    function handleCityChange() {
        const city_name = this.value;
        shopSelect.innerHTML = '<option value="0">- Выберите магазин -</option>';

        if (city_name) {
            fetch(`/shops/${city_name}`)
                .then(response => response.json())
                .then(data => {
                    data.forEach(shop => {
                        const option = document.createElement('option');
                        option.value = shop.address_id;
                        option.dataset.coords = JSON.stringify([shop.lat, shop.lon])
                        option.textContent = `${shop.address.street}, ${shop.address.house}`;
                        shopSelect.appendChild(option);
                        geocodeAddress(shop.address.city, 14)
                    })
                })
                .catch(err => console.error("Ошибка при добавлении магазинов", err));

        }
    };

    function handleShopChange()  {
        const selectedOption = this.options[this.selectedIndex];
        try {
            if (this.selectedIndex > 0) {
                const coords = JSON.parse(selectedOption.dataset.coords);
                setMapPoint(coords, selectedOption.textContent);
                citySelected = true;
                addressSelected = true;
                updateAcceptState();
            } else {
                citySelected = false;
                addressSelected = false;
                updateAcceptState();
            }
        } catch(e) {
            console.error("Нет координат для магазина")
            geocodeAddress(selectedOption.textContent);
        }
    };


    shopSelect.addEventListener('change', handleShopChange);
    cityShopSelect.addEventListener('change', handleCityChange);


    deliveryTypeSelect.addEventListener('change', function () {
        const cityInput = document.querySelector('#city')
        const addressInput = document.querySelector('#address')
        if (this.value.toLowerCase() === "pickup") {
            courierCity.style.display = 'none';
            cityInput.required = false;
            cityInput.innerHTML = '';

            courierAddress.style.display = 'none';
            addressInput.required = false;
            addressInput.innerHTML = '';

            pickupCity.style.display = 'block';
            pickupShop.style.display = 'block';

            citySelected = false;
            addressSelected = false;
            updateAcceptState();

            if (cityShopSelect.options.length > 0){
                cityShopSelect.selectedIndex = 0;
                handleCityChange.call(cityShopSelect);
            }

        } else {
            courierCity.style.display = 'block';
            cityInput.required = true;

            courierAddress.style.display = 'block';
            addressInput.required = true;

            pickupCity.style.display = 'none';
            pickupShop.style.display = 'none';
        }

    });


    cityInput.addEventListener('input', function() {
        citySelected = false;
        addressSelected = false;
        selectedCity = "";
        updateAcceptState();
        clearContainer('city-suggestions');
        clearContainer('address-suggestions');
        const val = this.value;
        if (val.length > 1) {
            getSuggestions(val, "city", function(suggestions) {
                renderSuggestions("city-suggestions", suggestions, function(item) {
                    selectedCity = item.value;
                    cityInput.value = selectedCity;
                    citySelected = true;
                    addressSelected = false;
                    updateAcceptState();
                    clearContainer('city-suggestions');
                    geocodeAddress(selectedCity, 10);
                });
            });
        }
    });


    addressInput.addEventListener('input', function() {
        addressSelected = false;
        updateAcceptState();
        clearContainer('address-suggestions');
        const val = this.value;
        if (val.length > 1) {
            getSuggestions(val, "address", function(suggestions) {
                renderSuggestions("address-suggestions", suggestions, function(item) {
                    addressInput.value = item.value;
                    clearContainer('address-suggestions');
                    const fullAddress = selectedCity ? (selectedCity + ", " + item.value) : item.value;
                    geocodeAddress(fullAddress, 14);
                    const hasHouseNumber = /\d/.test(item.value);
                    if (citySelected && hasHouseNumber) {
                        addressSelected = true;
                    } else {
                        addressSelected = false;
                    }
                    updateAcceptState();
                });
            });
        }
    });


    const form = acceptButton.closest('form');
    if (form) {
        form.addEventListener('submit', function(e) {
        if (!(citySelected && addressSelected)) {
            e.preventDefault();
            alert('Пожалуйста, выберите адрес из подсказок с номером дома.');
        }
        });
    }


    document.addEventListener('click', function(e) {
        if (!e.target.closest('#city-suggestions') && e.target !== cityInput) {
            clearContainer('city-suggestions');
        }
        if (!e.target.closest('#address-suggestions') && e.target !== addressInput) {
            clearContainer('address-suggestions');
        }
    });
});