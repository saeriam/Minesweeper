import de.bezier.guido.*;
final static int NUM_ROWS = 20;
final static int NUM_COLS = 20;
int numBombs = 40;
int rNumBombs = 0;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for (int r = 0; r < buttons.length; r++){
      for (int c = 0; c < buttons[r].length; c++){
        buttons [r][c] = new MSButton (r, c);
      }
    }
    setBombs();
}
public void setBombs()
{
   for (int i = 0; i < numBombs; i++){
   int aRow = (int) (Math.random()*NUM_ROWS);
   int aCol = (int) (Math.random()*NUM_COLS);
   if(bombs.contains(buttons[aRow][aCol])==false){
       bombs.add(buttons[aRow][aCol]);
       rNumBombs+=1;
     }
   }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int clear = 0; 
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if (buttons [r][c].clicked == true){
          clear+=1;
        }
      }
    }
    if (clear == ((NUM_COLS* NUM_ROWS)-(rNumBombs))){
      return true;
    }
    return false;
}
public void displayLosingMessage(){
    buttons[10][9].label="GA";
    buttons[10][10].label="ME";
    buttons[10][12].label="OV";
    buttons[10][13].label="ER";

    buttons[10][9].lose=true;
    buttons[10][10].lose=true;
    buttons[10][12].lose=true;
    buttons[10][13].lose=true;
}
public void displayWinningMessage(){
    buttons[10][9].label="YO";
    buttons[10][10].label="U";
    buttons[10][12].label="WI";
    buttons[10][13].label="N";

    buttons[10][9].win=true;
    buttons[10][10].win=true;
    buttons[10][12].win=true;
    buttons[10][13].win=true;
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    boolean win = false; 
    boolean lose = false;
    
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
    
    public void mousePressed () {
        clicked = true;
        if(keyPressed==true||(mousePressed && (mouseButton == RIGHT))){
           if(marked==false){
                marked=true;
            }
            else if(marked==true){
                marked=false;
                clicked=false;
              }
          }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else if (win == true)
            fill(240,230,140);  
        else 
            fill( 100 );
        if (lose == true) 
            fill(100, 149, 237);
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
     if (r>=0 && r < NUM_ROWS && c>=0 && c < NUM_COLS)
      return true;
     else
      return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int r = NUM_ROWS-1; r <= NUM_ROWS+1; r++){
          for (int c = NUM_COLS-1; c <= NUM_COLS+1; c++){
            if (isValid(r,c)){
              if (bombs.contains(buttons[r][c])){
                numBombs++;
              }
            }
          }
        }
        return numBombs;
    }
}
