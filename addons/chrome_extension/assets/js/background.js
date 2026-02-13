
// options definition
const optionsDTO = {
    php_version: '82',
    url_filter: 'localhost',
    enabled: 'true',
    php_version_installed: '{"74":"7.4","80":"8.0","81":"8.1","82":"8.2","83":"8.3","84":"8.4","85":"8.5"}'
};

// update badge from stored options
updateBadgeFromStoredOptions();

chrome.runtime.onStartup.addListener(() => {
    // update badge from stored options
    updateBadgeFromStoredOptions();
});

// update when storage changes
chrome.storage.onChanged.addListener(() => {
    updateBadgeFromStoredOptions();
});

// messaging
chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {

        switch(request.type) {

            case 'get_configuration':
                readOptionsFromLocalStorage().then((options) => {
                    sendResponse(options);
                });
                return true;


        }
    }
);

function updateBadgeFromStoredOptions() {
    readOptionsFromLocalStorage().then((data) => {
        updateBadge(data.php_version, data.enabled);
        setPhpVersionHeaderRule(data.php_version, data.url_filter, data.enabled);
    });
}

function updateBadge(phpVersion, enabled){
    chrome.action.setBadgeText({text: enabled ? phpVersion[0] + '.' + phpVersion[1] : ''});
    chrome.action.setBadgeBackgroundColor({color: '#000000'});
    chrome.action.setIcon({path: enabled ? '/assets/images/icon_48.png' : '/assets/images/icon_48_disabled.png'});
}

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
                resourceTypes: Object.values(chrome.declarativeNetRequest.ResourceType)
            }
        }]
    }

    let removeRules =  [1];

    chrome.declarativeNetRequest.updateDynamicRules({
        addRules: addRules,
        removeRuleIds: removeRules
    });
}

async function readOptionsFromLocalStorage(options) {
    options = await chrome.storage.sync.get(optionsDTO);
    options.php_version_installed = JSON.parse(options.php_version_installed);
    return options;
}

