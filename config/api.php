<?php

$ip = $_SERVER['REMOTE_ADDR'];

$ar = array(
    "ip" => $ip
);
echo json_encode($ar);
?>
