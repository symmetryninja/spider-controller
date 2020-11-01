include <sn_tools.scad>
include <power_supplies.scad>
include <controller-components.scad>

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 20;
    sc_place_components();
    sc_shell_mock();
  }

/** tooling modules **/

// parts to print
  module sc_parts_for_print() {
    // 
  }


/** globals **/
  sc_joystick_offset = [-120, 12, 0];
  sc_screen_offset = [0, 0, 10];
  sc_button_group_R_offset = [-135, -40, 7];
  sc_button_group_L_offset = [-sc_button_group_R_offset[0], sc_button_group_R_offset[1], sc_button_group_R_offset[2]];
  sc_slider_R_offset = [-95, -40, sc_button_group_R_offset[2] + 3];
  sc_slider_L_offset = [-sc_slider_R_offset[0], sc_slider_R_offset[1], sc_slider_R_offset[2]];
  sc_battery_R_offset = [-42, 40, 0];
  sc_battery_L_offset = [-sc_battery_R_offset[0], sc_battery_R_offset[1], sc_battery_R_offset[2]];

  sc_trigger_R_offset = [-115, -60, -12];
  sc_trigger_L_offset = [-sc_trigger_R_offset[0], sc_trigger_R_offset[1], sc_trigger_R_offset[2]];

  sc_power_switch_offset= [-90, -60, -5];

/** non-print parts **/
  module sc_place_components() {
    // power switch
    translate(sc_power_switch_offset)
    rotate([90,0,0])
    component_barrel_power_switch();
    // buttons
      // right x buttons
      translate(sc_button_group_R_offset) {
        sc_button_group_R();
      }
      translate(sc_button_group_L_offset) {
        sc_button_group_L();
      }
      // triggers
      translate(sc_trigger_R_offset) {
        rotateX(90) {
          translateY(6) component_momentary_barrel();
          translateY(-6) component_momentary_barrel();
        }
      }
      translate(sc_trigger_L_offset) {
        rotateX(90) {
          translateY(6) component_momentary_barrel();
          translateY(-6) component_momentary_barrel();
        }
      }
      // left & right stick
      mirrorX() {
        translate(sc_joystick_offset) sc_joystick();
      }
      // left slider
      translate(sc_slider_L_offset) {
        rotateZ(90)
        component_slider();
      }
      // right slider
      translate(sc_slider_R_offset) {
        rotateZ(90)
        component_slider();
      }

    // batteries
      translate(sc_battery_R_offset) {
        rotate([180, 0, 0])
        battery_holder_dual_18650(withBatteries=true);
      }
      translate(sc_battery_L_offset) {
        rotate([180, 0, 0])
        battery_holder_dual_18650(withBatteries=true);
      }

    // screen
      translate(sc_screen_offset) {
        sc_screen();
      }
    // boards
      // pi
      translate([30, -30, -5])
      rotate([180, 0, -90])
        import("stl/pi3BModel.stl", convexity=3);

      // teensy
      translate([-50, -55, -10])
      rotate([180, 0, 0])
      component_make_teensy_32();

      // bucky
      translate([-45, -5, -1])
      rotate([180, 0, 90])
      make_power_supply_bucky_5a();

      // right button board
      // left button board
      // screenframeboards
  }

/** modules for print **/

  // main shells
    module sc_shell_mock() {
      mirrorX()
      progressive_hull() {
        translate([-60, -57, -0]) make_sphered_box(size=[50,20,30], d=15);
        translate([-125, -60, -10]) make_sphered_box(size=[70,20,50], d=15);
        translate([-115, -0, -0]) make_sphered_box(size=[90,90,30], d=15);
        translate([-105, 50, -10]) make_sphered_box(size=[50,20,50], d=15);
        translate([0, 60, -5]) make_sphered_box(size=[50,20,40], d=15);
      }
    }

    module sc_shell_top() {
      
    }
    
    module sc_shell_bottom() {
      
    }
    
    module sc_shell_frame() {
      // screen

      // left boards

      // right boards

      // processor boards

      // battery mounts
      
    }

    module sc_shell_clearpanel() {
      
    }
  
// components

  // square buttons

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

  module component_slider(position = 50) {
    silver()
    ccube([45.2, 7.6, 7]);
    silver()
    translateX((position/100 * 30) - 15)
    translateZ(7.5) ccube([5, 1.2, 21.5]);
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

  module sc_button_group_R() {
    offset = 11.5;

    translate([offset * 2 + 2.54, offset, 0]) {
      component_momentary_button_12();
      white()
      component_momentary_button_12_cap();
    }

    translate([offset * 2 + 2.54, -offset, 0]) {
      component_momentary_button_12();
      white()
      component_momentary_button_12_cap();
    }

    translateX(offset) {
      component_momentary_button_12();
      blue()
      component_momentary_button_12_cap();
    }

    translateX(-offset) {
      component_momentary_button_12();
      red()
      component_momentary_button_12_cap();
    }

    translateY(offset) {
      component_momentary_button_12();
      green()
      component_momentary_button_12_cap();
    }

    translateY(-offset) {
      component_momentary_button_12();
      component_momentary_button_12_cap();
    }
  }

  module sc_button_group_L_pad() {

  }

  module sc_button_group_L() {
    offset = 11.5;

    translate([-(offset * 2 + 2.54), offset, 0]) {
      component_momentary_button_12();
      white()
      component_momentary_button_12_cap();
    }

    translate([-(offset * 2 + 2.54), -offset, 0]) {
      component_momentary_button_12();
      white()
      component_momentary_button_12_cap();
    }

    translateX(offset) {
      green()
      component_momentary_button_12_cap();
      component_momentary_button_12();
    }

    translateX(-offset) {
      green()
      component_momentary_button_12_cap();
      component_momentary_button_12();
    }

    translateY(offset) {
      green()
      component_momentary_button_12_cap();
      component_momentary_button_12();
    }

    translateY(-offset) {
      green()
      component_momentary_button_12_cap();
      component_momentary_button_12();
    }
  }

  // slider

  // joystick
    module sc_joystick_inv(for_cutout = false) {
      mirror([1, 0, 0]) sc_joystick(for_cutout = for_cutout);
    }

    module sc_joystick(for_cutout = false) {
      // shaft
      silver()
      translateZ(12.5) ccylinder(d=8, h = 50);
      difference() {
        union(){
          black() {
            // round
            ccylinder(d = 42, h = 25);
            // crosshair
            translateZ(0.8) {
              ccube([1, 37, 25]);
              ccube([37, 1, 25]);
            }
            // square
            translate([0, 1, -1.25]) ccube([43, 45, 23]);
            make_drill_holes(size=[39,39,25], shaftD=5);

            // lock/unlock
            translate([24, 0, -5]) {
              rotateY(90) rotateZ(-90)make_pie_slice(d=40, h = 4.5, angle=70);
              rotateY(90) rotateZ(-10)make_pie_slice(d=30, h = 3, angle=200);
              translateZ(16) ccube([3.5, 6, 20]);
            }
          }

          //component cutout
          if (!for_cutout) {
            translateZ(-5)
            %ccube([58, 58, 28]);
          }



        }
        #union() {
          black()
          sc_joystick_cutouts();
        }
      }


    }

    module sc_joystick_cutouts() {
      // top screws
      make_drill_holes(size=[39,39,30], shaftD=2.5);

      // upper cavity
      difference() {
        hull() {
          translateZ(13)
          ccube([30, 22, 1]);
          translateZ(5)
          ccube([25, 15, 1]);
        }
        translateZ(-5)
        rotateY(90)
        ccylinder(d = 30, h = 35);

      }


    }


  // screen
    module sc_screen(for_cutout=false) {
      difference() {
        union() {
          black() {
            // panel
            translateZ(2.2)
            ccube([165, 100, 6.18]);
            // pcb
            ccube([165, 107, 1.8]);
            mirrorX()
            translateX(80.5)
            hull() {
              translateY(58) ccylinder(d = 8, h = 1.8);
              translateY(-58) ccylinder(d = 8, h = 1.8);
            }
          }
        }
        #union() {
          sc_screen_cutouts();
        }
      }

    }

    module sc_screen_cutouts(for_cutout=false) {
      make_drill_holes(size=[161,116,8], shaftD=3);

    }


  // battery & cage

  // bucky

