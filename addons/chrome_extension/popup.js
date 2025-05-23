
// set the popup php select to the current php version
chrome.storage.sync.get({'php_version' : '82', 'url_filter' : 'localhost:88', 'enabled' : true}).then((data) => {
    console.log('storage');
    document.getElementById('phpVersion').value = data.php_version;
    document.getElementById('urlFilter').value = data.url_filter;
    document.getElementById('enabled').checked = data.enabled;
});

// store the selected php version in storage
document.getElementById('phpVersion').addEventListener('change', function() {
    chrome.storage.sync.set({'php_version' : this.value});
});

// store the url filter in storage
document.getElementById('urlFilter').addEventListener('change', function() {
    chrome.storage.sync.set({'url_filter' : this.value});
});

// store the url filter in storage
document.getElementById('enabled').addEventListener('change', function() {
    chrome.storage.sync.set({'enabled' : this.checked});
});
