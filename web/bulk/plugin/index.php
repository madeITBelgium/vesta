<?php
// Init
error_reporting(NULL);
ob_start();
session_start();

include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Check token
if ((!isset($_POST['token'])) || ($_SESSION['token'] != $_POST['token'])) {
    header('location: /login/');
    exit();
}

$plugins = $_POST['plugin'];
$action = $_POST['action'];

if ($_SESSION['user'] == 'admin') {
    switch ($action) {
        case 'delete': $cmd='v-delete-plugin';
            break;
        case 'activate': $cmd='v-activate-plugin';
            break;
        case 'deactivate': $cmd='v-deactivate-plugin';
            break;
        default: header("Location: /list/plugin/"); exit;
    }
}

foreach ($plugins as $value) {
    $value = escapeshellarg($value);
    exec (VESTA_CMD.$cmd." ".$value, $output, $return_var);
}

header("Location: /list/plugin/");
