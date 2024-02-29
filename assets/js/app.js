// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import XYZ from 'ol/source/XYZ';

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

const container = window.document.querySelector("#map")
if (container) {
  const worldID = container.attributes["data-world-id"].value;
  const maxZoom = parseInt(container.attributes["data-max-zoom"].value, 10);

  new Map({
    target: 'map',
    layers: [
      new TileLayer({
        source: new XYZ({
          url: `/uploads/world-${worldID}/tiles/{z}/tile_{x}_{y}.png`,
          wrapX: false
        }),
      })
    ],
    view: new View({
      center: [0, 0],
      zoom: 0,
      maxZoom: maxZoom,
      extent: new View().getProjection().getExtent()
    })
  });


  // var map = leaflet.map("map").setView([0, 0], 0);
  // maxPixelBounds = map.getPixelWorldBounds().max;
  // northEast = L.latLng(maxPixelBounds.x,maxPixelBounds.y);
  // southWest = L.latLng(maxPixelBounds.x*-1,maxPixelBounds.y*-1);
  // bounds = L.latLngBounds(southWest,northEast);

  // leaflet
  //   .tileLayer(`/uploads/world-${worldID}/tiles/{z}/tile_{x}_{y}.png`, {
  //     maxZoom: maxZoom,
  //     noWrap: true,
  //     maxBounds: bounds,
  //   })
  //   .addTo(map);

  // leaflet.Icon.Default.imagePath = '../images/' // Tell leaflet we store images in priv/static/images

  // function onMapClick(e) {
  //   leaflet.marker(e.latlng).addTo(map);
  // }
  // map.on('click', onMapClick);

  // map.on("zoom", function (event){
  //   maxPixelBounds = map.getPixelWorldBounds().max;
  //   northEast = L.latLng(maxPixelBounds.x,maxPixelBounds.y);
  //   southWest = L.latLng(maxPixelBounds.x*-1,maxPixelBounds.y*-1);
  //   bounds = L.latLngBounds(southWest,northEast);

  //   map.setMaxBounds(bounds);
  // });
}

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
