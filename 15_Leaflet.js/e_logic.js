// // Function to determine marker size based on population
// function markerSize(population) {
//     return population / 40;
// }

var myMap = L.map("map", {
    zoom: 15
});

L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 20,
    id: "mapbox.streets",
    accessToken: API_KEY
}).addTo(myMap);

url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"

d3.json(url, function (err, allWeek) {
    // new_data = allWeek.features.geometry.coordinates;
    new_data = allWeek.features[0];
    console.log("new data: ", new_data);

   
    // createMap(new_data);
});


