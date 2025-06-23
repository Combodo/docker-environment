const eOptions = document.getElementById('options_block');
const eVersions = document.getElementById('versions_block');
const eVersionsList  = document.getElementById('versions_list');
const eVersionsBtnCreate  = document.getElementById('versions_btn_create');
const eVersionsBtnDeleteGroup  = document.getElementById('versions_btn_delete_group');
const eVersionsBtnDelete  = document.getElementById('versions_btn_delete');
const eVersionsBtnDeleteStop  = document.getElementById('versions_btn_delete_stop');
const eVersionAddForm  = document.getElementById('version_add_form');
const eVersionAddFormInput = document.getElementById('version_add_form_number');
const eVersionAddFormAlert = document.getElementById('version_add_form_alert');
const eVersionAddFormBtnConfirm  = document.getElementById('version_add_form_btn_confirm');
const eVersionAddFormBtnCancel  = document.getElementById('version_add_form_btn_cancel');
const eOptionsBtnSave = document.getElementById('options_btn_save');
const eVersionTemplate = document.getElementById('version_template');
const eUrlFilterInput = document.getElementById('url_filter_input');

// script variables
let optionsInitial;
let options;

// load current configuration
chrome.runtime.sendMessage({type: 'get_configuration'}).then((stored_options) => {
    optionsInitial = structuredClone(stored_options);
    options = stored_options;
    loadVersionsList(options.php_version_installed);
    eUrlFilterInput.value = options.url_filter;
});

// button create
eVersionsBtnCreate.addEventListener('click', (event) => {
    startAddVersionEdition();
});

// button confirm
eVersionAddFormBtnConfirm.addEventListener('click', (event) => {
    addVersion();
});

// button cancel
eVersionAddFormBtnCancel.addEventListener('click', (event) => {
    stopAddVersionEdition();
});

// button delete
eVersionsBtnDelete.addEventListener('click', (event) => {
    deleteSelection();
});

// button delete stop
eVersionsBtnDeleteStop.addEventListener('click', (event) => {
    stopDeletion();
});

// url filter input change
eUrlFilterInput.addEventListener('keyup', (event) => {
    updateURLFilter();
});

// button save
eOptionsBtnSave.addEventListener('click', (event) => {
    saveOptions();
});


/**
 * Add a PHP version to the list.
 */
function addVersion() {

    // regex to validate version format
    const regex = RegExp(/(\d+).(\d+)/);

    // execute regex
    const res = regex.exec(eVersionAddFormInput.value);

    if(res != null){

        // compute version id
        const id = res[1] + res[2];

        if(options.php_version_installed[id] === undefined){

            // add version
            options.php_version_installed[id] = eVersionAddFormInput.value;
            options.php_version_installed = sortVersions(options.php_version_installed);

            // reload list
            loadVersionsList(options.php_version_installed);

            // close edition
            stopAddVersionEdition();
            updateButtons();
            eVersionAddFormInput.value = '';
        }
        else{
            displayError('This version already exists.');
        }
    }
    else
    {
        displayError('Invalid version format.');
    }
}

/**
 * Update url filter in options.
 *
 */
function updateURLFilter() {
    options.url_filter = eUrlFilterInput.value;
    updateButtons();
}

/**
 * Load the list of PHP versions into the options page.
 *
 * @param versions
 */
function loadVersionsList(versions){
    eVersionsList.replaceChildren();
    for (const [version, label] of Object.entries(versions)) {
        createVersionsListElement(version, label);
    }
}

/**
 * Create a list element for a PHP version.
 *
 * @param version
 * @param label
 */
function createVersionsListElement(version, label){
    const eVersion = eVersionTemplate.content.cloneNode(true);
    const eLink = eVersion.querySelector('li');
    const eInput = eLink.querySelector('.form-check-input');
    eInput.id = version;
    eInput.value = version;
    const eLabel = eLink.querySelector('.form-check-label');
    eLabel.setAttribute('for', version);
    eLabel.innerHTML = label;
    eLink.dataset.version = version;

    eInput.addEventListener('change', (event) => {
        updateButtons();
    });

    eVersionsList.append(eLink);
}

/**
 * Sort PHP versions by their keys.
 *
 * @param versions versions to sort
 * @returns {{}}
 */
function sortVersions(versions){
    const sortedKeys = Object.keys(versions).sort(function(a, b) {
        return a < b ? -1 : (a > b ? 1 : 0);
    });
    const sortedArray = {};
    sortedKeys.forEach(key => {
        sortedArray[key] = versions[key];
    });
    return sortedArray;
}

/**
 * Display a form error message.
 *
 * @param message
 */
function displayError(message) {
    eVersionAddFormAlert.textContent = message;
    eVersionAddFormAlert.classList.toggle('d-none', false);
}

/**
 * Clear the form error message.
 *
 */
function clearError() {
    eVersionAddFormAlert.textContent = '';
    eVersionAddFormAlert.classList.toggle('d-none', true);
}

/**
 * Open the edition mode for the PHP versions.
 */
function startAddVersionEdition(){
    eOptions.classList.toggle('d-none', true);
    eVersionAddForm.classList.toggle('d-none', false);
}

/**
 * Close the edition mode for the PHP versions.
 */
function stopAddVersionEdition(){
    eOptions.classList.toggle('d-none', false);
    eVersionAddForm.classList.toggle('d-none', true);
    clearError();
}

/**
 * Update the visibility of the buttons based on the selected versions.
 */
function updateButtons() {
    const length = eVersionsList.querySelectorAll('input:checked').length;
    if(length === 0){
        eVersionsBtnDeleteGroup.classList.toggle('d-none', true);
    }
    else if(Object.keys(options.php_version_installed).length === length){
        eVersionsBtnDelete.classList.toggle('disabled', true);
    }
    else{
        eVersionsBtnDeleteGroup.classList.toggle('d-none', false);
        eVersionsBtnDelete.classList.toggle('disabled', false);
    }
    eVersionsBtnCreate.classList.toggle('d-none', eVersionsList.querySelectorAll('input:checked').length !== 0);
    eOptionsBtnSave.classList.toggle('d-none', JSON.stringify(optionsInitial) === JSON.stringify(options));
}

/**
 * Delete selection.
 */
function deleteSelection() {
    eVersions.querySelectorAll('input:checked').forEach(e => {
        e.closest('li').remove();
        delete options.php_version_installed[e.value];
    });
    updateButtons();
}

/**
 * Stop the deletion process by unchecking all selected versions.
 *
 */
function stopDeletion(){
    eVersions.querySelectorAll('input:checked').forEach(e => {
        e.checked = false;
    });
    updateButtons();
}

/**
 *
 * @returns {Promise<*>}
 */
async function getOptionsToSave(){
    let result = {...options};
    const data = await chrome.storage.sync.get('php_version');
    if(options.php_version_installed[data.php_version] === undefined){
        result.php_version = Object.keys(options.php_version_installed)[0];
    }
    else{
        delete result.php_version;
    }
    result.php_version_installed = JSON.stringify(options.php_version_installed);
    return result;
}

/**
 * Save the options to the storage.
 *
 */
function saveOptions() {

    getOptionsToSave().then((optionsToSave) => {
        chrome.storage.sync.set(optionsToSave).then(() => {
            optionsInitial = structuredClone(options);
            updateButtons();
        });
    });
}

