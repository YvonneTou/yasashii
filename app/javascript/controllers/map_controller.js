import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    var firstMarker = true;
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup({ className: 'popups', anchor: 'top' }).setHTML(marker.clinic_card_html)
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html
      const aMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
      if (firstMarker == true) {
        aMarker.togglePopup();
        firstMarker = false;
      }
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: {top: 10, bottom: 90, left: 70, right: 70}, maxZoom: 11, duration: 0 })
    this.map.setPadding({top: 20, bottom: 110});
  }
}
