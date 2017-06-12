/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump;

import javafx.scene.control.TextArea;
import javafx.scene.text.TextFlow;

/**
 *
 * @author Adam
 */
public class SerialMonitor  {
    private TextArea serialMonitorArea;
    
    public SerialMonitor(TextArea serialMonitorArea){
        this.serialMonitorArea = serialMonitorArea;
    }
    
    public void appendWrite(String s){
//        this.serialMonitorArea.setStyle("-fx-text-fill: red ;") ;
        s = "w:"+s;
        this.serialMonitorArea.appendText(s);
    }
    
    public void appendRead(String s){
//        this.serialMonitorArea.setStyle("-fx-text-fill: blue ;") ;
        s = "r:"+s;
        this.serialMonitorArea.appendText(s);
    }
    
}
