<?php

session_start();

if (!empty($_SESSION['look'])) {
    unset($_SESSION['look']);
    
    header("Location: /list/user/");
    exit;
} else {
    session_destroy();
}

header("Location: /login/");
exit;
?>
