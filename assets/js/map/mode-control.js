import Draw from "ol/interaction/Draw";
import Feature from "ol/Feature";
import Icon from "ol/style/Icon";
import Point from "ol/geom/Point";
import Stroke from "ol/style/Stroke";
import Style from "ol/style/Style";

import ColorSelectorControl from "./color-selector-control";

import { MODE_DRAW, MODE_MOVE, MODE_PIN } from "./constants";
import { Control } from "ol/control";

class ModeControl extends Control {
  /**
   * @param {Object} [opt_options] Control options.
   */
  constructor(opt_options) {
    const options = opt_options || {};

    const pointerButton = document.createElement("button");
    pointerButton.innerHTML = "👆";
    const drawButton = document.createElement("button");
    drawButton.innerHTML = "🖋️";
    const pinButton = document.createElement("button");
    pinButton.innerHTML = "📌";

    const element = document.createElement("div");
    element.className = "top-2 right-2 ol-unselectable ol-control";
    element.appendChild(pointerButton);
    element.appendChild(drawButton);
    element.appendChild(pinButton);

    super({
      element: element,
      target: options.target,
    });

    this.colorSelectorControl = new ColorSelectorControl();

    this.handleMoveModeClick = this.handleMoveModeClick.bind(this)
    this.handleDrawModeClick = this.handleDrawModeClick.bind(this)
    this.handlePinModeClick = this.handlePinModeClick.bind(this)
    this.dropPin = this.dropPin.bind(this);

    pointerButton.addEventListener("click", this.handleMoveModeClick, false);
    drawButton.addEventListener("click", this.handleDrawModeClick, false);
    pinButton.addEventListener("click", this.handlePinModeClick, false);
  }

  handleMoveModeClick() {
    if (this.getMode() == MODE_MOVE) {
      return;
    }

    this.setMode(MODE_MOVE);
  }

  handleDrawModeClick() {
    if (this.getMode() == MODE_DRAW) {
      return;
    }

    this.setMode(MODE_DRAW);
  }

  handlePinModeClick() {
    if (this.getMode() == MODE_PIN) {
      return;
    }

    this.setMode(MODE_PIN);
  }

  dropPin = function (event) {
    const iconFeature = new Feature({
      geometry: new Point(event.coordinate),
    });
    const iconStyle = new Style({
      image: new Icon({
        anchor: [0.5, 1],
        anchorXUnits: "fraction",
        anchorYUnits: "fraction",
        src: "/images/icons/eye-sauron-icon.png",
      }),
    });
    iconFeature.setStyle(iconStyle);

    const vectorSource = this.getMap().getLayers().item(1).getSource();
    vectorSource.addFeature(iconFeature);
  };

  handleDrawEnd(event) {
    const color = this.getMap().get("drawColor") || "black";

    event.feature.setStyle(new Style({
      stroke: new Stroke({ color: color, width: 1 })
    }));
  }

  setMode(mode) {
    if (mode == MODE_DRAW) {
      this.getMap().addInteraction(this.getDraw());
      this.getMap().addControl(this.colorSelectorControl)
    } else {
      this.getMap().removeInteraction(this.getDraw());
      this.getMap().removeControl(this.colorSelectorControl);
    }

    if (mode == MODE_PIN) {
      this.getMap().on("click", this.dropPin);
    } else {
      this.getMap().un("click", this.dropPin);
    }

    this.getMap().set("mode", mode);
  }

  getMode() {
    return this.getMap().get("mode") || MODE_MOVE;
  }

  getDraw() {
    if (this.getMap().get("draw")) {
      return this.getMap().get("draw");
    } else {
      const vectorSource = this.getMap().getLayers().item(1).getSource();
      const draw = new Draw({
        source: vectorSource,
        type: "LineString",
        freehand: true,
        style: {
          "stroke-color": "black",
          "stroke-width": 1.5,
        }
      });
      draw.addEventListener("drawend", this.handleDrawEnd.bind(this));
      this.getMap().set("draw", draw)

      return draw;
    }
  }
}

export default ModeControl;
