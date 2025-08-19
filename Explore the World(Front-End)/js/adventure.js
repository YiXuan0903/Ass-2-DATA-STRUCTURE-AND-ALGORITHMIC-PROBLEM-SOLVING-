// Function to clear the saved favorite from localStorage
function clearFavorite() {
    // Remove the specific item (favorite adventure) from localStorage
    localStorage.removeItem("favoriteAdventure");

    // Reset the displayed favorite text to default
    document.getElementById("favoriteDisplay").innerText = 
        "Your favorite adventure: None selected yet."; // Reset display

    // Optional: Enable the button again if you want to allow re-saving
    const saveButton = document.querySelectorAll('.btn-outline-warning');
    saveButton.forEach(button => {
        button.disabled = false;
        button.innerText = "⭐ Save as Favorite"; // Reset button text
    });

    alert("Your favorite adventure has been cleared.");
}



// Function to save the favorite activity to localStorage
function saveFavoriteAdventure(adventure) {
    // Save the favorite adventure to localStorage
    localStorage.setItem("favoriteAdventure", adventure);

    // Optional: Change the button text to show it's saved
    const saveButton = event.target; // Get the clicked button
    saveButton.innerText = "⭐ Saved"; // Change text after saving
    saveButton.disabled = true;       // Disable the button to prevent multiple clicks

    // Update the favoriteDisplay text
    document.getElementById("favoriteDisplay").innerText = 
        "Your favorite adventure: " + adventure;

    // Alert to confirm the favorite is saved
    alert("Your favorite adventure is saved: " + adventure);
}

// On page load, check if there's a saved favorite in localStorage
window.onload = function () {
    const savedFavorite = localStorage.getItem("favoriteAdventure");

    // If there's a saved favorite, update the display
    if (savedFavorite) {
        document.getElementById("favoriteDisplay").innerText = 
            "Your favorite adventure: " + savedFavorite;
    } else {
        // If no favorite is saved, display a default message
        document.getElementById("favoriteDisplay").innerText = 
            "Your favorite adventure: None selected yet.";
    }
};


window.onload = function () {
    const savedFavorite = localStorage.getItem("favoriteAdventure");

    if (savedFavorite) {
        document.getElementById("favoriteDisplay").innerText = 
            "Your favorite adventure: " + savedFavorite;
    } else {
        document.getElementById("favoriteDisplay").innerText = 
            "Your favorite adventure: None selected yet."; // Default message
    }
};

function clearFavorite() {
    console.log('Clearing favorite...');
    localStorage.removeItem("favoriteAdventure");
    console.log('favoriteAdventure removed from localStorage');

    document.getElementById("favoriteDisplay").innerText = "Your favorite adventure: None selected yet.";
    
    const saveButton = document.querySelectorAll('.btn-outline-warning');
    saveButton.forEach(button => {
        button.disabled = false;
        button.innerText = "⭐ Save as Favorite"; 
    });

    alert("Your favorite adventure has been cleared.");
}


// Show saved favorite on load
window.onload = function () {
  const fav = localStorage.getItem("favoriteAdventure");
  if (fav) {
    document.getElementById("favoriteDisplay").innerText = 
      "Your favorite adventure: " + fav;
  }
};
