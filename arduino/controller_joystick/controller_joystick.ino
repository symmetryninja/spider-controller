#include <Timer.h>                  // A rather useful timer library to offset the comms loop requirement to the motion requirement


#define L_STICK_B 20
#define L_STICK_0 A3
#define L_STICK_1 A4
#define L_SLIDE A5
#define L_TRIGGER_0 21
#define L_TRIGGER_1 22
#define L_BUTTON_1 23
#define L_BUTTON_2 12
#define L_BUTTON_3 11
#define L_BUTTON_4 10
#define L_BUTTON_5 A10
#define L_BUTTON_6 A11

#define L_STICK_B A14
#define R_STICK_0 A0
#define R_STICK_1 A1
#define R_SLIDE A2
#define R_TRIGGER_0 2
#define R_TRIGGER_1 3
#define R_BUTTON_1 4
#define R_BUTTON_2 5
#define R_BUTTON_3 6
#define R_BUTTON_4 7
#define R_BUTTON_5 8
#define R_BUTTON_6 9

struct ControllerState {
  bool LStick_B = false;
  int LStick_0 = 0;
  int LStick_1 = 0;
  int LSlide = 0;

  bool LTrigger0 = false;
  bool LTrigger1 = false;

  bool LButton1 = false;
  bool LButton2 = false;
  bool LButton3 = false;
  bool LButton4 = false;
  bool LButton5 = false;
  bool LButton6 = false;
  //right
  bool RStick_B = false;
  int RStick_0 = 0;
  int RStick_1 = 0;
  int RSlide = 0;

  bool RTrigger0 = false;
  bool RTrigger1 = false;

  bool RButton1 = false;
  bool RButton2 = false;
  bool RButton3 = false;
  bool RButton4 = false;
  bool RButton5 = false;
  bool RButton6 = false;
};

ControllerState currentState;


void setup() {
  Serial.begin(115200);
  pinMode (L_STICK_B, INPUT);
  // pinMode (L_STICK_0, INPUT);
  // pinMode (L_STICK_1, INPUT);
  // pinMode (L_SLIDE, INPUT);
  pinMode (L_TRIGGER_0, INPUT);
  pinMode (L_TRIGGER_1, INPUT);
  pinMode (L_BUTTON_1, INPUT);
  pinMode (L_BUTTON_2, INPUT);
  pinMode (L_BUTTON_3, INPUT);
  pinMode (L_BUTTON_4, INPUT);
  pinMode (L_BUTTON_5, INPUT);
  pinMode (L_BUTTON_6, INPUT);

  // pinMode (R_STICK_B, INPUT);
  // // pinMode (R_STICK_0, INPUT);
  // // pinMode (R_STICK_1, INPUT);
  // // pinMode (R_SLIDE, INPUT);
  // pinMode (R_TRIGGER_0, INPUT);
  // pinMode (R_TRIGGER_1, INPUT);
  // pinMode (R_BUTTON_1, INPUT);
  // pinMode (R_BUTTON_2, INPUT);
  // pinMode (R_BUTTON_3, INPUT);
  // pinMode (R_BUTTON_4, INPUT);
  // pinMode (R_BUTTON_5, INPUT);
  // pinMode (R_BUTTON_6, INPUT);
}

void loop() {
  getState();
  outState();
  delay(500);

}

void getState() {
  currentState.LStick_B = digitalRead(L_STICK_B);
  currentState.LStick_0 = analogRead(L_STICK_0);
  currentState.LStick_1 = analogRead(L_STICK_1);
  currentState.LSlide = analogRead(L_SLIDE);
  currentState.LTrigger0 = digitalRead(L_TRIGGER_0);
  currentState.LTrigger1 = digitalRead(L_TRIGGER_1);
  currentState.LButton1 = digitalRead(L_BUTTON_1);
  currentState.LButton2 = digitalRead(L_BUTTON_2);
  currentState.LButton3 = digitalRead(L_BUTTON_3);
  currentState.LButton4 = digitalRead(L_BUTTON_4);
  currentState.LButton5 = digitalRead(L_BUTTON_5);
  currentState.LButton6 = digitalRead(L_BUTTON_6);
  // currentState.RStick_B = digitalRead(L_STICK_B);
  // currentState.RStick_0 = digitalRead(R_STICK_0);
  // currentState.RStick_1 = digitalRead(R_STICK_1);
  // currentState.RSlide = digitalRead(R_SLIDE);
  // currentState.RTrigger0 = digitalRead(R_TRIGGER_0);
  // currentState.RTrigger1 = digitalRead(R_TRIGGER_1);
  // currentState.RButton1 = digitalRead(R_BUTTON_1);
  // currentState.RButton2 = digitalRead(R_BUTTON_2);
  // currentState.RButton3 = digitalRead(R_BUTTON_3);
  // currentState.RButton4 = digitalRead(R_BUTTON_4);
  // currentState.RButton5 = digitalRead(R_BUTTON_5);
  // currentState.RButton6 = digitalRead(R_BUTTON_6);
}

void outState() {
  Serial.print("LStick_B : ");
  Serial.println(currentState.LStick_B);
  Serial.print("LStick_0 : ");
  Serial.println(currentState.LStick_0);
  Serial.print("LStick_1 : ");
  Serial.println(currentState.LStick_1);
  Serial.print("LSlide : ");
  Serial.println(currentState.LSlide);
  Serial.print("LTrigger0 : ");
  Serial.println(currentState.LTrigger0);
  Serial.print("LTrigger1 : ");
  Serial.println(currentState.LTrigger1);
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

  // Serial.print("RStick_B : ");
  // Serial.println(currentState.RStick_B);
  // Serial.print("RStick_0 : ");
  // Serial.println(currentState.RStick_0);
  // Serial.print("RStick_1 : ");
  // Serial.println(currentState.RStick_1);
  // Serial.print("RSlide : ");
  // Serial.println(currentState.RSlide);
  // Serial.print("RTrigger0 : ");
  // Serial.println(currentState.RTrigger0);
  // Serial.print("RTrigger1 : ");
  // Serial.println(currentState.RTrigger1);
  // Serial.print("RButton1 : ");
  // Serial.println(currentState.RButton1);
  // Serial.print("RButton2 : ");
  // Serial.println(currentState.RButton2);
  // Serial.print("RButton3 : ");
  // Serial.println(currentState.RButton3);
  // Serial.print("RButton4 : ");
  // Serial.println(currentState.RButton4);
  // Serial.print("RButton5 : ");
  // Serial.println(currentState.RButton5);
  // Serial.print("RButton6 : ");
  // Serial.println(currentState.RButton6);

}