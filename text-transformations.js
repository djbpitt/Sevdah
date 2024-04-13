"use strict";

function textTransformationsInit() {
  var languageToggles = document.getElementsByClassName("languageToggle")
  for (var i = 0, len = languageToggles.length; i < len; i++) {
    languageToggles[i].addEventListener("click", changeStyle, false);
  }
}

function changeStyle(e) {
  console.log(this);
  var lg = this.dataset.language;
  var style = this.dataset.style;
  if ([ 'slavic', 'turkic'].includes(lg)) {
    var targets = document.getElementsByClassName(lg);
  } else {
    var targets = document.querySelectorAll(".germanic, .greek, .hungarian, .italian, .latin");
  }
  console.log(targets);
  for (var i = 0, len = targets.length; i < len; i++) {
    if (style == 'clear') {[ 'italic', 'bold', 'under'].forEach(function (j) {
        targets[i].classList.remove(j);
      })
    } else {
      targets[i].classList.add(style);
    }
  }
}

document.addEventListener('DOMContentLoaded', textTransformationsInit);