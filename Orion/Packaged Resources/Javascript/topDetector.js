let ___document_scrolled_down = false;
let orig_onscroll = document.onscroll;
let onscroll_hook = () => {
  if (document.documentElement.scrollTop === 0) {
    ___document_scrolled_down = false;
    console.log("top");
  } else {
    if (!___document_scrolled_down) {
      ___document_scrolled_down = true;
    }
  }
  if (orig_onscroll != null) orig_onscroll();
};

let mutationObserver = new MutationObserver((mutation) => {
  if (mutation.type == "attribute") {
    orig_onscroll = document.onscroll;
    document.onscroll = onscroll_hook;
  }
});

mutationObserver.observe(document, {
  attributeFilter: ["onscroll"]
});
