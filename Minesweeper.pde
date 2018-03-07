import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); 
int count;
boolean won = false;
boolean gameStart = false;
int startingR;
int startingC;
void setup ()
{
  size(600, 600);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to declare and initialize buttons goes here

  buttons = new MSButton[NUM_ROWS][NUM_COLS]; 
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
      buttons[r][c] = new MSButton(r, c);
  }
}
public void setBombs(int str, int stc)
{
  for (int i = 0; i<NUM_BOMBS; i++)
  {
    int bRow = (int)(Math.random()*NUM_ROWS);
    int bCol = (int)(Math.random()*NUM_COLS);
    if (bombs.contains(buttons[bRow][bCol])==false && !(bRow==str && bCol==stc))
    {
      bombs.add(buttons[bRow][bCol]);
    } else
      i--;
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  count = 0;
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      if (buttons[r][c].isClicked()==true&&buttons[r][c].isMarked()==false)
        count = count + 1;
    }
  }
  if (count ==NUM_ROWS*NUM_COLS-NUM_BOMBS)
  {
    won = true;
    return true;
  } else
    return false;
}
public void displayLosingMessage()
{
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      buttons[r][c].clicked=true;
    }
  }
  buttons[8][6].setLabel("Y");
  buttons[8][7].setLabel("O");
  buttons[8][8].setLabel("U");

  buttons[8][10].setLabel("L");
  buttons[8][11].setLabel("O");
  buttons[8][12].setLabel("S");
  buttons[8][13].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[8][6].setLabel("Y");
  buttons[8][7].setLabel("O");
  buttons[8][8].setLabel("U");

  buttons[8][10].setLabel("W");
  buttons[8][11].setLabel("I");
  buttons[8][12].setLabel("N");
  buttons[8][13].setLabel("");
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    if (gameStart == false)
    {
      setBombs(r,c);
      gameStart = true;
    }
    clicked = true;
    if (mouseButton==RIGHT)
    {
      if (label=="")
        marked = !marked;
      if (marked == false)
        clicked = false;
    } else if (bombs.contains(this)&&won==false)
    {
      displayLosingMessage();
    } else if (countBombs(r, c)>0)
    {
      label = (""+countBombs(r, c)+"");
    } else
    {
      if (isValid (r-1, c-1) && buttons[r-1][c-1].isClicked()==false)
        buttons[r-1][c-1].mousePressed();
      if (isValid (r-1, c) && buttons[r-1][c].isClicked()==false)
        buttons[r-1][c].mousePressed();
      if (isValid (r-1, c+1) && buttons[r-1][c+1].isClicked()==false)
        buttons[r-1][c+1].mousePressed();
      if (isValid (r, c-1) && buttons[r][c-1].isClicked()==false)
        buttons[r][c-1].mousePressed();
      if (isValid (r, c+1) && buttons[r][c+1].isClicked()==false)
        buttons[r][c+1].mousePressed();
      if (isValid (r+1, c-1) && buttons[r+1][c-1].isClicked()==false)
        buttons[r+1][c-1].mousePressed();
      if (isValid (r+1, c) && buttons[r+1][c].isClicked()==false)
        buttons[r+1][c].mousePressed();
      if (isValid (r+1, c+1) && buttons[r+1][c+1].isClicked()==false)
        buttons[r+1][c+1].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r<NUM_ROWS && c<NUM_COLS)
    {
      if (r>=0 && c>=0)
        return true;
      else
        return false;
    } else
      return false;
  }

  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (isValid(row-1, col-1)==true && bombs.contains(buttons[row-1][col-1])==true)
      numBombs=numBombs+1;
    if (isValid(row, col-1)==true && bombs.contains(buttons[row][col-1])==true)
      numBombs=numBombs+1;
    if (isValid(row+1, col-1)==true && bombs.contains(buttons[row+1][col-1])==true)
      numBombs=numBombs+1;
    if (isValid(row-1, col)==true && bombs.contains(buttons[row-1][col])==true)
      numBombs=numBombs+1;
    if (isValid(row+1, col)==true && bombs.contains(buttons[row+1][col])==true)
      numBombs=numBombs+1;
    if (isValid(row-1, col+1)==true && bombs.contains(buttons[row-1][col+1])==true)
      numBombs=numBombs+1;
    if (isValid(row, col+1)==true && bombs.contains(buttons[row][col+1])==true)
      numBombs=numBombs+1;
    if (isValid(row+1, col+1)==true && bombs.contains(buttons[row+1][col+1])==true)
      numBombs=numBombs+1;
    return numBombs;
  }
}