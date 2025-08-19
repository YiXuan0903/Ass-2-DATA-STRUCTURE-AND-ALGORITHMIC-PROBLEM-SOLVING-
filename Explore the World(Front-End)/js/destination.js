// Save destinations using localStorage
document.addEventListener("DOMContentLoaded", function () {
    const saveButtons = document.querySelectorAll(".save-btn");

    saveButtons.forEach(button => {
        button.addEventListener("click", function () {
            const destination = this.getAttribute("data-destination");
            let savedDestinations = JSON.parse(localStorage.getItem("savedDestinations")) || [];

            if (!savedDestinations.includes(destination)) {
                savedDestinations.push(destination);
                localStorage.setItem("savedDestinations", JSON.stringify(savedDestinations));
                alert(destination + " has been saved!");
            } else {
                alert(destination + " is already in your favorites.");
            }
        });
    });
});

function displaySavedDestinations() {
    const saved = getSavedDestinations(); // now gets from localStorage
    const container = document.getElementById('saved-destinations');
    container.innerHTML = '';

    if (saved.length === 0) {
        container.innerHTML = "<p>You haven't saved any destinations yet.</p>";
        return;
    }

    saved.forEach(destination => {
        // Generate the corresponding URL
        const url = generateDestinationURL(destination);

        const card = document.createElement('div');
        card.className = 'col-md-4';
        card.innerHTML = `
            <div class="destination-card">
                <h4><a href="${url}" target="_blank">${destination}</a></h4>
                <button class="btn btn-danger mt-2" onclick="removeDestination('${destination}')">Remove</button>
            </div>
        `;
        container.appendChild(card);
    });
}

function removeDestination(destination) {
    let saved = getSavedDestinations();
    saved = saved.filter(item => item !== destination);
    localStorage.setItem("savedDestinations", JSON.stringify(saved));
    displaySavedDestinations(); // Refresh
}

function getSavedDestinations() {
    return JSON.parse(localStorage.getItem("savedDestinations")) || [];
}

function generateDestinationURL(destination) {
    if (destination === "Paris, France") return './destinationPages/paris.html';  // Adjusted to use './' for the current folder
    if (destination === "New York, USA") return './destinationPages/newYork.html';
    if (destination === "Rome, Italy") return './destinationPages/rome.html';
    return '#';  // Default if no match
}


function goBack() {
    window.location.href = '../destination.html'; // bring users back to the main destination menu
}