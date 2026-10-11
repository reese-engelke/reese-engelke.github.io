function openFullscreen(elem) {
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
  } else if (elem.webkitRequestFullscreen) {
    elem.webkitRequestFullscreen();
  } else if (elem.msRequestFullscreen) {
    elem.msRequestFullscreen();
  }

  if (elem.tagName === "VIDEO") {
    elem.controls = true;
    elem.play();
  }
}

document.addEventListener("fullscreenchange", () => {
  if (!document.fullscreenElement) {
    document.querySelectorAll("video").forEach((video) => {
      video.controls = false;
    });
  }
});
