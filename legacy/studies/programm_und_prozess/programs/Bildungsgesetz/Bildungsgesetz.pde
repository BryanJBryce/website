// Konstanten
int MARGIN = 20; // Randabstand
int FONT_SIZE = 36; // Schriftgr��e
int ROWS = 5;
int COLUMNS = 2;
int COLUMN_GAP = 130;
int LETTER_START = 97;
int LETTER_END = 122;
// Buchstabenvariablen
int letterLeft = LETTER_START;
int letterRight = LETTER_START;

/**
 * Setup
 */
void setup() 
{
  size((COLUMNS*COLUMN_GAP), (ROWS*FONT_SIZE)+MARGIN);
  fill(255);
  textFont(loadFont("CourierNew36.vlw"), FONT_SIZE);
  increment();
}

/**
 * leer implementiert, damit mouseRelease funktioniert
 */
void draw()
{
}

/**
 * neues Inkrement ausf�hren
 */
void mouseReleased()
{
  increment();
}

/**
 * Zeichnet die jeweiligen W�rter auf die
 * B�hne und setzt die Buchstaben neu
 */
void increment()
{
  // zur�cksetzen
  background(0);
  // zwei Spalten
  for(int x=0; x<COLUMNS; x++) {
    // f�nf Zeilen
    for(int y=1; y<=ROWS; y++) {
      // Wort zusammensetzen, dazu die Letter typecasten
      String word = (char)letterLeft + "ei" + (char)letterRight;
      // W�rter auf die B�hne zeichnen
      text(word, (x*COLUMN_GAP)+MARGIN, (y*FONT_SIZE));
      // Buchstaben neu setzen
      if(letterRight == LETTER_END) {
        letterLeft += 1;
        letterRight = LETTER_START;
      } else
        letterRight += 1;
      // eventuell von vorne beginnen
      if(letterLeft > LETTER_END)
        letterLeft = LETTER_START;
    }
  }
}
