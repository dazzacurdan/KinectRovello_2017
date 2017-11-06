import java.awt.Robot;
import java.awt.AWTException;

public class KeystrokeSimulator {

private Robot robot;
  
  KeystrokeSimulator(){
    try{
      robot = new Robot();  
    }catch(AWTException e){
      println(e);
    }
  }
  
  boolean simulate(int c) throws AWTException {
      robot.keyPress(c);
      robot.delay(80);
      robot.keyRelease(c);
      return true;
  }
}