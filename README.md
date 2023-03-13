# spider-controller
A Raspberry Pi based linux system for driving ROS robots

I have a Teensy 3.2 setup as a native joystick.

There's a little hack in the code that when you push both left and right on the joypad buttons, it sends a keyboard `alt` keypress - this is to awaken a touchscreen when you don't have a keyboard plugged in.

## Ros component

This is a very basic joystick bridge, built on ROS2 Humble, it just publishes the joy commands to the ros subsystem.

## hardware Todo's

1. make the sd card more accesible
2. include tindie usbc charger
3. update case to suit charger
