<?php
// Init
error_reporting(NULL);

header('Content-Type: application/json');

include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Header
// include($_SERVER['DOCUMENT_ROOT'].'/templates/admin/list_weblog.html');

$v_domain = escapeshellarg($_GET['domain']);
if ($_GET['type'] == 'access') $type = 'access';
if ($_GET['type'] == 'error') $type = 'error';

$data = exec (VESTA_CMD."v-list-web-domain-".$type."log $user ".$v_domain, $output, $return_var);

echo json_encode(
	array(
		'data' => $data
	)
);

// if ($return_var == 0 ) {
//     foreach($output as $file) {
//         echo htmlentities($file) . "\n";
//     }
// }
// echo "    </pre>\n</body>\n</html>\n";
