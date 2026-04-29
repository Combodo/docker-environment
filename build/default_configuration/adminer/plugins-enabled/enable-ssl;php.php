<?php
require_once('plugins/login-ssl.php');

$key = $_ENV['DB_SSL_KEY'];
$cert = $_ENV['DB_SSL_CERT'];
$ca = $_ENV['DB_SSL_CA'];

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