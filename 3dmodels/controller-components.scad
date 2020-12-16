  // momentary button & cap

  module component_momentary_button_12_cap() {
    translateZ(6) ccylinder(d = 13, h = 1.4);
    translateZ(8) ccylinder(d = 11.5, h = 5.2);
  }

  module component_momentary_button_12() {
    // base
    black() ccube([12,12,3.6]);
    // legs
    silver() mirrorX() mirrorY() translate([3.2, 6, -2]) ccube([1,1, 4.5]);
    // button
    translateZ(2.8) ccube([4,4,7]);
  }

  module component_slider(position = 50, for_cutout=false) {
    silver()
    ccube([45.2, 7.6, 7]);
    silver()
    translateX((position/100 * 30) - 15)
    translateZ(7.5) ccube([5, 1.2, 21.5]);
    if (for_cutout) {
      translateZ(7.5) ccube([46, 3, 21.5]);
    }
  }

  module component_momentary_barrel() {
    translateZ(-14.5) {
      black() translateZ(25.1) ccylinder(d = 5.9, h = 3.8);
      silver() translateZ(21.65) ccylinder(d = 4.7, h = 4.1);
      silver() translateZ(16.1) ccylinder(d = 6.5, h = 8);
      silver() translateZ(13) ccylinder(d = 9.4, h = 2.2);
      black() translateZ(9) ccylinder(d = 7.5, h = 6);
      silver() translateZ(3) mirrorX() translateX(1.9) ccube([0.6, 2, 6]);
    }
  }

  module component_barrel_power_switch(for_cutout = false) {
    full_H = 34;
    if (for_cutout) {
      // square block
      translateZ(full_H/2 - 23)
      ccube([15,22,15]);
    }
    black() {
      // barrel lg
      translateZ(full_H/2 - 12.5)
      ccylinder(d = 12, h = 15);
      // barrel sm
      translateZ(-3.25)
      ccylinder(d = 10, h = full_H-6.5);
      // sq button
      translateZ(full_H/2 - 5.5)
      ccube([11,11,11]);
      // sq barrel
      translateZ(full_H/2 - 7.5)
      ccube([15,15,6.5]);
    }
    silver() {
      // pins
      translateZ(-full_H/2) {
        translateY(3) ccube([2, 0.5, 10]);
        translateY(-3) ccube([2, 0.5, 10]);
      }
    }
  }