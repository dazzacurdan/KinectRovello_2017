int actualDelay = 0;
int countLock = 0;
int fontSize = 15;
KinectWrap kinect;
boolean ir = false;
boolean colorDepth = false;
boolean mirror = false;
PImage kImg;
Vector<ROI> ROIContainer;
Iterator<ROI> it_roi;
int actMouseX,actMouseY;
boolean lock,mouseDragged;

int startTime;
PlayVideo video;
ConfigParser parser;
boolean lockROIContainer;
KeystrokeSimulator keySim;

void setup() {
  
  size(640, 480);
  
  try
  {
    kinect = new OpenKinectWrap(this);
  }catch(Exception e){
    println(e);
  }

  keySim = new KeystrokeSimulator();
  
  ROIContainer = new Vector<ROI>();
  video = new PlayVideo(false);
  lock = false; 
  mouseDragged=false;
  parser =new ConfigParser();
  lockROIContainer = parser.loadROI("config.xml",ROIContainer);
  println( "LoadRoi Results: "+ lockROIContainer);
}

void draw() {
  background(0);
  kImg = kinect.getDepthImage();
  image(kImg, 0, 0);
  
  for(int i=0;i<ROIContainer.size();++i)
  {
    if( ROIContainer.get(i).visualize(kImg) && !lock)
    {
      lock = true;
      startTime = millis();
      actualDelay = video.play(i);
      thread("lockFunction");
    }
  }
  if(lock)
  {
    fill(0, 102, 153);
    textSize(150);
    text((int)((millis()-startTime)/1e3),213,240);
  }
  if(mouseDragged)
  {
    stroke(255,0,0);
    noFill();
    rect(actMouseX,actMouseY,mouseX-actMouseX,mouseY-actMouseY);
  }
  mouseDragged = false;
  fill(0, 102, 153);
  textSize(fontSize);
  text("Press c to visualize color under the mouse",3,fontSize);
  text("Press s to save current configuration",3,fontSize*2);
  text("Press t to set the threasold for each areas",3,fontSize*3);
}
void lockFunction()
{
  //int id = countLock;
  //println(".:LOCK "+id+" "+countLock+":.");
  
  println("Disable Loop");
  try{
    
    keySim.simulate(KeyEvent.VK_P);
    
  }catch(AWTException e){
     println(e);
  }
  println("Delay is: "+actualDelay);
  delay(actualDelay);
  try{
    
    keySim.simulate(KeyEvent.VK_P);
    
  }catch(AWTException e){
     println(e);
  }
  delay(5000);
  lock = false;
}
void keyPressed() {
  switch (key) 
  {
    case 'c':
    {
      color actColor = kImg.pixels[mouseX+mouseY*kImg.width];
      actColor &= 0x00FFFFFF; 
      println("Actual Color: "+hex(actColor)+" color("+((actColor >> 16)&0x0000FF)+", "+((actColor >> 8)&0x0000FF)+", "+(actColor & 0xFF)+")");
    }
     break;
    case 's':
    {
      if(!lockROIContainer )
      {
        XML xml = loadXML("roi.xml");
        xml.setName("Regions");
        for(int i=0;i<ROIContainer.size();++i)
        {
           XML child = xml.addChild("roi");
          child.setInt( "id", i );
          child.setInt( "x", ROIContainer.get(i).x );
          child.setInt( "y", ROIContainer.get(i).y );
          child.setInt( "w", ROIContainer.get(i).w );
          child.setInt( "h", ROIContainer.get(i).h );
          child.setString("avgColor",hex(ROIContainer.get(i).getAvgColor()));
          child.setContent(hex(ROIContainer.get(i).getThColor()));
        }
        saveXML(xml,"config.xml");
      }
    }
    break;
    case 't':
    {
      color actColor = kImg.pixels[mouseX+mouseY*kImg.width];
      ROIContainer.lastElement().setThColor( actColor );
      actColor &= 0x00FFFFFF; 
      println("TH color: "+hex(actColor)+" color("+((actColor >> 16)&0x0000FF)+", "+((actColor >> 8)&0x0000FF)+", "+(actColor & 0xFF)+")");
    }
    break;
    case 'l':
    {
    }
    break;
    case 'r':
    {
    }
    break;
    case CODED:
    {
      switch(keyCode)
      {
        case RIGHT:
          kinect.switchImages();
        break;
        case UP:
          kinect.flipImages();
        break;
      }
    } 
    break;
  }
}
void mousePressed() {
  if (mouseButton == RIGHT && !lockROIContainer)
  {
    if(!ROIContainer.isEmpty())ROIContainer.remove(ROIContainer.lastElement());
  }else
  {
    actMouseX = mouseX;
    actMouseY = mouseY;
  }
}
void mouseReleased() {
  if (mouseButton != RIGHT && !lockROIContainer)
  {
    int w = mouseX-actMouseX, h= mouseY-actMouseY;
    println("Added region in: "+actMouseX+" "+actMouseY+" "+w+" "+h);
    ROIContainer.addElement(new ROI(actMouseX,actMouseY,mouseX-actMouseX,mouseY-actMouseY));
    ROIContainer.lastElement().setAvgColor();
  }
}
void mouseDragged()
{
  mouseDragged = true;
}