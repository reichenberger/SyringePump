/*
 *Syringe Pump control application
 *@Adam Polak
 */
package syringepump;

import syringepump.com.ArduinoCommunicator;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.fxml.JavaFXBuilderFactory;
import javafx.scene.Group;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.text.Font;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 *
 * @author Adam
 */
public class Main extends Application {

    private ArduinoCommunicator arcom;
    private Stage stage;
    private Stage connectStage;

    @Override
    public void start(Stage primaryStage) throws Exception {
//        Parent root = FXMLLoader.load(getClass().getResource("ConnectMenu.fxml"));
        stage = primaryStage;
        arcom = new ArduinoCommunicator();
        connectStage = new Stage();
        
        
        MenuController menu = initMenu();
        initConnectMenu(menu);
        initPrefMenu();

    }

    public static void main(String[] args) {
        Application.launch(Main.class, (java.lang.String[]) null);
    }

    private MenuController initMenu() {
        try {
            MenuController menu = (MenuController) initStage(stage,"Menu.fxml");
            menu.setUp(this);
            stage.setTitle("Syringe Pump Control");
            stage.show();
            stage.setResizable(false);
            return menu;
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    private void initConnectMenu(MenuController menu){
        try {
            ConnectMenuController connect = (ConnectMenuController) initStage(connectStage,"ConnectMenu.fxml");
            connect.setUp(this,menu);
            connectStage.setTitle("Connections");
            connectStage.setResizable(false);

        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private void initPrefMenu(){
        
    }
    
    public void showConnectMenu(){
        connectStage.show();
    }
    public void hideConnectMenu(){
        connectStage.hide();
    }
    private Initializable initStage(Stage parstage, String fxml) throws Exception {
        FXMLLoader loader = new FXMLLoader();
        InputStream in = Main.class.getResourceAsStream(fxml);
        loader.setBuilderFactory(new JavaFXBuilderFactory());
        loader.setLocation(Main.class.getResource(fxml));
        AnchorPane page;
        try {
            page = (AnchorPane) loader.load(in);
        } finally {
            in.close();
        }
        Scene scene = new Scene(page);
        parstage.setScene(scene);
        return (Initializable) loader.getController();
    }

    
    public ArduinoCommunicator getArcom() {
        return arcom;
    }

}
