function saveFavoriteCulture(festivalName) {
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];

    if (!favorites.includes(festivalName)) {
        favorites.push(festivalName);
        localStorage.setItem("favorites", JSON.stringify(favorites));
        alert(`${festivalName} has been saved to your favorites!`);
    } else {
        alert(`${festivalName} is already in your favorites.`);
    }
}


function checkFavorites() {
    let favorites = JSON.parse(localStorage.getItem('favorites')) || [];
    let favoritesList = document.getElementById('favoritesList');
    
    // Clear the current list
    favoritesList.innerHTML = '';
    
    // If there are no favorites, show a message
    if (favorites.length === 0) {
        favoritesList.innerHTML = '<li class="list-group-item">No favorites added yet.</li>';
    } else {
        // Create a list of favorites with remove buttons
        favorites.forEach(festival => {
            let listItem = document.createElement('li');
            listItem.classList.add('list-group-item');
            listItem.innerHTML = `${festival} <button class="btn btn-outline-danger btn-sm float-end" onclick="removeFavorite('${festival}')">Remove</button>`;
            favoritesList.appendChild(listItem);
        });
    }

    // Show the modal
    new bootstrap.Modal(document.getElementById('favoritesModal')).show();
}

function removeFavorite(festival) {
    let favorites = JSON.parse(localStorage.getItem('favorites')) || [];
    
    // Remove from localStorage
    favorites = favorites.filter(item => item !== festival);
    localStorage.setItem('favorites', JSON.stringify(favorites));

    // Remove the item visually from the list
    const listItems = document.querySelectorAll('#favoritesList li');
    listItems.forEach(item => {
        if (item.innerText.includes(festival)) {
            item.remove();
        }
    });

    // Optional: Show a little message
    if (favorites.length === 0) {
        document.getElementById('favoritesList').innerHTML = '<li class="list-group-item">No favorites added yet.</li>';
    }
}
