/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump;
import syringepump.com.ArduinoCommunicator;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;



/**
 *
 * @author Adam
 */
public class ConnectMenuController implements Initializable {
    
    
    
    private ArduinoCommunicator arcom;
   
    private MenuController menu;
            
    private Main main;
    
    private SerialReader reader;
    
    @FXML
    public Button btnclose;
    @FXML
    private ListView<String> toConnect;
    
    @FXML
    private ListView<String> connected;
    
            
    @FXML
    private void btnConnectHandler(ActionEvent event) {
        System.out.println("Connect!");
        String selected = toConnect.getSelectionModel().getSelectedItem();
        if(selected !=null && arcom.connect(selected, 9600)){
            System.out.println("Succesfully connected to the port " + selected);
            refreshLists();
            this.reader = new SerialReader(this.arcom.getArduino(selected),menu.getMonitor());
            reader.start();
        }

    }
    @FXML
    private void btnDisconnectHandler(ActionEvent event) {
        System.out.println("Disconnect!");
        String selected = connected.getSelectionModel().getSelectedItem();
        if(selected != null){
            arcom.disconnect(selected);
            System.out.println("Disconnect the port "+selected);
            refreshLists();
            menu.refreshComboBox();
            this.reader.terminate();
        }
    }
    @FXML
    private void btnRefreshHandler (ActionEvent event) {
        refreshLists();
    }
    @FXML
    private void btnCloseHandler (ActionEvent event) {
        main.hideConnectMenu();
        menu.refreshComboBox();
    }
    
    private void refreshLists(){
        System.out.println("Refresh!");
        arcom.refresh();
        toConnect.getItems().clear();
        connected.getItems().clear();
        toConnect.setItems(FXCollections.observableArrayList(arcom.getAvailablePorts()));
        connected.setItems(FXCollections.observableArrayList(arcom.getConnectedPorts()));
    }
    public void setArcom(ArduinoCommunicator arcom){
        this.arcom = arcom;
    }
    
    public void setUp(Main main, MenuController menu){
        this.main = main;
        this.menu = menu;
        this.setArcom(main.getArcom());
        refreshLists();
    }
 @Override
    public void initialize(URL url, ResourceBundle rb) {
       
    }
}