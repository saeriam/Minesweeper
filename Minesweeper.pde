import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
final static int NUM_ROWS = 20;
final static int NUM_COLS = 20;
int numBombs=40;
int rNumBombs=0;
boolean lost =false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
bombs=new ArrayList <MSButton>();    
buttons=new MSButton[NUM_ROWS][NUM_COLS];

for(int r = 0; r < NUM_ROWS;r++){
  for(int c =0; c < NUM_COLS; c++){
    buttons[r][c]=new MSButton(r,c);
  }
}
    //declare and initialize buttons
    setBombs();
}

public void setBombs(){
   for(int i =0;i<numBombs;i++){
     int aRow=(int)(Math.random()*NUM_ROWS);
     int aCol=(int)(Math.random()*NUM_COLS);
     if(bombs.contains(buttons[aRow][aCol])==false){
       bombs.add(buttons[aRow][aCol]);
       rNumBombs+=1;
     }
   }
 }

public void draw (){
    background( 0 );
    if(isWon())
        displayWinningMessage();
    if(lost==true)
        displayLosingMessage();
}

public boolean isWon(){
    int clear=0;
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(buttons[r][c].clicked==true){
                if(!(bombs.contains(buttons[r][c])))
                clear+=1;
              }            
            }
          } 
    if(clear == ((NUM_COLS*NUM_ROWS)-(rNumBombs))){
        return true;
      }
    return false;
}

public void displayLosingMessage(){
   buttons[8][8].label="GA";
   buttons[8][9].label="ME";
   buttons[8][10].label="OV";
   buttons[8][11].label="ER";

   buttons[8][8].lose=true;
   buttons[8][9].lose=true;
   buttons[8][10].lose=true;
   buttons[8][11].lose=true;

   for(int r = 0; r < NUM_ROWS; r++){
     for(int c = 0; c < NUM_COLS; c++){
       buttons[r][c].clicked=true;  
     }
   }
}

public void displayWinningMessage(){
    buttons[8][8].label="YO";
    buttons[8][9].label="U";
    buttons[8][10].label="WI";
    buttons[8][11].label="N";

    buttons[8][8].win=true;
    buttons[8][9].win=true;
    buttons[8][10].win=true;
    buttons[8][11].win=true;  
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    boolean win=false;
    boolean lose=false;
    
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
    
    public void mousePressed(){
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
         else if(bombs.contains(this)){
            lost=true;
         }
         else if(countBombs(r,c)>0){
           label=str(countBombs(r,c));
         }
         else{
            for(int i = r-1 ;i <= r+1; i++){
                for(int n = c-1; n <= c+1; n++){  
                 if(isValid(i,n)){  
                    if(buttons[i][n].clicked==false){
                            buttons[i][n].mousePressed();
                         }
                    }
                }
            }
         }
    }
    public void draw () {    
        if (marked){
            fill(300);
        }
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else if(win==true){
            fill(#3C66E3);
        } 
        else 
            fill( 100 );
        if(lose==true){
            fill(#BC1C1F);
        }
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    
    public void setLabel(String newLabel){
        label = newLabel;
    }
    
    public boolean isValid(int r, int c){
      if(r >- 1 && r<20 && c>-1 && c<20){
        return true;
      }
        return false;
    }
    public int countBombs(int row, int col)
    {
       int numBombs = 0;
       for(int i = row-1; i <=row+1; i++){
          for(int n = col-1; n<=col+1; n++){ 
            if(isValid(i,n)){
                if(bombs.contains(buttons[i][n])){
                numBombs++;
              }
            }
          }
        }
        return numBombs;
    }
}
