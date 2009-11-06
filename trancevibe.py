#!/usr/bin/env python2.6
import sys
import os
os.environ["DYLD_LIBRARY_PATH"] = "/Users/qdot/git-projects/library/usr_darwin_10.5_x86/lib/"
sys.path.append('/Users/qdot/git-projects/library/usr_darwin_10.5_x86/lib/python2.6/site-packages')
import usb
import time
from contextlib import *

class TranceVibrator():
    #Device as retreived from the bus listing
    trancevibe_device = None
    #Handle to access the device with
    trancevibe_handle = None

    TRANCEVIBE_VENDOR_ID = 0x0b49
    TRANCEVIBE_PRODUCT_ID = 0x064f

    #Constructor
    def __init__(self):
        return

    @classmethod
    def create(cls, index = 0):
        t = TranceVibrator()
        t.open(index)
        return t

    def open(self, index = 0):
        """ Given an index, opens the related ambx device. The index refers
        to the position of the device on the USB bus. Index 0 is default, 
        and will open the first device found.

        Returns True if open successful, False otherwise.
        """
        # device_count = 0
        # for bus in usb.legacy.busses():
        #     devices = bus.devices
        #     for dev in devices:
        #         if dev.idVendor == self.TRANCEVIBE_VENDOR_ID and dev.idProduct == self.TRANCEVIBE_PRODUCT_ID :
        #             if device_count == index:
        #                 self.trancevibe_device = dev
        #                 break;
        #             device_count += 1            
        self.trancevibe_device = usb.core.find(idVendor = self.TRANCEVIBE_VENDOR_ID, 
                                               idProduct = self.TRANCEVIBE_PRODUCT_ID)
        if self.trancevibe_device is None:
            return False
        return True
    
    @contextmanager
    def close(self):
        """Closes the trancevibe device currently held by the object, 
        if it is open."""
        if self.trancevibe_device is not None:
            self.trancevibe_device = None

    def set_speed(self, speed):
        self.trancevibe_device.ctrl_transfer(
            usb.ENDPOINT_OUT | usb.TYPE_VENDOR | usb.RECIP_INTERFACE,
            1,
            speed,
            0,
            []
            )

def main(argv=None):
    with closing(TranceVibrator.create()) as tv:
        tv.set_speed(255)
        time.sleep(0.5)
        tv.set_speed(0)
    
if __name__ == "__main__":
        
    sys.exit(main())

