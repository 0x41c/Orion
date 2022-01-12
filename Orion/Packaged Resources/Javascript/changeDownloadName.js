// First we get our button
// Then we set the text
// ezpz

(() => {
    const button = document.getElementsByClassName('AMInstallButton-button')[0];
    if (button == null) return;
    button.innerText = button.innerText.replace('Firefox', 'Orion');
})()
