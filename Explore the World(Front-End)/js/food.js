// Retrieve saved ratings from localStorage or initialize them as empty objects
let ratings = JSON.parse(localStorage.getItem('ratings')) || {};  // Empty object, no longer grouped by dishId

// Function to update the average rating for a specific food item
function updateAverageRating(foodName) {
    let foodRatings = ratings[foodName] || [];
    let average = foodRatings.reduce((sum, rating) => sum + rating, 0) / foodRatings.length;
    average = average || 0;
    document.getElementById(`avg-rating-${foodName}`).textContent = average.toFixed(1);
}
document.addEventListener("DOMContentLoaded", function () {
    const foodCards = document.querySelectorAll(".food-card");

    foodCards.forEach(card => {
        const dishName = card.getAttribute("data-dish");
        const stars = card.querySelectorAll(".star");
        const avgRatingSpan = document.getElementById(`avg-rating-${dishName}`);

        let ratings = JSON.parse(localStorage.getItem("ratings")) || {};
        if (!ratings[dishName]) ratings[dishName] = [];

        updateAverageRating(dishName);

        stars.forEach(star => {
            star.addEventListener("click", () => {
                const ratingValue = parseInt(star.getAttribute("data-rating"));

                // Save rating to localStorage
                ratings[dishName].push(ratingValue);
                localStorage.setItem("ratings", JSON.stringify(ratings));

                updateAverageRating(dishName);
            });
        });

        function updateAverageRating(dish) {
            const dishRatings = ratings[dish];
            if (!dishRatings.length) return;

            const sum = dishRatings.reduce((a, b) => a + b, 0);
            const average = (sum / dishRatings.length).toFixed(1);
            if (avgRatingSpan) {
                avgRatingSpan.textContent = average;
            }
        }
    });
});

// Event listener for all rating stars
document.querySelectorAll('.rating').forEach(function (ratingContainer) {
    let foodName = ratingContainer.closest('.food-card').getAttribute('data-dish'); // Get the food name from the parent div (the card)
    let stars = ratingContainer.querySelectorAll('.star');

    // Initialize the stars based on the saved rating for this specific food
    let savedRating = ratings[foodName] ? ratings[foodName].reduce((sum, rating) => sum + rating, 0) / ratings[foodName].length : 0;
    savedRating = savedRating || 0;

    // Update the UI with the saved rating
    for (let i = 0; i < Math.round(savedRating); i++) {
        stars[i].classList.add('selected');
    }
    document.getElementById(`avg-rating-${foodName}`).textContent = savedRating.toFixed(1);

    stars.forEach(function (star) {
        star.addEventListener('click', function () {
            let rating = parseInt(star.getAttribute('data-rating'));

            // Add the rating to the respective food
            if (!ratings[foodName]) {
                ratings[foodName] = []; // Initialize if not already
            }
            ratings[foodName].push(rating);

            // Update the average rating for this food
            updateAverageRating(foodName);

            // Highlight the stars based on the selected rating
            stars.forEach(function (s) {
                s.classList.remove('selected');
            });
            for (let i = 0; i < rating; i++) {
                stars[i].classList.add('selected');
            }

            // Save ratings to localStorage
            saveRatings();
        });

        // Highlight the stars on hover
        star.addEventListener('mouseover', function () {
            let rating = parseInt(star.getAttribute('data-rating'));
            stars.forEach(function (s, index) {
                if (index < rating) {
                    s.classList.add('hover');
                } else {
                    s.classList.remove('hover');
                }
            });
        });

        // Remove hover effect when mouse leaves
        star.addEventListener('mouseout', function () {
            stars.forEach(function (s) {
                s.classList.remove('hover');
            });
        });
    });
});

// Event listener for saving dishes to favorites
document.addEventListener("DOMContentLoaded", function () {
    const foodCards = document.querySelectorAll(".food-card");

    foodCards.forEach(card => {
        // Add Save button event listener for each destination food card
        const saveButtons = document.querySelectorAll(".save-btn");
        saveButtons.forEach(button => {
            button.addEventListener("click", () => {
                const foodName = button.getAttribute("data-food") || button.getAttribute("data-dish");
                let saved = JSON.parse(localStorage.getItem("savedFood")) || [];

                if (!saved.includes(foodName)) {
                    saved.push(foodName);
                    localStorage.setItem("savedFood", JSON.stringify(saved));
                    // Removed the alert message
                } 
            });
        });

        const dishName = card.getAttribute("data-dish");
        const stars = card.querySelectorAll(".star");
        const avgRatingSpan = document.getElementById(`avg-rating-${dishName}`);

        let ratings = getRatingsFromCookie() || {};
        if (!ratings[dishName]) ratings[dishName] = [];

        updateAverageRating(dishName);

        stars.forEach(star => {
            star.addEventListener("click", () => {
                const ratingValue = parseInt(star.getAttribute("data-rating"));
                ratings[dishName].push(ratingValue);

                // Save updated ratings to cookie
                setRatingsToCookie(ratings);

                updateAverageRating(dishName);
            });
        });

        function updateAverageRating(foodName) {
            let foodRatings = ratings[foodName] || [];
            let average;

            const foodCard = document.querySelector(`[data-dish="${foodName}"]`);
            const ratingStars = foodCard.querySelectorAll('.rating .star');

            if (foodRatings.length === 0) {
                average = parseFloat(foodCard.getAttribute('data-default-rating')) || 0;
            } else {
                average = foodRatings.reduce((sum, rating) => sum + rating, 0) / foodRatings.length;
            }

            // Update numeric rating
            document.getElementById(`avg-rating-${foodName}`).textContent = average.toFixed(1);

            // Fill stars based on the average (rounded down)
            ratingStars.forEach((star, index) => {
                star.classList.toggle('selected', index < Math.round(average));
            });
        }
    });

    // Cookie helper functions
    function setRatingsToCookie(data) {
        const jsonString = JSON.stringify(data);
        const encoded = encodeURIComponent(jsonString);
        document.cookie = `ratings=${encoded}; path=/; max-age=31536000`; // 1 year
    }

    function getRatingsFromCookie() {
        const cookieArr = document.cookie.split("; ");
        for (let cookie of cookieArr) {
            if (cookie.startsWith("ratings=")) {
                const value = decodeURIComponent(cookie.split("=")[1]);
                try {
                    return JSON.parse(value);
                } catch (e) {
                    return {};
                }
            }
        }
        return {};
    }
});

// Display saved food items
function displaySavedFood() {
    const saved = getSavedFood();
    const container = document.getElementById('saved-food');
    container.innerHTML = '';

    if (saved.length === 0) {
        container.innerHTML = "<p>You haven't saved any food gallery yet.</p>";
        return;
    }

    saved.forEach(food => {
        const url = generateFoodURL(food);

        const card = document.createElement('div');
        card.className = 'col-md-4';
        card.innerHTML = `
            <div class="food-card">
                <h4><a href="${url}" target="_blank">${food}</a></h4>
                <button class="btn btn-danger mt-2" onclick="removeFood('${food}')">Remove</button>
            </div>
        `;
        container.appendChild(card);
    });
}

// Remove food from saved list
function removeFood(food) {
    let saved = getSavedFood();
    saved = saved.filter(item => item !== food);
    localStorage.setItem("savedFood", JSON.stringify(saved)); // Save the updated list
    displaySavedFood(); // Refresh the displayed list after removal
}

// Get the saved food items from localStorage
function getSavedFood() {
    const saved = JSON.parse(localStorage.getItem("savedFood")) || [];
    return saved.filter(food => food !== null && food !== undefined && food !== '');
}

// Generate the URL for each food item
function generateFoodURL(food) {
    if (food === "The classic French baguette" || food === "French onion soup" || food === "Crêpes and Galettes")
        return "./foodPages/parisFood.html";
    if (food === "BagelWithCreamCheeseAndLox" || food === "PastramiOnRye" || food === "Cronut")
        return "./foodPages/newYorkFood.html";
    if (food === "Pasta alla Carbonara" || food === "Carciofi_alla_Romana_e_Carciofi_alla_Giudia" || food === "Maritozzi")
        return "./foodPages/romeFood.html";
    return "#";
}

function generateFoodURL(food) {
    const map = {
        // Destination names
        "Paris, France": "./foodPages/parisFood.html",
        "New York, USA": "./foodPages/newYorkFood.html",
        "Rome, Italy": "./foodPages/romeFood.html",

        // Dish names
        "The classic French baguette": "./foodPages/parisFood.html",
        "French onion soup": "./foodPages/parisFood.html",
        "Crêpes and Galettes": "./foodPages/parisFood.html",
        "BagelWithCreamCheeseAndLox": "./foodPages/newYorkFood.html",
        "PastramiOnRye": "./foodPages/newYorkFood.html",
        "Cronut": "./foodPages/newYorkFood.html",
        "Pasta alla Carbonara": "./foodPages/romeFood.html",
        "Carciofi_alla_Romana_e_Carciofi_alla_Giudia": "./foodPages/romeFood.html",
        "Maritozzi": "./foodPages/romeFood.html"
    };

    return map[food] || "#";
}


// Function to navigate back to the previous page
function goBack() {
    window.location.href = '../food&cuisine.html'; // bring users back to the main food menu
}
