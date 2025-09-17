document.addEventListener('DOMContentLoaded', () => {
    const stars = document.querySelectorAll("#rating .star");
    const ratingDiv = document.getElementById("rating");
    const textInput = document.querySelector('#review-textarea');
    const review = document.querySelector('#review-modal');
    const buttonRev = document.querySelector('#review-button');


    stars.forEach(star => {
        star.addEventListener("mouseover", () => {
            resetStars();
            for (let i = 0; i < star.dataset.value; i++) {
                stars[i].classList.add("active");
            }
        });

        star.addEventListener("click", () => {
            ratingDiv.dataset.selected = star.dataset.value;
            resetStars();
            for (let i = 0; i < ratingDiv.dataset.selected; i++) {
                stars[i].classList.add("active");
            }
        });
    });

    function resetStars() {
        stars.forEach(s => s.classList.remove("active"));
    }


    buttonRev.addEventListener('click', async () => {
        const value = ratingDiv.dataset.selected;
        const book_id = review.dataset.book;
        const text = textInput.value;

        if (!value) {
            alert("Выберите оценку!");
            return;
        }

        try {
            const response = await fetch('/rate', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                credentials: "same-origin",
                body: JSON.stringify({ value, book_id, text })
            });

            if (response.status === 401) {
                const currentUrl = window.location.href;
                window.location.href = `/login?next=${encodeURIComponent(currentUrl)}`;
                return;
            }

            const data = await response.json();

            if (data?.success) {
                alert("Рецензия успешно отправлена!");

                const modalEl = document.getElementById('exampleModal');
                if (modalEl) {
                    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                    modal.hide();
                }

                ratingDiv.dataset.selected = 0;
                textInput.value = "";
                resetStars();
            } else if (data?.error) {
                alert("Ошибка: " + data.error);
            }

        } catch (err) {
            console.error("Ошибка при отправке рецензии:", err);
            alert("Произошла ошибка. Попробуйте позже.");
        }
    });
});