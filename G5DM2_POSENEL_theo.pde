//////////////////////////////////////////////////////////////
//
// Les déclarations de variables
//
//////////////////////////////////////////////////////////////
PImage img, invaders, fond ; //Image canon,invader
float canonX, canonY; //Position Canon
float bulletX, bulletY ; //Position Bullet
float vitesseBullet; //Vitesse Bullet
boolean lanceBullet = false; //Voir si le bullet est envoyé
float invaderX, invaderY; //Position Invader
float periodicite; //nombre de frame entre chaque déplacement de l'Invader
float compte; //compte le nombre de frame
float vitesseInvader; //Vitesse Invader
int score; //Score dans la game
int meilleurScore; //Meilleur score du programme
int R,V,B; //Invader clignote quand il est touché
PFont style; //Ecrite du score et meilleur score et game over
boolean endGame; //True = partie fini et False = partie en cours
boolean debutpartie = false; //True = partie commancé et False = partie pas commencé
int themes; //Choix des thèmes
int debut =1; //Pour régler l'initialisation des positions au début du jeu
import ddf.minim.*; //paramètre pour ajouter de la musique
Minim minim;
AudioPlayer track;


//////////////////////////////////////////////////////////////
//
// La fonction d'initialisation
//
//////////////////////////////////////////////////////////////
void setup() {
  // fixe la taille de la fenêtre
  size(600, 800);
  // fixe la vitesse d'animation
  frameRate(50);
  img = loadImage("gun.png");
  invaders = loadImage("invader.png");
  fond = loadImage("noir.jpg");
  style = createFont("joystix.ttf",16);
  // appelle la fonction d'initialisation du jeu
 //newGame(); //Aucune utilité maintenant
  meilleurScore = 0; 
}

//////////////////////////////////////////////////////////////
//
// Partie Bonus
//
//////////////////////////////////////////////////////////////
void choixThemes(){ //Différent thème du jeux
    if (key == '1' && debutpartie==false){
    themes=1;
    debutpartie=true;
  minim = new Minim(this);
  track = minim.loadFile ("Space_Invader_8-bit.mp3");
  track.play();
    newGame();
  }else if (key == '2' && debutpartie==false){
    themes=2;
    debutpartie=true;
   minim = new Minim(this);
   track = minim.loadFile ("Tetris_8_bit_Music_Tetris_Theme_Song.mp3");
   track.play();
    newGame();
  }else if (debutpartie == false){
   background(255);
    fill(0);
    textSize(18);
    text("Press 1 for CLASSIC THEME",width/4,(height/3 + 50));
    text("Press 2 for TETRIS THEME",width/4,(height/3 + 150));
    if (endGame == true){
      gameOver();
    }
  }
    if (themes == 1){
    img = loadImage("gun.png");
    invaders = loadImage("invader.png");
    fond = loadImage("noir.jpg");
    }
   if (themes == 2){
    img = loadImage("blop.png");
    invaders = loadImage("invaderB.png");
    fond = loadImage("tetris.jpg");
    frameRate(150);
    }
   
   if (debut > 0 && debutpartie == true){
   meilleurScore=0;
   debut--;
  }

}
//////////////////////////////////////////////////////////////
//
// La boucle de rendu
//
//////////////////////////////////////////////////////////////
void draw() {
  background(fond);
  if (lanceBullet == true){
  goBullet();
  }
  control();
  repaint(); 
  
  if (compte % periodicite == 0 ){
  goInvader();
  compte = 0;
}
compte = compte + 1;
testHit();
drawScore();
// if (endGame == true){ //Plus nécessaire vue qu'on initialise dans void choixThemes
// gameOver();
//}
choixThemes();
}

//////////////////////////////////////////////////////////////
//
// L'initialisation du jeu
//
//////////////////////////////////////////////////////////////
void newGame() {
  canonX = 275;
  canonY = 770;
  vitesseBullet = 8;
  invaderX = 60;
  invaderY = 60;
  periodicite = 50;
  compte = 0;
  vitesseInvader = 25;
  score = 0;
 endGame = false;
  
  
  
  
}

//////////////////////////////////////////////////////////////
//
// Le tir d'un missile
//
//////////////////////////////////////////////////////////////
void fire() {
  bulletX = canonX+22;
  bulletY = canonY;
  lanceBullet = true;

  
}

//////////////////////////////////////////////////////////////
//
// L'animation du missile
//
//////////////////////////////////////////////////////////////
void goBullet() {
    bulletY = bulletY - vitesseBullet;
    if (bulletY <= 0){
      lanceBullet = false;
    }
  
}

//////////////////////////////////////////////////////////////
//
// L'animation de l'invader
//
//////////////////////////////////////////////////////////////
void goInvader() {
  invaderX = invaderX + vitesseInvader;
  if (invaderX >= width -104 || invaderX <= 50){
    invaderY = invaderY + 50;
    vitesseInvader = vitesseInvader * (-1);
  if (periodicite > 10){
    periodicite = periodicite - 2;
  }
  }
  if (invaderY >= height -39){
    endGame = true;
    debutpartie = false;
  }
}

//////////////////////////////////////////////////////////////
//
// La mise à jour de la fenêtre d'animation
// Cette fonction utilise notamment les fonctions :
// - drawGun pour afficher le canon
// - drawInvader pour afficher l'invader
// - drawBullet pour afficher le missile
//
//////////////////////////////////////////////////////////////
void repaint() {
  tint (0,255,0);
  drawGun();
  if (lanceBullet == true){
  drawBullet();
  }
  tint(R,V,B);
  R = 255;
  V = 255;
  B = 255;
  drawInvader();
}

//////////////////////////////////////////////////////////////
//
// L'affichage du canon
//
//////////////////////////////////////////////////////////////
void drawGun() {
  image(img,canonX,canonY);
  
}

//////////////////////////////////////////////////////////////
//
// L'affichage de l'invader
//
//////////////////////////////////////////////////////////////
void drawInvader() {
  image(invaders,invaderX,invaderY);
  
}

//////////////////////////////////////////////////////////////
//
// L'affichage du missile
//
//////////////////////////////////////////////////////////////
void drawBullet() {
  fill(255);
  rect(bulletX,bulletY,3,5);

}

//////////////////////////////////////////////////////////////
//
// Teste si le missile percute l'invader
//
//////////////////////////////////////////////////////////////
void testHit() {
  if (bulletX >= invaderX && bulletX <= (invaderX + 54) && bulletY >= invaderY && bulletY <= (invaderY + 39)){
    lanceBullet = false;
    score ++;
    bulletX = 0;
    bulletY = 0;
    R = 0;
    V = 255;
    B = 0;
     if (score >= meilleurScore){
      meilleurScore = score;
    }
    
    
  }
}

//////////////////////////////////////////////////////////////
//
// L'affichage du score
//
//////////////////////////////////////////////////////////////
void drawScore() {
  textFont(style);
  fill(0,255,0);
  text("Score = " +score,30,30);
  text("Meilleur Score = " +meilleurScore,30,50);
  
}

//////////////////////////////////////////////////////////////
//
// L'affichage du message "GAME OVER"
//
//////////////////////////////////////////////////////////////
void gameOver() {
  background(255);
  textSize(40);
  text("GAME OVER !!!",width/4,height/2);
  textSize(15);
  text("PRESS SPACE BAR TO RESTART",width/4,(height/2)+20 );
//canonX = 0; //Pour que le canon se déplace plus
//vitesseInvader = 0; //Pour que l'invader se déplace plus
}

//////////////////////////////////////////////////////////////
//
// Pilote le canon et contrôle le lancement de missiles
//
//////////////////////////////////////////////////////////////
void control() {
    if (keyPressed == true){ 
    if (keyCode == RIGHT && canonX <= width -51) { 
      canonX = canonX + 5;
   
   }else if (keyCode == LEFT && canonX >= 2) {
      canonX = canonX - 5;  
   }else if (key == ' ' && lanceBullet == false){  
      fire();
   
   }
   else if (key == ' ' && endGame == true){
     newGame();
   }

    }  
}
