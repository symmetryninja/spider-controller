# Some hacks for teensy Teensy 

Hacks are required to have the device report exactly what I want it to.

I figured this out [here on hamaluik.blog](https://github.com/hamaluik/blog.hamaluik.ca/blob/06a8439fae50b15cb966d33f3b0fdef9378a5c72/posts/2013-10-26-making-a-custom-teensy3-hid-joystick.md)

And used some values from the [freebsd diary usb HID here](https://www.freebsddiary.org/APC/usb_hid_usages.php)

Edits are all in the `Arduino/hardware/teensy/cores/teensy3` folder.

## Changes for file: `usb_desc.h`

After `#elif defined(USB_HID)` block:

```c++
#elif defined(USB_ARCADE)
	#define VENDOR_ID   0x16C0
	#define PRODUCT_ID	0x0489
	#define DEVICE_CLASS	0x03
	#define MANUFACTURER_NAME {'B', 'l', 'a', 'z', 'i', 'n', 'g', 'M', 'a', 'm', 'm', 'o', 't', 'h'}
	#define MANUFACTURER_NAME_LEN 14
	#define PRODUCT_NAME	{'W', 'e', 'd', 'c', 'a', 'd', 'e', ' ', 'C', 'o', 'n', 't', 'r', 'o', 'l', 'l', 'e', 'r'}
	#define PRODUCT_NAME_LEN  18
	#define EP0_SIZE			  64
	#define NUM_ENDPOINTS		 2
	#define NUM_USB_BUFFERS	   30
	#define NUM_INTERFACE		 1
	#define ARCADE_INTERFACE	  0 // Joystick
	#define ARCADE_ENDPOINT	   1
	#define ARCADE_SIZE		   16
	#define ARCADE_INTERVAL	   1
	#define ARCADE_DESC_OFFSET  (9)
	#define CONFIG_DESC_SIZE  (9 + 9+9+7)
	#define ENDPOINT1_CONFIG  ENDPOINT_TRANSIMIT_ONLY
```

## Changes for file: `usb_desc.c`

After first instance of `#endif // JOYSTICK_INTERFACE`

```c++
#ifdef ARCADE_INTERFACE
static uint8_t arcade_report_desc[] = {
	0x05, 0x01,					// USAGE_PAGE (Generic Desktop)
	0x09, 0x04,					// USAGE (Joystick)
	0xa1, 0x01,					// COLLECTION (Application)
	0x09, 0x04,					//   USAGE (Joystick)
	0xa1, 0x00,					//   COLLECTION (Physical)
	0x09, 0x30,					//	 USAGE (X)
	0x09, 0x31,					//	 USAGE (Y)
	0x09, 0x33,					//	 USAGE (Rx)
	0x09, 0x34,					//	 USAGE (Ry)
	0x75, 0x08,					//	 REPORT_SIZE (8)
	0x95, 0x04,					//	 REPORT_COUNT (4)
	0x45, 0x7f,					//	 PHYSICAL_MAXIMUM (127)
	0x35, 0x81,					//	 PHYSICAL_MINIMUM (-127)
	0x81, 0x02,					//	 INPUT (Data,Var,Abs)
	0x05, 0x09,					//	 USAGE_PAGE (Button)
	0x19, 0x01,					//	 USAGE_MINIMUM (Button 1)
	0x29, 0x10,					//	 USAGE_MAXIMUM (Button 16)
	0x15, 0x00,					//	 LOGICAL_MINIMUM (0)
	0x25, 0x01,					//	 LOGICAL_MAXIMUM (1)
	0x75, 0x01,					//	 REPORT_SIZE (1)
	0x95, 0x10,					//	 REPORT_COUNT (16)
	0x81, 0x02,					//	 INPUT (Data,Var,Abs)
	0xc0,						//   END_COLLECTION
	0xc0						// END_COLLECTION
};
#endif
```

After second instance of `#endif // JOYSTICK_INTERFACE`

```c++
#ifdef ARCADE_INTERFACE
static uint8_t arcade_report_desc[] = {
	0x05, 0x01,					// USAGE_PAGE (Generic Desktop)
	0x09, 0x04,					// USAGE (Joystick)
	0xa1, 0x01,					// COLLECTION (Application)
	0x09, 0x04,					//   USAGE (Joystick)
	0xa1, 0x00,					//   COLLECTION (Physical)
	0x09, 0x30,					//	 USAGE (X)
	0x09, 0x31,					//	 USAGE (Y)
	0x09, 0x33,					//	 USAGE (Rx)
	0x09, 0x34,					//	 USAGE (Ry)
	0x75, 0x08,					//	 REPORT_SIZE (8)
	0x95, 0x04,					//	 REPORT_COUNT (4)
	0x45, 0x7f,					//	 PHYSICAL_MAXIMUM (127)
	0x35, 0x81,					//	 PHYSICAL_MINIMUM (-127)
	0x81, 0x02,					//	 INPUT (Data,Var,Abs)
	0x05, 0x09,					//	 USAGE_PAGE (Button)
	0x19, 0x01,					//	 USAGE_MINIMUM (Button 1)
	0x29, 0x10,					//	 USAGE_MAXIMUM (Button 16)
	0x15, 0x00,					//	 LOGICAL_MINIMUM (0)
	0x25, 0x01,					//	 LOGICAL_MAXIMUM (1)
	0x75, 0x01,					//	 REPORT_SIZE (1)
	0x95, 0x10,					//	 REPORT_COUNT (16)
	0x81, 0x02,					//	 INPUT (Data,Var,Abs)
	0xc0,						//   END_COLLECTION
	0xc0						// END_COLLECTION
};
#endif
```

near the bottom of the file, add (just below the #ifdef JOYSTICK_INTERFACE ... #endif section)

```c++
#ifdef ARCADE_INTERFACE
		{0x2200, ARCADE_INTERFACE, arcade_report_desc, sizeof(arcade_report_desc)},
		{0x2100, ARCADE_INTERFACE, config_descriptor+ARCADE_DESC_OFFSET, 9},
#endif
```

## Changes for file: `usb_inst.cpp`

Below the `#ifdef JOYSTICK_INTERFACE` block

```c++
#ifdef USB_ARCADE
usb_arcade_class Arcade;
uint8_t usb_arcade_class::auto_send = 0;
#endif
```

## Changes for file: `WProgram.h`

Below `#include "usb_joystick.h"`

```c++
#include "usb_arcade.h"
```

Finally, in order to actually make the Arduino environment use the new arcade descriptors, add the following lines to the file Arduino/hardware/teensy/boards.txt (after the `teensy31.menu.usb.flightsim` entries):

```
teensy3.menu.usb.arcade.name=Wedcade Controller
teensy3.menu.usb.arcade.build.define0=-DUSB_ARCADE
teensy3.menu.usb.arcade.fake_serial=teensy_gateway
```

## Extra files
Copy `usb_arcade.h` & `usb_arcade.c` to `Arduino/hardware/teensy/cores/teensy3` folder.