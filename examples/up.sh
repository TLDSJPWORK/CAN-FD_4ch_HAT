#!/bin/bash

sudo ip link set rcan3 type can bitrate 500000 sample-point 0.75 dbitrate 2000000 dsample-point 0.8 fd on
sudo ip link set rcan3 up
sudo ifconfig rcan3 txqueuelen 1000
sudo ip link set rcan2 type can bitrate 500000 sample-point 0.75 dbitrate 2000000 dsample-point 0.8 fd on
sudo ip link set rcan2 up
sudo ifconfig rcan2 txqueuelen 1000
sudo ip link set rcan1 type can bitrate 500000 sample-point 0.75 dbitrate 2000000 dsample-point 0.8 fd on
sudo ip link set rcan1 up
sudo ifconfig rcan1 txqueuelen 1000
sudo ip link set rcan0 type can bitrate 500000 sample-point 0.75 dbitrate 2000000 dsample-point 0.8 fd on
sudo ip link set rcan0 up
sudo ifconfig rcan0 txqueuelen 1000