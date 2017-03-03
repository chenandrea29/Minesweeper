import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 30;
private final static int NUM_COLS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int j=0; j<NUM_ROWS; j++) {
        for (int i=0; i<NUM_COLS; i++) {
            buttons[j][i] = new MSButton(j, i);
        }
    }
    while (bombs.size()<150) {
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
    buttons[15][10].setLabel("G");
    buttons[15][11].setLabel("A");
    buttons[15][12].setLabel("M");
    buttons[15][13].setLabel("E");
    buttons[15][16].setLabel("O");
    buttons[15][17].setLabel("V");
    buttons[15][18].setLabel("E");
    buttons[15][19].setLabel("R");
    buttons[15][10].end = true;
    buttons[15][11].end = true;
    buttons[15][12].end = true;
    buttons[15][13].end = true;
    buttons[15][16].end = true;
    buttons[15][17].end = true;
    buttons[15][18].end = true;
    buttons[15][19].end = true;
    for(int i = 0; i<bombs.size(); i++) {
        if (bombs.get(i).isMarked()==false)
            bombs.get(i).clicked=true;
    }
    for (int j = 0; j < NUM_ROWS; j++) {
        for (int i = 0; i < NUM_ROWS; i++) {
            if (buttons[j][i].isMarked()==true && !bombs.contains(buttons[j][i])) {
                buttons[j][i].wrong = true;
            }
        }
    }
}
public void displayWinningMessage()
{
    buttons[15][11].setLabel("Y");
    buttons[15][12].setLabel("O");
    buttons[15][13].setLabel("U");
    buttons[15][16].setLabel("W");
    buttons[15][17].setLabel("I");
    buttons[15][18].setLabel("N");
    buttons[15][11].end = true;
    buttons[15][12].end = true;
    buttons[15][13].end = true;
    buttons[15][16].end = true;
    buttons[15][17].end = true;
    buttons[15][18].end = true;
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, end, wrong;
    private String label;
    
    public MSButton (int rr, int cc)
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = end = wrong = false;
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
                buttons[r-1][c-1].mousePressed();
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
        if (wrong)
            fill(0, 255, 0);
        else if (marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(255, 0, 0);
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



