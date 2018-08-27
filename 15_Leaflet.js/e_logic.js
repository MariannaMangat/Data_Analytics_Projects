// Techtonic plates bourders - online resource link
var EarthquakeURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"

// Techtonic plates bourders - online resource link
var TechtonicPlatesURL = "https://raw.githubusercontent.com/fraxen/tectonicplates/master/GeoJSON/PB2002_boundaries.json"

// Performing a GET-request to EarthquakeData url query
d3.json(EarthquakeURL, function(data){
    // Once we have a url response, send data.features object to the createFeatures function
    createFeatures(data.features);
    console.log(data.features);
});

function createFeatures(earthquakeData) {
    var earthquakes = L.geoJson(earthquakeData, {
        
        // Adding markers to each feature in the earthquakeData array
        onEachFeature: function(feature, layer){
            layer.bindPopup("<h3>" + feature.properties.place + "<br> Magnitude: " +
            feature.properties.mag + "</h3><hr><p>" + new Date(feature.properties.time) + "</p>");
        },
        
        // Creating GeoJson layer containing features from earthquakeData object
        pointToLayer: function(feature, latlng) {
            return new L.circle(latlng, 
                { radius: getRadius(feature.properties.mag),
                fillColor: getColor(feature.properties.mag),
                fillOpacity: 0.8,
                stroke: true,
                color: "black",
                weight: 0.5
            })
        }
    });

    // Sending earthquakes layer to the createMap function
    createMap(earthquakes);
};

// Define map layers - satellite, outdoors, and dark map layers
function createMap(earthquakes) {
    // var satelliteMap = L.tileLayer("https://api.mapbox.com/styles/v1/mari123/cjlbgdo1447b52rljffoz45un.html?fresh=true&title=true&access_token=pk.eyJ1IjoibWFyaTEyMyIsImEiOiJjamt1Z3IwOGswZnRyM2txcXcyNjJ2ODFyIn0.2gzArngLwmrfIgntPKCdHQ#12.0/48.866500/2.317600/0");


    // Define streetmap and darkmap layers
    var outdoorsMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/outdoors-v10/tiles/256/{z}/{x}/{y}?" +
        "access_token={accessToken}", {
            accessToken: API_KEY,
            maxZoom: 18
        });

    var darkMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?" +
        "access_token={accessToken}", {
            accessToken: API_KEY,
            maxZoom: 18
        });

    // Define a baseMaps object to hold our base layers
    var baseMaps = {
        // "Satellite Map": satelliteMap,
        "Street Map": outdoorsMap,
        "Dark Map": darkMap
    };

    var techtonicPlates = new L.LayerGroup();

    var overlayMaps =  {
        Earthquakes: earthquakes,
        "Techtonic Plates": techtonicPlates
    };

    // Create our map, giving it the outdoorsMap, earthquakes and techtonicPlates layers to display on load
    var myMap = L.map("map", {
        center: [
            37.09, -95.71
        ],
        zoom: 5,
        layers: [outdoorsMap, earthquakes, techtonicPlates]
    });
 
    // Adding techtonic plates data to the layer along with style information
    d3.json(TechtonicPlatesURL, function(platesData) {
        L.geoJson(platesData, {
            color: "blue",
            weight: 3    
        })
        .addTo(techtonicPlates);
    });

    // Creating layer control
    // Passing in baseMap and overlayMaps to layer control
    L.control.layers(baseMaps, overlayMaps, {
        collapsed: false
    }).addTo(myMap);

    // Creating legend
    var legend = L.control({position: 'bottomright'});

    legend.onAdd = function(myMap) {
        var div = L.DomUtil.create('div', 'info legend'),
                    grades = [0,1,2,3,4,5],
                    labels = [];                    
    

        // Looping through density intervals
        // Generating a color label for each density interval
        grades.forEach((value, index) => {
            div.innerHTML +=
                ' <i style="background:' + getColor(grades[index] + 1) + '"></i> ' +
                    grades[index] + (grades[index+1] ? '&ndash;' + grades[index+1] + '<br>' : '+');
        })
        return div;
    };

    legend.addTo(myMap);
}

function getColor(d) {
    return d > 5 ? '#f30' :
        d > 4 ? '#f60' :
        d > 3 ? '#f90' :
        d > 2 ? '#fc0' :
        d > 1 ? '#ff0' : '#9f3';
}

function getRadius(value) {
    return value * 40000
}