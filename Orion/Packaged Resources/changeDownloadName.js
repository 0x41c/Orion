// First we get our button
// Then we set the text
// ezpz

(() => {
    if (window.location.href.startsWith("https://addons.mozilla.org")) {
        const button = document.getElementsByClassName('AMInstallButton-button')[0];
        if (button == null) {
            return;
        }
        const observationConfiguration = {
            attributes: true,
        }

        const observationCallback = function(mutations, observer) {
            // Gotta be a way to cut down this loop
            for (const mutation of mutations) {
                if (mutation.type === 'attributes') {
                    if (button.innerText.includes('Firefox')) {
                        button.innerText = button.innerText.replace('Firefox', 'Orion');
                    }
                }
            }
        }
        console.log(button)
        const observer = new MutationObserver(observationCallback);
        observer.observe(button, observationConfiguration);
        
        // Just to kick it off
        observationCallback([{
            type: 'attributes',
        }], null);
    }
})()
