<?php

$allFiles = scandir('./');
$sidFiles = [];

foreach ($allFiles as $file)
{
    if (strpos($file, ".sid") !== false)
    {
        $sidFiles[] = $file;
    }
}

foreach ($sidFiles as $file)
{
    $handle = fopen($file, "r");

    $data = fread($handle, 0x7E);

    $byteArray = unpack("C*",$data);

    $startAdressHi = (int)$byteArray[0x7E];
    $startAdressLo = (int)$byteArray[0x7D];

    if (!($startAdressHi == 16 && $startAdressLo == 0))
    {
        printf("%02X%02X" . PHP_EOL, $byteArray[0x7E], $byteArray[0x7D]);

        @exec("sidreloc -p 10 -z fe-ff -s -v $file 0x1000/$file");
    }
    else
    {
        @exec("cp -f $file 0x1000/$file");
    }

    fclose($handle);
}
