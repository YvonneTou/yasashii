import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-map"
export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object
  }

  connect() {
    console.log(this.markerValue)
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [this.markerValue.lng, this.markerValue.lat],
      zoom: 13
    })
    this.#addMarkerToMap()
  }

  #addMarkerToMap() {
    console.log(this.markerValue)
    const customMarker = document.createElement("div")
    customMarker.innerHTML = this.markerValue.marker_html
    const aMarker = new mapboxgl.Marker(customMarker)
      .setLngLat([ this.markerValue.lng, this.markerValue.lat ])
      .addTo(this.map)
  }
}
