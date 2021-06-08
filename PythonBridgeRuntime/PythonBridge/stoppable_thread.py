import threading

class StoppableThread(threading.Thread):   
    def __init__(self, loop_func, setup_func): 
        threading.Thread.__init__(self) 
        self._stop_event = threading.Event()
        self.daemon = True
        self.loop_func = loop_func
        self.setup_func = setup_func
  
    # function using _stop function 
    def stop(self): 
        self._stop_event.set() 
  
    def stopped(self): 
        return self._stop_event.isSet() 
  
    def run(self): 
        self.setup_func()
        while True: 
            if self.stopped(): 
                return
            self.loop_func()

