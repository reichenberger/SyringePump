/*
 *Arduino serial communication library
 *@Adam Polak
 */
package arduinocom;

import com.fazecast.jSerialComm.*;
import java.util.ArrayList;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;



/**
 *
 * @author Adam
 */
public class PortList {
    
    private SerialPort [] portNames;
    private ArrayList<String> portNamesList;
    private static final long serialVersionUID = 1L;
    
    public PortList(){
        this.portNames = SerialPort.getCommPorts();
    }
    
    public void refreshList(){
        this.portNames = SerialPort.getCommPorts();
        portNamesList = new ArrayList();
        for (SerialPort portName : portNames) {
            this.portNamesList.add(portName.getSystemPortName());				
        }
    }

    public SerialPort[] getPortNames() {
        return portNames;
    }

    public ArrayList<String> getPortNamesList() {
        refreshList();
        return portNamesList;
    }
    
    
}
