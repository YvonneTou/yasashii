import { Controller } from "@hotwired/stimulus"

const options = {
  enableHighAccuracy: true,
  maximumAge: 0
};

// Connects to data-controller="geolocation"
export default class extends Controller {
  static values = { url: String }
  static targets = [ "results", "search" ]

  connect() {
    navigator.geolocation.getCurrentPosition((pos) => {
      this.searchTarget.value =`${pos.coords.latitude},${pos.coords.longitude}`
    })
  }

  search(event) {
    // this.resultsTarget.innerHTML = "Latitude: " + crd.latitude +
    // "<br>Longitude: " + crd.longitude;
  }

  error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}
