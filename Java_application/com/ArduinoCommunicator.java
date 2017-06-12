/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump.com;

import arduinocom.*;
import com.fazecast.jSerialComm.SerialPort;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import javafx.collections.ObservableList;

/**
 *
 * @author Adam
 */
public class ArduinoCommunicator{
    
    private HashMap<String,Arduino> arduinos;
    private PortList ports;

    public ArduinoCommunicator(){
        this.arduinos = new HashMap<String,Arduino>();
        this.ports = new PortList();
        ports.refreshList();
        System.out.println("Arcom created.");
 
    }
    
    public ArrayList<String> getPortNameList(){
       return  ports.getPortNamesList();
    }
    
    public SerialPort [] getSerialPorts(){
        return ports.getPortNames();
    }
    
    public ArrayList<String> getConnectedPorts() {
        ArrayList<String> list = new ArrayList<>();
        list.addAll(this.arduinos.keySet());
        return list;
    }
    //returns currently available unconnected ports
    public ArrayList<String> getAvailablePorts(){
        ArrayList<String> connected = getConnectedPorts();
        ArrayList<String> available = ports.getPortNamesList();
        available.removeAll(connected);
        return available;
    }
    
    
    public void refresh(){
        this.ports.refreshList();
        ArrayList<String> portsConnected = getPortNameList();
        Set<String> arduinosConnected = arduinos.keySet();
        for(String port : arduinosConnected){
            if(!portsConnected.contains(port)){
                arduinos.remove(port);
            }
        }
    }
    
    public boolean connect(String port,int baudRate){
        Arduino arduino= new Arduino(port,baudRate);
       Boolean success = arduino.openConnection();  
       if(success){
        arduinos.put(port, arduino);
       }
       return success;  
    }
    
    public void disconnect(String port){
        Arduino arduino = arduinos.get(port);
        arduino.closeConnection();
        arduinos.remove(port);
    }
    
    public Arduino getArduino(String port){
        Arduino arduino = arduinos.get(port);
        return arduino;
    }


    
    
    
    
    
    
    
    
}
