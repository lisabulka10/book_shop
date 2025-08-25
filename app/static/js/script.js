document.querySelectorAll('.add-to-cart').forEach(btn => {
    btn.addEventListener('click', async (e) => {
        const bookId = e.target.dataset.id;
        try {
            const response = await fetch('/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ book_id: bookId })
            });

            const data = await response.json();
            alert(data.message); // или обновляем счётчик корзины
        } catch (err) {
            console.error(err);
        }
    });
});
