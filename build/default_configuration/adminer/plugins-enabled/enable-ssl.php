<?php
require_once('plugins/login-ssl.php');

/**
 * @param string $name
 * @return string
 */
function required_env($name) {
    $value = getenv($name);
    if ($value === false || $value === '') {
        throw new RuntimeException("Missing required environment variable: " . $name);
    }

    return $value;
}

$key = required_env('DB_SSL_KEY');
$cert = required_env('DB_SSL_CERT');
$ca = required_env('DB_SSL_CA');

/**
 * @param array array("key" => filename, "cert" => filename, "ca" => filename)
 */
return new AdminerLoginSsl(
    $ssl = [
        'key' => $key,
        'cert' => $cert,
        'ca' => $ca,
        'verify' => false,
    ]
);