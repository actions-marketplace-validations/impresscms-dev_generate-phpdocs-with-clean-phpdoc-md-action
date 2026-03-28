#!/usr/bin/env php
<?php

$contents = file_get_contents(dirname(__DIR__) . DIRECTORY_SEPARATOR . 'composer.json');
$composer = json_decode($contents, true);

$packages = [];
foreach ($composer['require'] as $package => $version) {
    if (
        $package === 'php' ||
        strpos($package, 'ext-') === 0 ||
        strpos($package, 'lib-') === 0 ||
        strpos($package, 'composer-') === 0
    ) {
        continue;
    }

    $packages[] =  $package . "=" . $version;
}

echo implode(" ", $packages);
