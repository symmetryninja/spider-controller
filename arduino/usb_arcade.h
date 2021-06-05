// usb_arcade.h
#ifndef _USB_ARCADE_H_
#define _USB_ARCADE_H_

#if defined(USB_ARCADE)

#include <inttypes.h>

// C language implementation
#ifdef __cplusplus
extern "C" {
#endif
int usb_arcade_send(void);
// we have packets that are 6 bytes long
extern uint8_t usb_arcade_data[6];
#ifdef __cplusplus
}
#endif

// C++ interface
#ifdef __cplusplus
class usb_arcade_class
{
private:
	static uint8_t auto_send;

public:
	void button(uint8_t button, bool val) {
		if (--button >= 16) return;
		if (val) usb_arcade_data[button >= 8 ? 5 : 4] |= (1 << (button >= 8 ? (button - 8) : button));
		else usb_arcade_data[button >= 8 ? 5 : 4] &= ~(1 << (button >= 8 ? (button - 8) : button));
		if(auto_send) usb_arcade_send();
	}

	void axis(uint8_t axis, int8_t val) {
		if(axis >= 4) return;
		if(val > 0) usb_arcade_data[axis] = 127;
		else if(val < 0) usb_arcade_data[axis] = -127;
		else usb_arcade_data[axis] = 0;
		if(auto_send) usb_arcade_send();
	}

	void setAutoSend(bool send) {
		auto_send = send;
	}

	void send() {
		usb_arcade_send();
	}
};
extern usb_arcade_class Arcade;

#endif // __cplusplus
#endif // USB_ARCADE
#endif // _USB_ARCADE_H_