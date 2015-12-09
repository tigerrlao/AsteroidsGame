Sky[] star;
SpaceShip ship = new SpaceShip();
ArrayList <Asteroid> rock = new ArrayList <Asteroid>();
ArrayList <Bullet> shot = new ArrayList <Bullet>();

boolean start = false;
int seconds = 0;
int milliseconds = 0;
int brakeReserve = 3;
int hyperSpaceR = 3;
int shipHealth = 0;
public void setup() 
{
  size(800,800);
  star = new Sky[300];
  for(int i =0;i < star.length; i++)
  {
    star[i] = new Sky();
  }
  
  for(int j = 0; j < 20; j++)
  {
    rock.add(j, new Asteroid());
  }
  shot.add(new Bullet(ship));
}

public void draw() 
{
  background(0);
  for(int i =0;i<star.length;i++)
  {
    star[i].show();
  }
  if(start == false)
  {
    textAlign(CENTER);
    textSize(100);
    fill(0,255,0);
    text("Asteroids",400,300);
    textSize(50);
    fill(130,250,130);
    text("Tiger Lao",400,200);
    textSize(40);
    fill(0,115,0);
    text("W to accelerate",400,400);
    text("S to deccelerate",400,440);
    text("A and D to rotate",400,480);
    text("R for hyperspace",400,520);
    text("SPACE for emergency brakes",400,560);
    text("ENTER to start game",400,600);
  }

  if(start == true)
  {
    ship.show();
    shot.get(0).show();
    if(shipHealth < 170)
    ship.move();
    for(int j=0;j<rock.size();j++)
    {
    rock.get(j).show();
    rock.get(j).myRotate(rock.get(j).getaRotate());
    if(shipHealth<170)
    rock.get(j).move();
    //bug
    if(dist(ship.getX(),ship.getY(),rock.get(j).getX(),rock.get(j).getY()) <= 20)
    {
      rock.remove(j);
      shipHealth+=35;
    }
    }
    if(shipHealth<170)
    milliseconds += 1;
    if(milliseconds == 60)
    {
      seconds = seconds + 1;
      milliseconds = 0;
    }

  }
  if(ship.getaccelerate()==true)
  {
    ship.accelerate(0.3);
  }
  if(ship.getdecelerate()==true){ship.accelerate(-0.3);}
  if(ship.getspinC()==true){ship.myRotate(10);}
  if(ship.getspinCC()==true){ship.myRotate(-10);}
  if(ship.getbrakes()==true)
  {
    ship.setDirectionX(0);
    ship.setDirectionY(0);
  }

  //score counter
  noFill();
  strokeWeight(3);
  stroke(0,255,0);
  rect(0,750,800,50);
  fill(0,255,0);
  textSize(20);
  textAlign(LEFT);
  text("score: " + seconds +"." + milliseconds + " seconds",25,780);
  text(brakeReserve,350,780);
  text(hyperSpaceR,500,780);
  textSize(15);
  text("emergency",250,765);
  text("brakes",250,780);
  text("remaining",250,795);
  text("hyperspace",400,770);
  text("remaining",400,785);
  text("health",540,780);
  strokeWeight(0);
  rect(600,770,(175 - shipHealth),10);
  if(shipHealth > 170)
  {
    textAlign(CENTER);
    textSize(100);
    text("GAME OVER",400,400);
  }

}

class Sky
{
  private int myX,myY;
  public Sky()
  {
    myX = (int)(Math.random()*750);
    myY = (int)(Math.random()*750);
  }
  public void setmyX(int x){myX = x;}
  public void setmyY(int y){myY = y;}
  public int getmyX(){return myX;}
  public int getmyY(){return myY;}
  public void show()
  {
    noStroke();
    fill(255,255,255);
    rect(myX,myY,3,3);
  }
}
class SpaceShip extends Floater  
{   
  private boolean accelerateS;
  private boolean decelerateS;
  private boolean spinC;
  private boolean spinCC;
  private boolean brakes;
  private boolean power;
  private boolean bpower;
  public SpaceShip()
  {
    corners = 3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -8;
    yCorners[0] = -8;
    xCorners[1] = -8;
    yCorners[1] = 8;
    xCorners[2] = 16;
    yCorners[2] = 0;
    myCenterX = 400;
    myCenterY = 400;
    myColor = color(0,255,0);
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
  }
  public void setX(int x) {myCenterX = x;}
  public int getX() {return (int)myCenterX;}
  public void setY(int y) {myCenterY = y;}
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(int degrees) {myPointDirection = degrees;}
  public double getPointDirection() {return myPointDirection;}
  public void setaccelerate(boolean accel){accelerateS = accel;}
  public void setdecelerate(boolean decel){decelerateS = decel;}
  public boolean getaccelerate(){return accelerateS;}
  public boolean getdecelerate(){return decelerateS;}
  public void setspinC(boolean turn){spinC = turn;}
  public void setspinCC(boolean turn){spinCC = turn;}
  public boolean getspinC(){return spinC;}
  public boolean getspinCC(){return spinCC;}
  public void setbrakes(boolean slow){brakes = slow;}
  public boolean getbrakes(){return brakes;}
  public void setpower(boolean addpower){power = addpower;}
  public boolean getpower(){return power;}
  public void setbpower(boolean backpower){bpower = backpower;}
  public boolean getbpower(){return bpower;}
  public void show()
  {

    noFill(); 
    strokeWeight(3);
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
    double diRadians = myPointDirection*(Math.PI/180);
    strokeWeight(2);
    stroke(255,130,0);
    translate((int)myCenterX,(int)myCenterY);
    rotate((float)diRadians);
    if(power == true)
    {
      triangle(-8,-8,-14,0,-8,8);
    }
    if(bpower == true)
    {
      line(4,8,16,8);
      line(4,-8,16,-8);
    }
    rotate((float)(-diRadians));
    translate((int)(-myCenterX),(int)(-myCenterY));
  }
  public void move()
  {
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >750)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = 750;    
    }   
  }  
}

public void keyPressed()
{
  if(key == 'w')
  {
    ship.setaccelerate(true);
    ship.setpower(true);
  }
  if(key == 's')
  {
    ship.setdecelerate(true);
    ship.setbpower(true);
  }
  if(key == 'a'){ship.setspinCC(true);}
  if(key == 'd'){ship.setspinC(true);}
  if(key == ' ')
  {
    if(brakeReserve > 0)
    {
    brakeReserve = brakeReserve - 1;
    ship.setbrakes(true);
    }
  }
  if(key == 'r')
  {
    
    if(hyperSpaceR > 0)
    {
    hyperSpaceR = hyperSpaceR - 1;
    ship.setDirectionX(0);
    ship.setDirectionY(0);
    ship.setX((int)(Math.random()*800));
    ship.setY((int)(Math.random()*800));
    ship.setPointDirection((int)(Math.random()*360));
    }
  }
  if(key == ENTER)
  {
    start = true;
  }
}

public void keyReleased()
{
  if(key == 'w')
  {
    ship.setaccelerate(false);
    ship.setpower(false);
  }
  if(key == 's')
  {
    ship.setdecelerate(false);
    ship.setbpower(false);
  }
  if(key == 'a'){ship.setspinCC(false);}
  if(key == 'd'){ship.setspinC(false);}
  if(key == ' ')
  {
    ship.setbrakes(false);
  }
}

class Bullet extends Floater
{
  public Bullet(SpaceShip ship)
  {
    myCenterX = ship.getX();
    myCenterY = ship.getY();

    corners = 3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -4;
    yCorners[0] = -4;
    xCorners[1] = -4;
    yCorners[1] = 4;
    xCorners[2] = 8;
    yCorners[2] = 0;
    myColor = color(255,100,0);
    myPointDirection = ship.getPointDirection();
    double dRadians =myPointDirection*(Math.PI/180);
    myDirectionX = 5*Math.cos(dRadians) + ship.getDirectionX();
    myDirectionY = 5*Math.cos(dRadians) + ship.getDirectionY();
  }
  public void setX(int x) {myCenterX = x;}
  public int getX() {return (int)myCenterX;}
  public void setY(int y) {myCenterY = y;}
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(int degrees) {myPointDirection = degrees;}
  public double getPointDirection() {return myPointDirection;}
  public void show()
  {
    noFill(); 
    strokeWeight(2);
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }
  public void move()
  {
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }
}

class Asteroid extends Floater
{
  private int aRotate;
  public Asteroid()
  {
    corners = 13;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = 0;
    yCorners[0] = -13;
    xCorners[1] = -6;
    yCorners[1] = -7;
    xCorners[2] = -14;
    yCorners[2] = -5;
    xCorners[3] = -12;
    yCorners[3] = 5;
    xCorners[4] = -14;
    yCorners[4] = 9;
    xCorners[5] = -3;
    yCorners[5] = 16;
    xCorners[6] = 5;
    yCorners[6] = 13;
    xCorners[7] = 10;
    yCorners[7] = 15;
    xCorners[8] = 14;
    yCorners[8] = 10;
    xCorners[9] = 16;
    yCorners[9] = 2;
    xCorners[10] = 14;
    yCorners[10] = -4;
    xCorners[11] = 10;
    yCorners[11] = -10;
    xCorners[12] = 5;
    yCorners[12] = -9;
    
    myCenterX = (int)(Math.random()*750)+25;
    myCenterY = (int)(Math.random()*750)+25;
    myColor = color(255,0,0);
    myDirectionX = (Math.random()*7)-3;
    myDirectionY = (Math.random()*7)-3;
    myPointDirection = (int)(Math.random()*360);
    aRotate = (int)((Math.random()*10)-5);
  }
  public void setaRotate(int astRotate){aRotate = astRotate;}
  public int getaRotate(){return aRotate;}
  public void setX(int x) {myCenterX = x;}
  public int getX() {return (int)myCenterX;}
  public void setY(int y) {myCenterY = y;}
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}
  public double getDirectionY() {return myDirectionY;}
  public void setPointDirection(int degrees) {myPointDirection = degrees;}
  public double getPointDirection() {return myPointDirection;}
  public void show ()  //Draws the floater at the current position  
  {             
    noFill(); 
    strokeWeight(4);
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
  public void move()
  {
    super.move();
  }
}
abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void myRotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor); 
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 

