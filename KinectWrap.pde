public abstract class KinectWrap
{
  KinectWrap()
  {
  }
  abstract PImage getDepthImage();
  abstract int getNumDevices();
  abstract void switchImages();
  abstract void flipImages();
  public int w,h;
}