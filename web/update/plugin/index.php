<?php
// Init
error_reporting(NULL);
ob_start();
session_start();
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Check token
if ((!isset($_GET['token'])) || ($_SESSION['token'] != $_GET['token'])) {
    header('location: /login/');
    exit();
}

if ($_SESSION['user'] == 'admin') {
    if (!empty($_GET['plugin'])) {
        $v_plugin = escapeshellarg($_GET['plugin']);
        exec (VESTA_CMD."v-update-plugin ".$v_plugin, $output, $return_var);
    }

    if ($return_var != 0) {
        $error = implode('<br>', $output);
        if (empty($error)) $error = 'Error: '.$v_plugin.' update failed';
            $_SESSION['error_msg'] = $error;
    }
    unset($output);
}

header("Location: /list/plugin/");
exit;
