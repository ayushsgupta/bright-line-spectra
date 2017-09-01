//Constants-------------------------------------------------------------------------------------------------
//8-25-2017
int colormaxHSV = 300;
float colormaxHSVf = float(colormaxHSV);

float lambdaViolet = 380.0;
float lambdaRed = 640.0;
int visMax = 760;

int scalefactor = 3;
int currentStroke = 1;

double R = 1.097e-7;
double h = 6.626e-34;
double c = 3.00e8;
double B = 3.6450682e-7;

//Setup-----------------------------------------------------------------------------------------------------
//8-25-2017
void setup() {
  size(1140, 130);
  background(0);
  strokeWeight(currentStroke);
  //print(RydbergFormula(2, 3));
}

//Draw------------------------------------------------------------------------------------------------------
//8-25-2017
void draw() {
  //Hydrogen_BrightLine();
  BalmerSeries_BrightLine();
  //Rydberg_BrightLine();
  //Sodium_BrightLine();
  //Helium_BrightLine();
  //Neon_BrightLine();
  //Mercury_BrightLine();
  //Cadmium_BrightLine();
  //Fluorine_BrightLine();
  //Chlorine_BrightLine();
}

//Functions for creating bright-line spectra of various elements--------------------------------------------
//8-26-2017
void Hydrogen_BrightLine() {
  Element H = new Element(new int[]{656, 486, 434, 410});
  int[] spectra = H.getSpectra();
  displaySpectrum(spectra);
}

void Sodium_BrightLine() {
  Element Na = new Element(new int[]{589, 590});
  int[] spectra = Na.getSpectra();
  displaySpectrum(spectra);
}

void Helium_BrightLine() {
  Element He = new Element(new int[]{403, 447, 471, 502, 588, 668});
  int[] spectra = He.getSpectra();
  displaySpectrum(spectra);
}

void Neon_BrightLine() {
  Element Ne = new Element(new int[]{540, 585, 588, 603, 607, 616, 622, 627, 633, 638, 640, 651, 660, 693, 703});
  int[] spectra = Ne.getSpectra();
  displaySpectrum(spectra);
}

void Mercury_BrightLine() {
  Element Hg = new Element(new int[]{436, 546, 577, 579});
  int[] spectra = Hg.getSpectra();
  displaySpectrum(spectra);
}

void Cadmium_BrightLine() {
  Element Cd = new Element(new int[]{644, 636, 509, 480, 468, 441});
  int[] spectra = Cd.getSpectra();
  displaySpectrum(spectra);
}

void Fluorine_BrightLine() {
  Element F = new Element(new int[]{624, 635, 641, 684, 686, 690});
  int[] spectra = F.getSpectra();
  displaySpectrum(spectra);
}

void Chlorine_BrightLine() {
  Element Cl = new Element(new int[]{480, 542, 490, 522, 491, 481});
  int[] spectra = Cl.getSpectra();
  displaySpectrum(spectra);
}

//Function to handle display of spectra--------------------------------------------------------------------
//8-31-2017
void displaySpectrum(int[] spectra) {
  for(int m = 0; m < spectra.length; m++) {
    stroke(wavelengthToColor(spectra[m]));
    line(scalefactor * (spectra[m] - 380), 0, scalefactor * (spectra[m] - 380), height);
  }
}

//Function for creating visible bright-line spectrum, needs fixing-----------------------------------------
//8-26-2017
void Visible_BrightLine() {
  strokeWeight(pow(scalefactor, 2));
  for (int w = 380; w <= visMax; w += scalefactor * scalefactor) {
    stroke(wavelengthToColor(w));
    int orig = w;
    for (int x = 0; x < scalefactor; x++) {
      line(scalefactor * (w - 380), 0, scalefactor * (w - 380), height);
      w += scalefactor;
    }
    w = orig;
  }
  strokeWeight(currentStroke);
}

//Conversion of lambda to HSV colorspace coordinates--------------------------------------------------------
//8-25-2017
color wavelengthToColor(int lambda) {
    int hue = int(map(float(lambda), lambdaViolet, lambdaRed, 0.0, colormaxHSVf));
    hue = colormaxHSV - hue;
    colorMode(HSB, 360, 1, 1);
    color c = color(hue, 1, 1);
    colorMode(RGB, 255, 255, 255);
    return c;
}

//Implementation of Rydberg's equation----------------------------------------------------------------------
//8-30-17
int RydbergFormula(float f, float i) {
  double invlambda = (R * ((1.0 / sq(f)) - (1.0 / sq(i))));
  return (int) (1 / invlambda * 10e-6);
}

void Rydberg_BrightLine() {
  int[] inits = {3, 4, 5, 6};  
  int[] fins = new int[inits.length];
  for(int i = 0; i < inits.length; i++) {
    fins[i] = RydbergFormula(2, inits[i]);
  }
  Element H = new Element(fins);
  int[] spectra = H.getSpectra();
  displaySpectrum(spectra);
}

//Implementation of Balmer's formula and series-------------------------------------------------------------
//8-30-2017
int[] BalmerFormula() {
  float[] n = {3.0, 4.0, 5.0, 6.0};
  int[] w = new int[4];
  
  for(int i = 0; i < n.length; i++) {
    w[i] = (int) (B * (sq(n[i]) / (sq(n[i]) - 4)) * 10e8);
    println(w[i]);
  }
  
  return w;
}

void BalmerSeries_BrightLine() {
  Element H = new Element(BalmerFormula());
  int[] spectra = H.getSpectra();
  displaySpectrum(spectra);
}

//Deprecated HSV to RGB color conversion - didn't work too well---------------------------------------------
//8-25-2017
int[] HSVtoRGB(int[] hsv) {
  int C = hsv[1] * hsv[2];
  int X = int(C * (1 - abs(((float(hsv[0]) / 60.0) % 2) - 1)));
  int m = hsv[2] - C;
  int[] rgb = new int[3];
  
  if (hsv[0] < 60) {
    rgb[0] = C;
    rgb[1] = X;
    rgb[2] = 0;
  } else if (hsv[0] < 120) {
    rgb[0] = X;
    rgb[1] = C;
    rgb[2] = 0;
  } else if (hsv[0] < 180) {
    rgb[0] = 0;
    rgb[1] = C;
    rgb[2] = X;
  } else if (hsv[0] < 240) {
    rgb[0] = 0;
    rgb[1] = X;
    rgb[2] = C;
  } else if (hsv[0] < 300) {
    rgb[0] = X;
    rgb[1] = 0;
    rgb[2] = C;
  } else if (hsv[0] < 360) {
    rgb[0] = C;
    rgb[1] = 0;
    rgb[2] = X;
    //rgb = [C, 0, X];
  }
  
  for(int k = 0; k < rgb.length; k++) {
     rgb[k] = (rgb[k] + m) * 255; 
  }
  
  return rgb;
}

//Mathematical operations----------------------------------------------------------------------------------
//8-30-2017
int sq(int n) {
  return (int) Math.pow(n, 2);  
}