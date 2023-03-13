// #include <Timer.h>                  // A rather useful timer library to offset the comms loop requirement to the motion requirement

// pin definitions 
  #define L_STICK_UD      A3
  #define L_STICK_LR      A4
  #define L_SLIDE         A5
  #define L_TRIGGER_T     21
  #define L_TRIGGER_B     22
  #define L_BUTTON_1      15
  #define L_BUTTON_2      16
  #define L_BUTTON_3      23
  #define L_BUTTON_4      12
  #define L_BUTTON_5      11
  #define L_BUTTON_6      10

  #define R_STICK_UD      A10
  #define R_STICK_LR      A11
  #define R_SLIDE         A14
  #define R_TRIGGER_T       2
  #define R_TRIGGER_B       3
  #define R_BUTTON_1        4
  #define R_BUTTON_2        5
  #define R_BUTTON_3        6
  #define R_BUTTON_4        9
  #define R_BUTTON_5        8
  #define R_BUTTON_6        7

/* input filtering */
  #define AFILTER 16
  #define L_STICK_UD_MIN 80
  #define L_STICK_UD_MID 520
  #define L_STICK_UD_MAX 905
  #define L_STICK_LR_MIN 910
  #define L_STICK_LR_MID 480
  #define L_STICK_LR_MAX 55
  #define R_STICK_UD_MIN 80
  #define R_STICK_UD_MID 500
  #define R_STICK_UD_MAX 905
  #define R_STICK_LR_MIN 905
  #define R_STICK_LR_MID 471
  #define R_STICK_LR_MAX 55

/* general stuff */
  int minRefreshCycle = 200; //hz
  uint16_t loops = 0;

/* state struct */
  struct ControllerState {
    uint16_t LStick_UD = 0;
    uint16_t LStick_LR = 0;
    uint16_t LSlide = 0;

    bool LTriggerT = false;
    bool LTriggerB = false;

    bool LButton1 = false;
    bool LButton2 = false;
    bool LButton3 = false;
    bool LButton4 = false;
    bool LButton5 = false;
    bool LButton6 = false;
    //right
    uint16_t RStick_UD = 0;
    uint16_t RStick_LR = 0;
    uint16_t RSlide = 0;

    bool RTriggerT = false;
    bool RTriggerB = false;

    bool RButton1 = false;
    bool RButton2 = false;
    bool RButton3 = false;
    bool RButton4 = false;
    bool RButton5 = false;
    bool RButton6 = false;
  };

ControllerState lastState;
ControllerState currentState;

void setup() {
  Serial.begin(115200);
  Joystick.useManualSend(true);

  pinMode (L_TRIGGER_T, INPUT_PULLUP);
  pinMode (L_TRIGGER_B, INPUT_PULLUP);
  pinMode (L_BUTTON_1, INPUT_PULLUP);
  pinMode (L_BUTTON_2, INPUT_PULLUP);
  pinMode (L_BUTTON_3, INPUT_PULLUP);
  pinMode (L_BUTTON_4, INPUT_PULLUP);
  pinMode (L_BUTTON_5, INPUT_PULLUP);
  pinMode (L_BUTTON_6, INPUT_PULLUP);

  pinMode (R_TRIGGER_T, INPUT_PULLUP);
  pinMode (R_TRIGGER_B, INPUT_PULLUP);
  pinMode (R_BUTTON_1, INPUT_PULLUP);
  pinMode (R_BUTTON_2, INPUT_PULLUP);
  pinMode (R_BUTTON_3, INPUT_PULLUP);
  pinMode (R_BUTTON_4, INPUT_PULLUP);
  pinMode (R_BUTTON_5, INPUT_PULLUP);
  pinMode (R_BUTTON_6, INPUT_PULLUP);
}

void loop() {
  getState();
  compareState();
  loops = (loops + 1) & 0xFFFF;
  delay(1000/minRefreshCycle);
}

void compareState() {
  if (!(
    currentState.LStick_UD == lastState.LStick_UD &&
    currentState.LStick_LR == lastState.LStick_LR &&
    currentState.LSlide == lastState.LSlide &&
    currentState.LTriggerT == lastState.LTriggerT &&
    currentState.LTriggerB == lastState.LTriggerB &&
    currentState.LButton1 == lastState.LButton1 &&
    currentState.LButton2 == lastState.LButton2 &&
    currentState.LButton3 == lastState.LButton3 &&
    currentState.LButton4 == lastState.LButton4 &&
    currentState.LButton5 == lastState.LButton5 &&
    currentState.LButton6 == lastState.LButton6 &&
    currentState.RStick_UD == lastState.RStick_UD &&
    currentState.RStick_LR == lastState.RStick_LR &&
    currentState.RSlide == lastState.RSlide &&
    currentState.RTriggerT == lastState.RTriggerT &&
    currentState.RTriggerB == lastState.RTriggerB &&
    currentState.RButton1 == lastState.RButton1 &&
    currentState.RButton2 == lastState.RButton2 &&
    currentState.RButton3 == lastState.RButton3 &&
    currentState.RButton4 == lastState.RButton4 &&
    currentState.RButton5 == lastState.RButton5 &&
    currentState.RButton6 == lastState.RButton6
  )) {
    outState();
    joystick710Send();
    mergeState();
  }

}

void joystick710Send() {
  // analogs
  Joystick.X(currentState.LStick_LR);
  Joystick.Y(currentState.LStick_UD);
  Joystick.Zrotate(currentState.RStick_UD);
  Joystick.Z(currentState.RStick_LR);
  Joystick.sliderLeft(currentState.LSlide);
  Joystick.sliderRight(currentState.RSlide);

  // hat
  // -1 - aka nothing touched
  int hatState = -1;
  if (currentState.LButton4) hatState = 0;
  if (currentState.LButton3) hatState = 90;
  if (currentState.LButton6) hatState = 180;
  if (currentState.LButton5) hatState = 270;
  if (currentState.LButton4 && currentState.LButton3) hatState = 45;
  if (currentState.LButton3 && currentState.LButton6) hatState = 135;
  if (currentState.LButton6 && currentState.LButton5) hatState = 225;
  if (currentState.LButton5 && currentState.LButton4) hatState = 315;

  Joystick.hat(hatState);
  // pushbuttons
  Joystick.button(5, currentState.LTriggerT);
  Joystick.button(7, currentState.LTriggerB);
  Joystick.button(9, currentState.LButton1);
  Joystick.button(11, currentState.LButton2);
  Joystick.button(6, currentState.RTriggerT);
  Joystick.button(8, currentState.RTriggerB);
  Joystick.button(10, currentState.RButton1);
  Joystick.button(12, currentState.RButton2);
  Joystick.button(1, currentState.RButton3);
  Joystick.button(4, currentState.RButton4);
  Joystick.button(3, currentState.RButton5);
  Joystick.button(2, currentState.RButton6);
  
  Joystick.send_now();
  
  // special override for keyboard hat left & right to force the screen to wake after deep sleep
  if (currentState.LButton3 && currentState.LButton5) {
    Keyboard.set_modifier(MODIFIERKEY_ALT);
    Keyboard.send_now();
    Keyboard.set_modifier(0);
    Keyboard.send_now();
  }
}

void mergeState() {
  lastState.LStick_UD = currentState.LStick_UD;
  lastState.LStick_LR = currentState.LStick_LR;
  lastState.LSlide = currentState.LSlide;
  lastState.LTriggerT = currentState.LTriggerT;
  lastState.LTriggerB = currentState.LTriggerB;
  lastState.LButton1 = currentState.LButton1;
  lastState.LButton2 = currentState.LButton2;
  lastState.LButton3 = currentState.LButton3;
  lastState.LButton4 = currentState.LButton4;
  lastState.LButton5 = currentState.LButton5;
  lastState.LButton6 = currentState.LButton6;
  lastState.RStick_UD = currentState.RStick_UD;
  lastState.RStick_LR = currentState.RStick_LR;
  lastState.RSlide = currentState.RSlide;
  lastState.RTriggerT = currentState.RTriggerT;
  lastState.RTriggerB = currentState.RTriggerB;
  lastState.RButton1 = currentState.RButton1;
  lastState.RButton2 = currentState.RButton2;
  lastState.RButton3 = currentState.RButton3;
  lastState.RButton4 = currentState.RButton4;
  lastState.RButton5 = currentState.RButton5;
  lastState.RButton6 = currentState.RButton6;
}

void getState() {
  // get the analog values with filter & min/max mapping
  currentState.LStick_UD = analogMapFilter(analogRead(L_STICK_UD), L_STICK_UD_MIN, L_STICK_UD_MID, L_STICK_UD_MAX);
  currentState.LStick_LR = analogMapFilter(analogRead(L_STICK_LR), L_STICK_LR_MIN, L_STICK_LR_MID, L_STICK_LR_MAX);

  currentState.RStick_UD = analogMapFilter(analogRead(R_STICK_UD), R_STICK_UD_MIN, R_STICK_UD_MID, R_STICK_UD_MAX);
  currentState.RStick_LR = analogMapFilter(analogRead(R_STICK_LR), R_STICK_LR_MIN, R_STICK_LR_MID, R_STICK_LR_MAX);
  
  currentState.LSlide = ((analogRead(L_SLIDE) / AFILTER) & 0xFFFF) * AFILTER;
  currentState.RSlide = ((analogRead(R_SLIDE) / AFILTER) & 0xFFFF) * AFILTER;

  currentState.LTriggerT = digitalRead(L_TRIGGER_T);
  currentState.LTriggerB = digitalRead(L_TRIGGER_B);
  currentState.LButton1 = digitalRead(L_BUTTON_1);
  currentState.LButton2 = digitalRead(L_BUTTON_2);
  currentState.LButton3 = digitalRead(L_BUTTON_3);
  currentState.LButton4 = digitalRead(L_BUTTON_4);
  currentState.LButton5 = digitalRead(L_BUTTON_5);
  currentState.LButton6 = digitalRead(L_BUTTON_6);

  currentState.RTriggerT = digitalRead(R_TRIGGER_T);
  currentState.RTriggerB = digitalRead(R_TRIGGER_B);
  currentState.RButton1 = digitalRead(R_BUTTON_1);
  currentState.RButton2 = digitalRead(R_BUTTON_2);
  currentState.RButton3 = digitalRead(R_BUTTON_3);
  currentState.RButton4 = digitalRead(R_BUTTON_4);
  currentState.RButton5 = digitalRead(R_BUTTON_5);
  currentState.RButton6 = digitalRead(R_BUTTON_6);
}

uint16_t analogMapFilter(long input, int low, int middle, int high) {
  if (input > middle) {
    return ((map(input, middle, high, 512,1023) / AFILTER) & 0xFFFF) * AFILTER;
  }
  else if (input < middle) {
    return ((map(input, low, middle, 0,512) / AFILTER) & 0xFFFF) * AFILTER;
  }
  return 512;
}

void outState() {
  Serial.println("");
  Serial.print("loops : ");
  Serial.println(loops);
  Serial.println("---- LEFT ----");
  Serial.print("LStick_UD : ");
  Serial.println(currentState.LStick_UD);
  Serial.print("LStick_LR : ");
  Serial.println(currentState.LStick_LR);
  Serial.print("LSlide : ");
  Serial.println(currentState.LSlide);
  Serial.print("LTriggerT : ");
  Serial.println(currentState.LTriggerT);
  Serial.print("LTriggerB : ");
  Serial.println(currentState.LTriggerB);
  Serial.print("LButton1 : ");
  Serial.println(currentState.LButton1);
  Serial.print("LButton2 : ");
  Serial.println(currentState.LButton2);
  Serial.print("LButton3 : ");
  Serial.println(currentState.LButton3);
  Serial.print("LButton4 : ");
  Serial.println(currentState.LButton4);
  Serial.print("LButton5 : ");
  Serial.println(currentState.LButton5);
  Serial.print("LButton6 : ");
  Serial.println(currentState.LButton6);
  Serial.println("");
  Serial.println("---- RIGHT ----");
  Serial.print("RStick_UD : ");
  Serial.println(currentState.RStick_UD);
  Serial.print("RStick_LR : ");
  Serial.println(currentState.RStick_LR);
  Serial.print("RSlide : ");
  Serial.println(currentState.RSlide);
  Serial.print("RTriggerT : ");
  Serial.println(currentState.RTriggerT);
  Serial.print("RTriggerB : ");
  Serial.println(currentState.RTriggerB);
  Serial.print("RButton1 : ");
  Serial.println(currentState.RButton1);
  Serial.print("RButton2 : ");
  Serial.println(currentState.RButton2);
  Serial.print("RButton3 : ");
  Serial.println(currentState.RButton3);
  Serial.print("RButton4 : ");
  Serial.println(currentState.RButton4);
  Serial.print("RButton5 : ");
  Serial.println(currentState.RButton5);
  Serial.print("RButton6 : ");
  Serial.println(currentState.RButton6);

}