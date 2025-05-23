console.log('Background script running...');

chrome.runtime.onStartup.addListener(() => {
    console.log('Extension started');
}
);

// initialize the extension with current php version
chrome.storage.sync.get({'php_version' : '82', 'url_filter' : 'localhost:88', 'enabled' : true}).then((data) => {
    updateBadge(data.php_version, data.enabled);
    setPhpVersionHeaderRule(data.php_version, data.url_filter, data.enabled);
});

// update the extension with current php version
chrome.storage.onChanged.addListener(logStorageChange);
function logStorageChange(changes, area) {
    chrome.storage.sync.get({'php_version' : '82', 'url_filter' : 'localhost:88', 'enabled' : true}).then((data) => {
        updateBadge(data.php_version, data.enabled);
        setPhpVersionHeaderRule(data.php_version, data.url_filter, data.enabled);
    });
}

// update badge
function updateBadge(phpVersion, enabled){
    chrome.action.setBadgeText({text: enabled ? phpVersion[0] + '.' + phpVersion[1] : ''});
    chrome.action.setBadgeBackgroundColor({color: '#000000'});
    chrome.action.setIcon({path: enabled ? './images/icon_48.png' : './images/icon_48_disabled.png'});
}

// update net request dynamic rules
const allResourceTypes = Object.values(chrome.declarativeNetRequest.ResourceType);
function setPhpVersionHeaderRule(selectedVersion, urlFilter, enabled = true) {

    let addRules = [];
    if(enabled){
        addRules = [{
            id: 1,
            priority: 1,
            action: {
                type: 'modifyHeaders',
                requestHeaders: [{
                    header: 'X-PHP-Version',
                    operation: 'set',
                    value: selectedVersion.toString()
                }]
            },
            condition: {
                urlFilter: urlFilter,
                resourceTypes: allResourceTypes
            }
        }]
    }

    let removeRules =  [1];

    chrome.declarativeNetRequest.updateDynamicRules({
        addRules: addRules,
        removeRuleIds: removeRules
    });
}
