import { Control } from "ol/control";

class ColorSelectorControl extends Control {
  constructor(opt_options) {
    const options = opt_options || {};

    const colorInput = document.createElement("input");
    colorInput.className = "w-6"
    colorInput.setAttribute("type", "color")

    const element = document.createElement("div");
    element.className = "top-20 right-2 ol-unselectable ol-control";
    element.appendChild(colorInput);

    super({
      element: element,
      target: options.target,
    });

    this.handleColorChange = this.handleColorChange.bind(this);

    colorInput.addEventListener("change", this.handleColorChange, false)
  }

  handleColorChange(event) {
    this.getMap().set("drawColor", event.srcElement.value);
  }
}

export default ColorSelectorControl;
