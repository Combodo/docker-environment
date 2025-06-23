const template = document.getElementById('php-version-template');
const eVersions = document.getElementById('phpVersion');
const eBtnOptions = document.getElementById('options_btn');

// store the selected php version in storage
eBtnOptions.addEventListener('click', function() {
    chrome.runtime.openOptionsPage();
});

chrome.runtime.sendMessage({type: 'get_configuration'}).then((options) => {

    document.getElementById('enabled').checked = options.enabled;

    Object.keys(options.php_version_installed).forEach(e => {
        createElement(e, options.php_version_installed[e]);
    });
    document.getElementById('phpVersion').value = options.php_version;
});

function createElement(version, label){
    const eVersion = template.content.cloneNode(true);
    const eOption = eVersion.querySelector('option');
    eOption.value = version;
    eOption.text = label;
    eVersions.append(eOption);
}

// store the selected php version in storage
document.getElementById('phpVersion').addEventListener('change', function() {
    chrome.storage.sync.set({'php_version' : this.value});
});

// store the url filter in storage
document.getElementById('enabled').addEventListener('change', function() {
    chrome.storage.sync.set({'enabled' : this.checked});
});
