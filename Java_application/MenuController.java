/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump;

import syringepump.com.ArduinoCommunicator;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.text.TextFlow;

/**
 *
 * @author Adam
 */
public class MenuController implements Initializable {

    private ArduinoCommunicator arcom;

    private Main main;

    @FXML
    private ComboBox<String> ports;

    @FXML
    private TextField txtRpm;

    @FXML
    private TextField txtSteps;
    @FXML
    private TextField txtSpeed;
    @FXML
    private TextField txtVolume;

    @FXML
    private Slider sliderRpmDir;

    @FXML
    private Label labelRpmDir;

    @FXML
    private TextArea serialMonitorArea;
    @FXML
    private TextField txtSerialMonitorSend;
    @FXML
    private Button btnUp;
    @FXML
    private Button btnDown;
    
    private SerialMonitor serialMonitor;


        @Override
    public void initialize(URL url, ResourceBundle rb) {

    }
    public void setUp(Main main) {
        this.main = main;
        setArcom(this.main.getArcom());
        refreshComboBox();
        setListeners();
        this.serialMonitor = new SerialMonitor(this.serialMonitorArea);
        serialMonitor.appendRead("Listening.\n");
        
    }
    
    private void setListeners(){
//         txtRpm.textProperty().addListener(new ChangeListener<String>() {
//            @Override
//            public void changed(final ObservableValue<? extends String> observable, final String oldValue, final String newValue) {
//                txtSpeed.setText(newValue);
//            }
//        });
//        txtSteps.textProperty().addListener(new ChangeListener<String>() {
//            @Override
//            public void changed(final ObservableValue<? extends String> observable, final String oldValue, final String newValue) {
//                txtVolume.setText(newValue);
//            }
//        });
        sliderRpmDir.valueProperty().addListener(new ChangeListener() {

            @Override
            public void changed(ObservableValue arg0, Object arg1, Object arg2) {
                labelRpmDir.textProperty().setValue(
                        String.valueOf((int) sliderRpmDir.getValue()));

            }
        });
        btnUp.pressedProperty().addListener(new ChangeListener<Boolean>() {

            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                if(newValue){
                    String selected = ports.getSelectionModel().getSelectedItem();
                    if (checkPort(selected)) {
                        String message = "U" + labelRpmDir.getText();
                        arcom.getArduino(selected).serialWrite(message);
                        serialMonitor.appendWrite(message);
                    }
                }else{
                    String selected = ports.getSelectionModel().getSelectedItem();
                    arcom.getArduino(selected).serialWrite("$");
                    serialMonitor.appendWrite("$\n");
                }
            }
        });
        
        btnDown.pressedProperty().addListener(new ChangeListener<Boolean>() {

            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                if(newValue){
                    String selected = ports.getSelectionModel().getSelectedItem();
                    if (checkPort(selected)) {
                        String message = "D" + labelRpmDir.getText();
                        arcom.getArduino(selected).serialWrite(message);
                        serialMonitor.appendWrite(message);
                    }
                }else{
                    String selected = ports.getSelectionModel().getSelectedItem();
                    arcom.getArduino(selected).serialWrite("$");
                    serialMonitor.appendWrite("$\n");
                }
            }
        });
    }

    public void refreshComboBox() {
        ports.setItems(FXCollections.observableArrayList(arcom.getConnectedPorts()));
        ports.getSelectionModel().selectFirst();

    }
     public SerialMonitor getMonitor(){
        return this.serialMonitor;
    }

    @FXML
    void btnConnHandler(ActionEvent event) {
        main.showConnectMenu();
    }

    @FXML
    void btnSendDataHandler(ActionEvent event) {
        arcom.refresh();
        String selected = ports.getSelectionModel().getSelectedItem();
        if (checkPort(selected)) {
            String message = "F" + txtRpm.getText() + "V" + txtSteps.getText()+"$";
            System.out.println(message);
            arcom.getArduino(selected).serialWrite(message);
            serialMonitor.appendWrite(message + "\n");
        }
    }

    @FXML
    void btnSendSerialMonitorHandler(ActionEvent event) {
        sendSerialMonitorData();
        
    }
    @FXML
    void btnSendSerialMonitorKeyHandler(KeyEvent event){
        if(event.getCode() == KeyCode.ENTER){
            sendSerialMonitorData();
        }
    }
    
    @FXML
    void menuPrefHandler(ActionEvent event){
        
    }
    

    private void sendSerialMonitorData(){
        String selected = getSelectedPort();
        if (checkPort(selected)) {
            String message = txtSerialMonitorSend.getText();
            serialMonitor.appendWrite(message + "\n");
            arcom.getArduino(selected).serialWrite(message);
            System.out.println(message);
//            String recieved = arcom.getArduino(selected).serialRead(message.length());
//            serialMonitor.appendWrite("r: " + recieved + "\n");
        }
    }
    
    
        public void setArcom(ArduinoCommunicator arcom) {
        this.arcom = arcom;
    }

    
    
    @FXML
    void menuExitHandler(ActionEvent event) {
        Platform.exit();
    }

    private String getSelectedPort() {
        return ports.getSelectionModel().getSelectedItem();
    }
    

    private boolean checkPort(String port) {
        arcom.refresh();
        boolean out = arcom.getConnectedPorts().contains(port);
        if (!out) {
            System.err.println("Device is disconnected!");
            Alert alert = new Alert(AlertType.ERROR);
            alert.setTitle("Connection Error");
            alert.setHeaderText(null);
            alert.setContentText("Device is disconnected!");
            
            alert.showAndWait();
            refreshComboBox();
        }
        return out;
    }



}
