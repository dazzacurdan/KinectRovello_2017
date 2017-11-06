import org.openkinect.freenect.*;
import org.openkinect.processing.*;

public class OpenKinectWrap extends KinectWrap
{
  OpenKinectWrap(PApplet app)
  {
    m_numDevices = Kinect.countDevices();
    println("number of Kinect v1 devices  "+m_numDevices);
    switch(m_numDevices)
    {
      case 1:
      super.w = 640;super.h = 480;
      break;
      case 2:
      h=640;super.w=2*480;
      m_imageL=0;
      m_imageR=1;
      m_switchImages = false;
      m_flipValue = 1;
    }
    m_multiKinect = new ArrayList<Kinect>();
    
    for (int i  = 0; i < m_numDevices; i++) {
      Kinect tmpKinect = new Kinect(app);
      tmpKinect.activateDevice(i);
      tmpKinect.initDepth();
      tmpKinect.enableColorDepth(true);
      m_multiKinect.add(tmpKinect);
    }
  }
  PImage getDepthImage()
  {
    PImage out = new PImage();
    switch(m_numDevices)
    {
      case 1:
      {
        out = m_multiKinect.get(0).getDepthImage();
      }
      break;
      case 2:
      {
          PGraphics output = createGraphics(super.w, super.h, JAVA2D);
          output.beginDraw();
          output.pushMatrix();
            output.imageMode(CENTER);
            output.translate(width >> 2,height >> 1);
            output.scale(1,m_flipValue);
            output.rotate(PI+HALF_PI);
            output.image(m_multiKinect.get(m_imageL).getDepthImage(), 0, 0);
          output.popMatrix();
          output.pushMatrix();
            output.imageMode(CENTER);
            output.translate( (width >> 1)+(width >> 2),height >> 1);
            output.scale(1,-1*m_flipValue);
            output.rotate(HALF_PI);
            output.image(m_multiKinect.get(m_imageR).getDepthImage(), 0, 0);
          output.popMatrix();
          output.endDraw();
          out = output;
      }
      break;
    }
    return out;
  }
  int getNumDevices(){ return m_numDevices; }
  void switchImages()
  {
    m_switchImages = !m_switchImages;
    if(m_switchImages)
    {
      //println("Switch 1: L("+m_imageL+") R("+m_imageR+")");
      m_imageL = m_imageR;
      m_imageR = 0;
    }else{
      //println("Switch 0: L("+m_imageL+") R("+m_imageR+")");
      m_imageR = m_imageL;
      m_imageL = 0;
    }
  }
  void flipImages()
  {
    m_flipValue = (m_flipValue < 0 ? 1 : -1 );
  }
  private ArrayList<Kinect> m_multiKinect;
  private int m_numDevices;
  private int m_imageL,m_imageR;
  private boolean m_switchImages;
  private int m_flipValue;
}