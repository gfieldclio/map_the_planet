import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import Feature from "ol/Feature";
import Style from "ol/style/Style";
import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import Icon from "ol/style/Icon";
import Point from "ol/geom/Point";
import XYZ from "ol/source/XYZ";

const container = window.document.querySelector("#map");
if (container) {
  const MODE_MOVE = "move";
  const MODE_DRAW = "draw";
  const MODE_PIN = "pin";

  const worldID = container.attributes["data-world-id"].value;
  const maxZoom = parseInt(container.attributes["data-max-zoom"].value, 10);
  const vectorSource = new VectorSource({
    features: [],
  });
  const vectorLayer = new VectorLayer({
    source: vectorSource,
  });
  mode = MODE_MOVE;

  addPin = function (event) {
    if (mode != MODE_PIN) {
      return;
    }

    const iconFeature = new Feature({
      geometry: new Point(event.coordinate),
    });
    const iconStyle = new Style({
      image: new Icon({
        anchor: [0.5, 1],
        anchorXUnits: "fraction",
        anchorYUnits: "fraction",
        src: "/images/eye-sauron-icon.png",
      }),
    });
    iconFeature.setStyle(iconStyle);
    vectorSource.addFeature(iconFeature);
  };

  draw = function (event) {
    
  }

  const map = new Map({
    target: "map",
    layers: [
      new TileLayer({
        source: new XYZ({
          url: `/uploads/world-${worldID}/tiles/{z}/tile_{x}_{y}.png`,
          wrapX: false,
        }),
      }),
      vectorLayer,
    ],
    view: new View({
      center: [0, 0],
      zoom: 0,
      maxZoom: maxZoom,
      extent: new View().getProjection().getExtent(),
    }),
  });

  map.on("click", addPin);
  map.on("click", draw);

  document.querySelector("#move").addEventListener("click", function () {
    mode = MODE_MOVE;
  });
  document.querySelector("#draw").addEventListener("click", function () {
    mode = MODE_DRAW;
  });
  document.querySelector("#pin").addEventListener("click", function () {
    mode = MODE_PIN;
  });
}
