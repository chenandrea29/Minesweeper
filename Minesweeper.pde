import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int j=0; j<NUM_ROWS; j++) {
        for (int i=0; i<NUM_COLS; i++) {
            buttons[j][i] = new MSButton(j, i);
        }
    }
    while (bombs.size()<75) {
        setBombs();
    }
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][col])) {
        bombs.add(buttons[row][col]);
    }
}

public void draw ()
{
    background(0);
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for (int i = 0; i<bombs.size(); i++) {
        if (bombs.get(i).isMarked()==false) {
            return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[10][5].setLabel("G");
    buttons[10][6].setLabel("A");
    buttons[10][7].setLabel("M");
    buttons[10][8].setLabel("E");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("V");
    buttons[10][13].setLabel("E");
    buttons[10][14].setLabel("R");
    buttons[10][5].end = true;
    buttons[10][6].end = true;
    buttons[10][7].end = true;
    buttons[10][8].end = true;
    buttons[10][11].end = true;
    buttons[10][12].end = true;
    buttons[10][13].end = true;
    buttons[10][14].end = true;
    for(int i = 0; i<bombs.size(); i++) {
        if (bombs.get(i).isMarked()==false)
            bombs.get(i).clicked=true;
    }
}
public void displayWinningMessage()
{
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][11].setLabel("W");
    buttons[10][12].setLabel("I");
    buttons[10][13].setLabel("N");
    buttons[10][6].end = true;
    buttons[10][7].end = true;
    buttons[10][8].end = true;
    buttons[10][11].end = true;
    buttons[10][12].end = true;
    buttons[10][13].end = true;
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, end;
    private String label;
    
    public MSButton (int rr, int cc)
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = end = false;
        Interactive.add(this); // register it with the manager
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
        if (gameOver == true) {
            return;
        }
        clicked = true;
        if(keyPressed == true) {
            marked=!marked;
            if(marked == false) {
                clicked = false;
            }
        }
        else if(bombs.contains(this)) {
            displayLosingMessage();
            gameOver = true;
        }
        else if(countBombs(r, c)>0) {
            setLabel(Integer.toString(countBombs(r, c)));
        }
        else {
            if(isValid(r, c-1) && buttons[r][c-1].isClicked() == false) {
                buttons[r][c-1].mousePressed();
            }
            if(isValid(r, c+1) && buttons[r][c+1].isClicked() == false) {
                buttons[r][c+1].mousePressed();
            }
            if(isValid(r-1, c-1) && buttons[r-1][c-1].isClicked() == false) {
                buttons[r][c-1].mousePressed();
            }
            if(isValid(r-1, c) && buttons[r-1][c].isClicked() == false) {
                buttons[r-1][c].mousePressed();
            }
            if(isValid(r-1, c+1) && buttons[r-1][c+1].isClicked() == false) {
                buttons[r-1][c+1].mousePressed();
            }
            if(isValid(r+1, c-1) && buttons[r+1][c-1].isClicked() == false) {
                buttons[r+1][c-1].mousePressed();
            }
            if(isValid(r+1, c) && buttons[r+1][c].isClicked() == false) {
                buttons[r+1][c].mousePressed();
            }
            if(isValid(r+1, c+1) && buttons[r+1][c+1].isClicked() == false) {
                buttons[r+1][c+1].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if (end)
            fill(100, 200, 255);
        else if(clicked)
            fill(200);
        else 
            fill(100);

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
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if(isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1]))
            numBombs++;
        if(isValid(row, col-1) && bombs.contains(buttons[row][col-1]))
            numBombs++;
        if(isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1]))
            numBombs++;
        if(isValid(row+1, col) && bombs.contains(buttons[row+1][col]))
            numBombs++;
        if(isValid(row-1, col) && bombs.contains(buttons[row-1][col]))
            numBombs++;
        if(isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1]))
            numBombs++;
        if(isValid(row, col+1) && bombs.contains(buttons[row][col+1]))
            numBombs++;
        if(isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1]))
            numBombs++;
        return numBombs;
    }
}



