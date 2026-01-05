🔙 [Back to readme page](../../readme.md)
# Troubleshooting

## DNS lookup failure for: php
This error occurs when you are using a web server container in automatic mode (ports 88/443) and the `X-PHP-Version` header is not set in the request.
  * If you are accessing the application through a browser, please install the [browser extension](browser_extension.md) to set the `X-PHP-Version` header.
  * If you are using a tool like Postman or cURL, please add the `X-PHP-Version` header with the desired PHP version (e.g., `82` for PHP 8.2).
\
\
🔙 [Back to readme page](../../readme.md)