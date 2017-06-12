/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump;

import arduinocom.Arduino;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.scene.control.TextArea;

/**
 *
 * @author Adam
 */
public class SerialReader extends Thread {

    private Arduino arduino;
    private SerialMonitor serialMonitor;
    private volatile boolean running = true;
    
    
    public SerialReader(Arduino arduino, SerialMonitor serialMonitor){
        this.arduino = arduino;
        this.serialMonitor = serialMonitor;
    }
    public void terminate() {
        running = false;
        System.out.println("SerialReader stopped.");
    }
    
    @Override
    public void run() {
        String s;
        long timeout = 1000;
        while(running){
            try{
                s = arduino.serialRead();
                if(s!=""){
                serialMonitor.appendRead(s);
                System.out.println("recieved" + s);
                }
                System.out.println("sleeping...");
                this.sleep(1000);
            } catch(InterruptedException e){
                System.out.println("SerialReader stopped.");
                running = false;
            }
        }
    }
    
}
