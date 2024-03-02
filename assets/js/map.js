import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import XYZ from "ol/source/XYZ";
import {defaults as defaultControls} from 'ol/control';
import DrawModeControl from "./map/draw-mode-control";

const container = window.document.querySelector("#map");
if (container) {
  const worldID = container.attributes["data-world-id"].value;
  const maxZoom = parseInt(container.attributes["data-max-zoom"].value, 10);
  const vectorSource = new VectorSource({
    features: [],
  });
  const vectorLayer = new VectorLayer({
    source: vectorSource,
  });

  new Map({
    controls: defaultControls().extend([new DrawModeControl()]),
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
}
