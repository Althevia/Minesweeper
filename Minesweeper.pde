import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
public final static int NUM_ROWS = 5;
public final static int NUM_COLS = 5;
public final static int NUM_BOMBS = 5;
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); 
void setup ()
{
  size(400, 400);
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
  setBombs();
  buttons[3][3].countBombs(3,3);
}
public void setBombs()
{
  for (int i = 0; i<NUM_BOMBS; i++)
  {
    int bRow = (int)(Math.random()*NUM_ROWS);
    int bCol = (int)(Math.random()*NUM_COLS);
    if (bombs.contains(buttons[bRow][bCol])==false)
    {
      bombs.add(buttons[bRow][bCol]);
      System.out.println(bRow+","+bCol);
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
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      if (bombs.contains(this))
        return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  //your code here
}
public void displayWinningMessage()
{
  //your code here
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
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
    clicked = true;
    if (keyPressed==true)
    {
      marked = !marked;
      if (marked == false)
        clicked = false;
      else if (bombs.contains(this))
      {
        displayLosingMessage();
        System.out.println("losing message");
      }
      else if (countBombs(r, c)>0)
      {
        System.out.println("label");
        label = (""+countBombs(r, c)+"");
      }
      else
      {
        System.out.println("recursive");
        if (isValid (r-1, c-1))
          buttons[r-1][c-1].mousePressed();
        if (isValid (r-1, c))
          buttons[r-1][c].mousePressed();
        if (isValid (r-1, c+1))
          buttons[r-1][c+1].mousePressed();
        if (isValid (r, c-1))
          buttons[r][c-1].mousePressed();
        if (isValid (r, c+1))
          buttons[r][c+1].mousePressed();
        if (isValid (r+1, c-1))
          buttons[r+1][c-1].mousePressed();
        if (isValid (r+1, c))
          buttons[r+1][c].mousePressed();
        if (isValid (r+1, c+1))
          buttons[r+1][c+1].mousePressed();
      }
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
    }
    else
      return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if (bombs.contains(buttons[row-1][col-1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row][col-1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row+1][col-1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row-1][col])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row+1][col])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row-1][col+1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row][col+1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;
    if (bombs.contains(buttons[row+1][col+1])==true && isValid(row,col)==true)
      numBombs=numBombs+1;

    //    for (int rr = row-1; rr<=row+1; rr++)
    //    {
    //      for (int cc = col-1; cc<=col+1; cc++)
    //      {
    //        if (rr!=row && cc!=col)
    //        {
    //          if (isValid(rr, cc)==true)
    //          {
    //            if (bombs.contains(buttons[rr][cc])==true)
    //              numBombs = numBombs + 1;
    //          }
    //        }
    //      }
    //    }
    System.out.println(numBombs);
    return numBombs;
  }
}