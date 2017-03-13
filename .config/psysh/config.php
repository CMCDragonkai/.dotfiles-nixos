<?php

$composer_autoloader = getcwd() . '/vendor/autoload.php';

if (is_readable($composer_autoloader)) {
    $defaultIncludes = [ $composer_autoloader ];
} else {
    $defaultIncludes = [];
}

return [
    'historySize' => 0,
    'eraseDuplicates' => true,
    'defaultIncludes' => $defaultIncludes,
];
