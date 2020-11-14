include <sn_tools.scad>
include <power_supplies.scad>
include <controller-components.scad>

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 50;
    // sc_place_components();
    // sc_shell_mock();
    sc_shell_screen_frame();
    

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
  sc_battery_rotation = [240, 0, 0];
  sc_battery_offset = [-42, 40, -22];
  sc_pi_offset = [30, -30, -8];
  sc_pi_rotation = [180, 0, -90];
  sc_teensy_offset = [-40, -40,-4];
  sc_teensy_rotation = [180, 0, -90];
  sc_bucky_offset = [-40, 5, -4];
  sc_bucky_rotation = [180, 0, 90];

  sc_trigger_R_offset = [-115, -60, -12];

  sc_power_switch_offset= [-90, -60, -5];
  sc_screen_pi_lugs = [58,49];


/** non-print parts **/
  module sc_place_components() {
    // power switch
    translate(sc_power_switch_offset) rotate([90,0,0]) component_barrel_power_switch();
    // buttons
      // right x buttons
      translate(sc_button_group_R_offset) sc_button_group_R();
      translate(sc_button_group_L_offset) sc_button_group_L();

      // triggers
      mirrorX()
      translate(sc_trigger_R_offset) {
        translate([-15,0,6]) rotateX(90) component_momentary_barrel();
        translate([0,0,-6]) rotateX(90) component_momentary_barrel();
      }
      // left & right stick
      mirrorX() translate(sc_joystick_offset) sc_joystick();

      // left slider
      translate(sc_slider_L_offset) rotateZ(90) component_slider();

      // right slider
      translate(sc_slider_R_offset) rotateZ(90) component_slider();

    // batteries
      mirrorX() translate(sc_battery_offset) rotate(sc_battery_rotation) battery_holder_dual_18650(withBatteries=true);

    // screen
      translate(sc_screen_offset) sc_screen();
    // boards
      // pi
      translate(sc_pi_offset) rotate(sc_pi_rotation) import("stl/pi3BModel.stl", convexity=3);

      // teensy
      translate(sc_teensy_offset) rotate(sc_teensy_rotation) sc_board_teensy();

      // bucky
      translate(sc_bucky_offset) rotate(sc_bucky_rotation) make_power_supply_bucky_5a();

      // right button board
      // left button board
      // screenframeboards
  }

    
// components
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
            
            // power plug
            translate([67.5,-20.5,-5]) ccube([10,15, 20]);
            // usb touch plug
            translate([65,20.5,-5]) ccube([10,15, 20]);
            
            // side buttons
            translate([-79.51, 0, -5]) ccube([10, 55, 10]);

            // pcb
            ccube([165, 107, 1.8]);
            mirrorX() translateX(80.5) hull() {
              translateY(58) ccylinder(d = 8, h = 1.8);
              translateY(-58) ccylinder(d = 8, h = 1.8);
            }
          }
          silver() sc_screen_pi_lugs();
          if (for_cutout) sc_screen_cutouts();
        }
        #union() {
          if (!for_cutout) sc_screen_cutouts();
        }
      }

    }

    module sc_screen_cutouts(for_cutout=false) {
      make_drill_holes(size=[161,116,20], shaftD=3);
      sc_screen_pi_lugs(true);
    }

    module sc_screen_pi_lugs(for_cutout=false) {
      /* pi bolts
      square = 49.5 57.5
      top/bottom 26.5 w 5mm lug (so 29)
      43.5 left (back facing)
      63.5
      */
      if (for_cutout) {
        translate([-10,0,-3.3]) make_drill_holes(size=[sc_screen_pi_lugs[0],sc_screen_pi_lugs[1],15], shaftD=3.5);
      }
      else {
        translate([-10,0,-3.3]) make_drill_holes(size=[sc_screen_pi_lugs[0],sc_screen_pi_lugs[1],7], shaftD=5);
      }
    }


  // battery & cage
  // teensy board

  module sc_board_teensy() {
    // greenboard
    make_protoboard_40_60(corner_screws=3.3, pin_holes=true);
    // teensy 3.6
    translate([0, 0.5*2.54, 12])
    component_make_teensy_32();

    // resistors (6)
    for (i = [0:2])
    translate([3.5*2.54, ((-8.5 + i) * -2.54), 0])
    rotateZ(90)
    component_resistor_vertical();

    for (i = [0:2])
    translate([-4.5*2.54 + (i * -2.54), 6.5*-2.54, 0])
    component_resistor_vertical();

    // input strips (13 * 2) - 16?
    mirrorY() translate([-3*2.54, 8 * 2.54, 0]) component_make_header_pin_range(2, 8);

    // input power
    translate([4*2.54, 7.5 * -2.54, 0]) component_make_header_pin_range(1, 2);
    // spi/i2c
    mirrorY() translate([-6.5*-2.54, 7.5 * -2.54, 0]) component_make_header_pin_range(3, 1);
  }

  module sc_board_teensy_cutouts(for_cutout=false) {
// make_protoboard_screws(size_X=30, size_Y=40, corner_screws=2.5, corner_screw_edge=1.3, screw_length=20, hex_size=[5,5], screw_purchase=2)

  }


  module sc_board_teensy_cutouts() {

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

    module sc_core_part_frame() {
      // screen
      // pi

      // bucky

      // batteries

      // teensy board
    }

    module sc_shell_top() {
      
    }
    
    module sc_shell_bottom() {
      
    }
    
    module sc_shell_screen_frame() {
      purple()
      difference() {
        union() {
          // box supports
          translate([-70, 27.5, 1]) rotateZ(45)ccube([5,15,2]);
          translate([-3, 22.5, 1]) rotateZ(-15)ccube([10,15,2]);
          translate([50, 0, 1]) ccube([5,80,2]);
          translate([77, -10, 1]) ccube([5,80,2]);
          translate([-70, -20, 1]) ccube([5,80,2]);
          translate([-5, -20, 1]) ccube([5,80,2]);
          // screen
          translateZ(-7.8)
          translate(sc_screen_offset) {
            // pcb
            hull() mirrorX() translateX(80.5)  {
              translateY(58) ccylinder(d = 8, h = 1.8);
              translateY(-58) ccylinder(d = 8, h = 1.8);
            }
          }
          // pi board
          translateZ(2.5)
          sc_pi_cutouts(shaft_D=7, shaft_H=5);

          // teensy board

          translate([sc_teensy_offset[0],sc_teensy_offset[1],sc_teensy_offset[2]+3.2]) rotate(sc_teensy_rotation) make_drill_holes(size = [36,56,5], shaftD=7);

          // bucky board
          translate([sc_bucky_offset[0],sc_bucky_offset[1],sc_bucky_offset[2]+3.2]) rotate(sc_bucky_rotation) make_power_supply_bucky_5a_screws(height = 5, screw_diameter = 7);

          // battery mounts
          translate([0,sc_battery_offset[1],sc_battery_offset[2]]) rotate(sc_battery_rotation) translate([0,-8,-1.5]) ccube([160, 37.8, 3]);
          mirrorX() translate([77.5,sc_battery_offset[1] -2,sc_battery_offset[2] + 11.5]) rotate([-90,0,90]) make_triangle(size=[30,25,5]);
          mirrorX() translate([47,sc_battery_offset[1] -2,sc_battery_offset[2] + 11.5]) rotate([-90,0,90]) make_triangle(size=[30,25,5]);
          translate([0,sc_battery_offset[1]-2,sc_battery_offset[2] + 11.5]) rotate([-90,0,90]) make_triangle(size=[30,25,5]);

          //TODO: side mounts
        }
        #union() {
          sc_shell_screen_frame_cutouts();
        }
      }
    }


    module sc_shell_screen_frame_cutouts() {

      // box cutouts
      translate(sc_screen_offset) {
        translate([40,-10,-7.8]) makeRoundedBox([20,30,10]);
        translate([10,0,-7.8]) makeRoundedBox([20,20,10]);
        translate([-40,0,-7.8]) makeRoundedBox([40,20,10]);
        translate([-40,-45,-7.8]) makeRoundedBox([40,20,10]);
      }
      
      // screen
      translate(sc_screen_offset) sc_screen(for_cutout=true);
      translate([-79.51, 22.5, -5]) ccube([10, 10, 10]);


      // pi board
      sc_pi_cutouts();

      // teensy board
      translate(sc_teensy_offset) rotate(sc_teensy_rotation) make_drill_holes(size = [36,56,15], shaftD=2.9);

      // bucky board
      translate(sc_bucky_offset) rotate(sc_bucky_rotation) make_power_supply_bucky_5a_screws(height = 15, screw_diameter = 2.9);

      // battery mounts
      mirrorX() translate(sc_battery_offset) rotate(sc_battery_rotation) translateZ(2) battery_holder_dual_18650_bolts(withHexBlank=false);

      //TODO: side mounts


    }

    module sc_pi_cutouts(shaft_D=2.9, shaft_H=15) {
    translate([-5.3, 15.9, 5]) 
    translate(sc_pi_offset) 
    rotate(sc_pi_rotation)
      make_drill_holes(size=[sc_screen_pi_lugs[0],sc_screen_pi_lugs[1],shaft_H], shaftD=shaft_D);
    }

    module sc_shell_clearpanel() {
      
    }
