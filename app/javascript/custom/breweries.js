const BREWERIES = {};

const createTableRow = (brewery) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");
    const breweryName = tr.appendChild(document.createElement("td"));
    breweryName.innerHTML = brewery.name;
    const year = tr.appendChild(document.createElement("td"));
    year.innerHTML = brewery.year;
    const beerCount = tr.appendChild(document.createElement("td"));
    beerCount.innerHTML = brewery.beerCount;
    const active = tr.appendChild(document.createElement("td"));
    active.innerHTML = brewery.active;

    return tr;
}

BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById("brewerytable");

    BREWERIES.list.forEach((brewery) => {
        const tr = createTableRow(brewery);
        table.appendChild(tr);
    });
}
const handleResponse = (breweries) => {
    BREWERIES.list = breweries;
    BREWERIES.show();
}
const breweries = () => {
    if (document.querySelectorAll("#brewerytable").length < 1) {
        return;
    }

    fetch("breweries.json")
        .then((response) => response.json())
        .then(handleResponse);
}

export {breweries};