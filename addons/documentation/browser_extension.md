🔙 [Back to readme page](../../readme.md)

# Browser Extension
This extension allows you to switch between different PHP versions in your browser.\

You can easily switch PHP version you want to use by clicking the extension action button.
Select the PHP version you want to use in the extension action popup.\
You can provide a filter to limit the PHP version to a specific domain.\
You also can disable the extension with a activation switch.

![Extension Popup](/addons/documentation/images/extension_popup.png)

> [!IMPORTANT]
> This extension is unsigned, you need to load it as an unpacked extension in Chrome or install it in Firefox for developer edition.

> [!NOTE]
> You can use a public extension allowing you to add a header `x-php-version=82` for PHP 8.2 to your HTTP requests.


## Installation
Follow the corresponding instructions for your browser.

### For Chrome

In extension pages, enable `developer mode` and click on `load the unpacked extension` button.

![Extension Chrome installation](/addons/documentation/images/extension_chrome_install.png)

Choose the Chrome extension addon folder

![Extension Chrome folder](/addons/documentation/images/extension_chrome_folder.png)


### For Firefox

You need `firefox for developer edition` installed.\
In extension pages, click on the gear icon and select `Install Add-on From File`.

![Extension Firefox installation](/addons/documentation/images/extension_firefox_install.png)

Choose the Firefox extension zip in `web-ext-artifacts` folder

![Extension Firefox folder](/addons/documentation/images/extension_firefox_folder.png)


## Build
Instruction to build the browser extension when you modify it.

### For Chrome

Copy `manifest_chrome.json` content to `manifest.json`

Not build needed for Chrome, just load the unpacked extension as described previously.

### For Firefox

You need to install `web-ext` to build the extension [Official Documentation](https://extensionworkshop.com/documentation/develop/getting-started-with-web-ext/).

Copy `manifest_firefox.json` content to `manifest.json`

Run `npm install` in the extension source folder.
Run `web-ext build --overwrite-dest`

This will create a zip file in the `web-ext-artifacts` folder.

Load the new extensions in Firefox as described previously.

\
\
🔙 [Back to readme page](../../readme.md)