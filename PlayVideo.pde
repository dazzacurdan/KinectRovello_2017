import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.awt.Robot;
import java.awt.AWTException;
import java.util.Random;

static int NUMBER_OF_CHAIR = 3;

class PlayVideo
{
  private KeystrokeSimulator keySim;
  private boolean enableRandom;
  private Random rand;
  private int numberOfVideo = 5;
  private int count[] = {0,0,0};
  private List<int[][]> videoMaps = new ArrayList<int[][]>();
  
  
  PlayVideo(boolean _enableRandom)
  {
    enableRandom = _enableRandom;
    if( enableRandom )
    {
      rand = new Random();
    }
    keySim = new KeystrokeSimulator();
    
    videoMaps.add(new int[][]{
              {KeyEvent.VK_Q, 105000},
              {KeyEvent.VK_W, 60000},
              {KeyEvent.VK_E, 90500},
              {KeyEvent.VK_R, 66000},
              {KeyEvent.VK_T, 67000},
              {KeyEvent.VK_Y, 77000}});
    videoMaps.add(new int[][]{
              {KeyEvent.VK_A, 79000},
              {KeyEvent.VK_S, 60000},
              {KeyEvent.VK_D, 111000},
              {KeyEvent.VK_F, 114000},
              {KeyEvent.VK_G, 60000},
              {KeyEvent.VK_H, 110000},
              {KeyEvent.VK_J, 60000}});
    videoMaps.add(new int[][]{
              {KeyEvent.VK_Z, 114000},
              {KeyEvent.VK_X, 60000},
              {KeyEvent.VK_C, 60000},
              {KeyEvent.VK_V, 115000},
              {KeyEvent.VK_B, 60000},
              {KeyEvent.VK_N, 60000}});
    
  }
  
  int play( int area )
  {
    int delay = 0;
    try
    { 
      int[][] chair = videoMaps.get(area);
      if( enableRandom )
      { 
        int randValue = rand.nextInt(numberOfVideo);
        println("RandValue: "+randValue+" char: "+(char)chair[randValue][0]);
        keySim.simulate(chair[randValue][0]);
        delay = chair[randValue][1];
      }
      else
      {
        keySim.simulate(chair[count[area]][0]);
        delay = chair[count[area]][1];
        println("Sended: "+(char)(chair[count[area]][0]));
        count[area] = (++count[area])%numberOfVideo;
        println("Chair_0: "+count[0]+" Chair_1: "+count[1]+" Chair_2: "+count[2]);
      }
    }catch(AWTException e){
      println(e);
    }
    return delay;
  }
}