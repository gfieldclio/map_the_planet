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
  const worldID = container.attributes["data-world-id"].value;
  const maxZoom = parseInt(container.attributes["data-max-zoom"].value, 10);
  const vectorSource = new VectorSource({
    features: [],
  });
  const vectorLayer = new VectorLayer({
    source: vectorSource,
  });

  onMapClick = function (event) {
    const iconFeature = new Feature({
      geometry: new Point(event.coordinate),
    });
    const iconStyle = new Style({
      image: new Icon({
        anchor: [0.5, 46],
        anchorXUnits: "fraction",
        anchorYUnits: "pixels",
        src: "/images/marker-icon.png",
      }),
    });
    iconFeature.setStyle(iconStyle);
    vectorSource.addFeature(iconFeature);
  };

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

  map.on("click", onMapClick);
}
