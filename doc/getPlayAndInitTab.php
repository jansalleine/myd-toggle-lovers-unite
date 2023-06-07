#!/usr/bin/env php
<?php

$filename = 'sidlist.txt';
$fileArray = @file($filename);

$initVals = [];
$playVals = [];

foreach ($fileArray as $line)
{
    $splitLine = explode(";", $line);

    $initVals[] = trim(str_replace('$', '', $splitLine[1]));
    $playVals[] = trim(str_replace('$', '', $splitLine[2]));
}

echo 'songinit_lo:';
$i = 0;

foreach ($initVals as $initVal)
{
    if (!($i % 8))
    {
        echo PHP_EOL . '                    !byte ';
        echo '<0x' . $initVal . ', ';
    }
    else
    {
        echo '<0x' . $initVal;

        if (!(($i % 8) == 7))
        {
            echo ', ';
        }
    }
    $i++;
}

echo PHP_EOL . 'songinit_hi:';
$i = 0;

foreach ($initVals as $initVal)
{
    if (!($i % 8))
    {
        echo PHP_EOL . '                    !byte ';
        echo '>0x' . $initVal . ', ';
    }
    else
    {
        echo '>0x' . $initVal;

        if (!(($i % 8) == 7))
        {
            echo ', ';
        }
    }
    $i++;
}

echo PHP_EOL . 'songplay_lo:';
$i = 0;

foreach ($playVals as $playVal)
{
    if (!($i % 8))
    {
        echo PHP_EOL . '                    !byte ';
        echo '<0x' . $playVal . ', ';
    }
    else
    {
        echo '<0x' . $playVal;

        if (!(($i % 8) == 7))
        {
            echo ', ';
        }
    }
    $i++;
}

echo PHP_EOL . 'songplay_hi:';
$i = 0;

foreach ($playVals as $playVal)
{
    if (!($i % 8))
    {
        echo PHP_EOL . '                    !byte ';
        echo '>0x' . $playVal . ', ';
    }
    else
    {
        echo '>0x' . $playVal;

        if (!(($i % 8) == 7))
        {
            echo ', ';
        }
    }
    $i++;
}

echo PHP_EOL;
