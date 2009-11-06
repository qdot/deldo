#!/usr/bin/env python2.6
import sys
sys.path.append('/Users/qdot/git-projects/library/usr_darwin_10.5_x86/lib/python2.6/site-packages')

import time
import osc
from trancevibe import *
from contextlib import *

class DeldoServer(object):
    
    def __init__(self, tv):
        self.trancevibe = tv
        return

    @classmethod
    def create(cls, tv):
        d = DeldoServer(tv)
        d.open()
        return d

    def open(self):        
        osc.init()
        osc.listen("127.0.0.1", 9001)
        osc.bind(self.set_speed, "/deldo/speed")        
        return

    def set_speed(self, *msg):
        self.trancevibe.set_speed(msg[0][2])

    @contextmanager
    def close(self):
        osc.dontListen()
        return

def main(argv = None):
    with closing(TranceVibrator.create()) as tv:
        with closing(DeldoServer.create(tv)) as d:
            try:
                while(1):
                    time.sleep(0.1)
            except KeyboardInterrupt, e:
                pass
    return 0

if __name__ == '__main__':
    sys.exit(main())
