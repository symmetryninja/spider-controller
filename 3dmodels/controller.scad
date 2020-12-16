include <sn_tools.scad>
include <power_supplies.scad>
include <controller-components.scad>

/** project
  Phase 1: working with controller mounted and wired
    * core
      * screen frame fixes
        * side buttons (screen momentary switches)
        * increase space between frame and screen by 2 mm

  phase 2: joystick working

  phase 3: Charger

**/

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 20;
    // sc_place_components();
    // sc_shell_mock();
    sc_shell_screen_frame();
    // difference() {
      purple() sc_shell_top();
      translateZ(-0.2) blue() sc_shell_bottom_sides();

      translateZ(-0.1) red() sc_shell_bottom_battery();
    //   #ccube([0.01, 200, 50]);
    // }

  }


/** tooling modules **/

// parts to print
  module sc_parts_for_print() {
    // 
  }

/** globals **/
  sc_joystick_offset = [-112, -38, 2];
  sc_screen_offset = [0, 0, 10];
  sc_battery_rotation = [180, 0, 0];
  sc_battery_offset = [-42, 45, -7];
  sc_pi_offset = [30, -30, -8];
  sc_pi_rotation = [180, 0, -90];
  sc_teensy_offset = [-38, -40,-4];
  sc_teensy_rotation = [180, 0, -90];
  sc_bucky_offset = [-31, 2, -4];
  sc_bucky_rotation = [180, 0, 90];
  sc_trigger_offset = [145, -60, 0];

  sc_button_board_offset_R = [-110, 30, 5];
  sc_button_board_offset_L = [-sc_button_board_offset_R[0], sc_button_board_offset_R[1], sc_button_board_offset_R[2]];
  sc_button_board_rotation_Z = 90;

  sc_power_switch_offset= [-140, 5, -10];
  sc_screen_pi_lugs = [58,49];

/** non-print parts **/
  module sc_place_components() {
    // power switch
    translate(sc_power_switch_offset) rotate([90,0,-90]) component_barrel_power_switch();
    // buttons
      // left & right stick
      mirrorX() translate(sc_joystick_offset) sc_joystick();

    sc_button_board_L();
    sc_button_board_R();

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
      translate(sc_bucky_offset) rotate(sc_bucky_rotation) sc_bucky();

      // triggers
      mirrorX() translate(sc_trigger_offset) sc_triggers();
  }

  module sc_bucky() {
    green()
    difference() {
      ccube([37, 47, 1.5]);
      #sc_bucky_screws();
    }
  }

  module sc_bucky_screws(d=2.9, h=2) {
    mirrorX() translateX(15)
      translateY(42/2)
      ccylinder(h = h, d = d);
    translateX(-15)
      translateY(-38/2)
      ccylinder(h = h, d = d);
    translateX(15)
      translateY(-42/2)
      ccylinder(h = h, d = d);

  }

  module sc_bucky_test() {
    difference() {
      union() {
        hull() {
          sc_bucky_screws(d=6, h=2);
        }
        translateZ(4)
          sc_bucky_screws(d=6, h=8);
      }
      union() {
        sc_bucky_screws(h = 20);
      }
    }
  }

// components

  module sc_pushbutton(cap_color="white", os = 0) {
    translateZ(1.5)
    color(cap_color) {
      ccylinder(d=9 + os, h=14.5);
      translateZ(-3.7) ccylinder(d=12 + os, h=7.2);
    }
  }
  
  module sc_button_board_R() {
    translate(sc_button_board_offset_R) sc_button_board();
  }

  module sc_button_board_L() {
    translate(sc_button_board_offset_L) mirror([1,0,0]) sc_button_board(col_1="DarkSlateGray", col_2="DarkSlateGray", col_3="DarkSlateGray", col_4="DarkSlateGray");
  }

  module sc_button_board_panel_extras() {
    translate(sc_button_board_offset_R) sc_button_board_panel_extra();
    translate(sc_button_board_offset_L) mirror([1,0,0]) sc_button_board_panel_extra();
  }

  module sc_button_board_panel_extra() {
    rotateZ(sc_button_board_rotation_Z)
    union() {
      translateZ(5.3) {
        make_drill_holes(size=[66,46,9], shaftD=6);
        translate([-13.68, 0.7, 0])
        ccylinder(d = 6, h = 9);
      }
    }
  }

  module sc_button_board_cutouts() {
    translate(sc_button_board_offset_R) sc_button_board_cutout();
    translate(sc_button_board_offset_L) mirror([1,0,0]) sc_button_board_cutout();
  }

  module sc_button_board_cutout() {
    rotateZ(sc_button_board_rotation_Z) {
      // screws
      make_drill_holes(size=[66,46,25], shaftD=2.6);

      // slider cut out
      translate(sc_slider_R_offset) rotateZ(90) component_slider(for_cutout=true);
    }

    // buttons
    sc_button_board(os=1.5);
  }

  sc_trigger_R_offset = [0, -20, -12];
  sc_button_group_R_offset = [-20, 0, 7];
  sc_slider_R_offset = [24.85, 0, 4.5];

  module sc_button_board(col_1="DarkSlateGray", col_2="red", col_3="green", col_4="yellow", os=0) {
    rotateZ(sc_button_board_rotation_Z) {
      // green board
      rotateZ(90) make_protoboard_50_70();
      // iec box
      translate([23,0,-6])
      black() ccube([9, 28, 9.9]);
      // right slider
      translate(sc_slider_R_offset) rotateZ(90) component_slider();
      // right x buttons
        translate([11.5, -19, 7])
          sc_pushbutton("white", os=os);

        // 23.5 36.44
        translate([-1.44, -19, 7])
          sc_pushbutton("white", os=os);

      translate([-13.68, 0.7, 7]) {

        translate([12.7, 0, 0])
          sc_pushbutton(col_1, os=os);

        translate([-12.7, 0, 0])
          sc_pushbutton(col_2, os=os);

        translate([0, 12.7, 0])
          sc_pushbutton(col_3, os=os);

        translate([0, -12.7, 0])
          sc_pushbutton(col_4, os=os);
      }
    }
  }
  // triggers

  module sc_triggers() {
    // triggers
      translate([0,-5,6]) rotateX(90) component_momentary_barrel();
      translate([0,-5,-6]) rotateX(90) component_momentary_barrel();
  }

  // joystick
    module sc_joysticks_cutouts() {
      mirrorX() translate(sc_joystick_offset) sc_joystick(for_cutout = true);
    }

    module sc_joystick_inv(for_cutout = false) {
      mirror([1, 0, 0]) sc_joystick(for_cutout = for_cutout);
    }

    module sc_joystick(for_cutout = false) {
      // shaft
      silver()
      translateZ(12.5) ccylinder(d=8, h = 50);
      difference() {
        union(){
          // lock/unlock
          if (for_cutout) {
            // round
            ccylinder(d = 44, h = 40);
            //component cutout
            translateZ(-5)
            ccube([58, 58, 28]);
            translate([24, 0, -6]) 
              rotateY(90) rotateZ(-90)make_pie_slice(d=60, h = 6, angle=80);

            translate([20, 0, 15])
              ccube([5, 20, 20]);
            make_drill_holes(size=[39,39,25], shaftD=6);
            make_drill_holes(size=[39,39,40], shaftD=2.5);
          }
          else {
            //component cutout
            translateZ(-5)
            %ccube([58, 58, 28]);
            // square
            translate([0, 1, -1.25]) ccube([43, 45, 23]);
            make_drill_holes(size=[39,39,25], shaftD=5);

            black() {
              // round
              ccylinder(d = 42, h = 25);
              // crosshair
              translateZ(0.8) {
                ccube([1, 37, 25]);
                ccube([37, 1, 25]);
              }
            }
            translate([24, 0, -5]) {
              rotateY(90) rotateZ(-90)make_pie_slice(d=40, h = 4.5, angle=70);
              rotateY(90) rotateZ(-10)make_pie_slice(d=30, h = 3, angle=200);
              translateZ(16) ccube([3.5, 6, 20]);
            }
          }
        }
        union() {
          if (!for_cutout) black() sc_joystick_cutouts();
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
            translate([65,20.5,-5]) ccube([15,20, 20]);
            
            // side buttons
            translate([-77.5, 0, -7]) ccube([13, 55, 15]);

            // pcb
            ccube([165, 107, 1.8]);

            mirrorX() translateX(78.5) hull() {
              translateY(58) ccylinder(d = 8, h = 1.8);
              translateY(-58) ccylinder(d = 8, h = 1.8);
            }
          }
          silver() sc_screen_pi_lugs();
          if (for_cutout) {
            sc_screen_cutouts();
            // panel
            translateZ(2.2)
            ccube([159, 94, 15]);
          }
        }
        #union() {
          if (!for_cutout) sc_screen_cutouts();
        }
      }

    }

    module sc_screen_cutouts(for_cutout=false, d = 3, h = 20) {
      make_drill_holes(size=[157,116,h], shaftD=d);
      if (!for_cutout) sc_screen_pi_lugs(true);
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
    make_protoboard_40_60(corner_screws=3.3, pin_holes=false);
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
    translate([3.5*2.54, 8.5 * -2.54, 0]) component_make_header_pin_range(1, 3);
    // spi/i2c
    mirrorY() translate([-6.5*-2.54, 7.5 * -2.54, 0]) component_make_header_pin_range(3, 1);
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

    sc_shell_positions = [
      [85, -68, 0],
      [152, -68, 0],
      [147, 0, 0],
      [143, 55, 0],
      [137, 70, 0],
      [85, 70, 0],
      [-85, 70, 0],
      [-137, 70, 0],
      [-143, 55, 0],
      [-147, 0, 0],
      [-152, -68, 0],
      [-85, -68, 0],
    ];

    sc_shell_corner_position_count = len(sc_shell_positions);

    sc_top_thickness = 3;
    sc_outer_frame_H = 35;
    sc_frame_part_D = 3;

    module sc_shell_top() {
      difference() {
        union() {
          // top flat
          translateZ(sc_button_board_offset_R[2] + 10)
          hull() {
            for (position = sc_shell_positions) {
              translate(position) {
                csphere(d = sc_frame_part_D );
              }
            }
          }
          // buttons
          sc_button_board_panel_extras();
          // outer frame

          h0 = 50;
          h1 = 45;
          h2 = 35;
          h3 = 25;

          translateZ(-2.5)
          progressive_hull() {
                
            translateZ(-2.5)translate(sc_shell_positions[0]) ccylinder(d = sc_frame_part_D, h = 40);
            translate(sc_shell_positions[1]) ccylinder(d = sc_frame_part_D, h = h2);
            translate(sc_shell_positions[2]) ccylinder(d = sc_frame_part_D, h = h2);
            translateZ(5) translate(sc_shell_positions[3]) ccylinder(d = sc_frame_part_D, h = h3);
            translateZ(5) translate(sc_shell_positions[4]) ccylinder(d = sc_frame_part_D, h = h3);
            translateZ(-5) translate(sc_shell_positions[5]) ccylinder(d = sc_frame_part_D, h = h1);
            translateZ(-5) translate(sc_shell_positions[6]) ccylinder(d = sc_frame_part_D, h = h1);
            translateZ(5) translate(sc_shell_positions[7]) ccylinder(d = sc_frame_part_D, h = h3);
            translateZ(5) translate(sc_shell_positions[8]) ccylinder(d = sc_frame_part_D, h = h3);
            translate(sc_shell_positions[9]) ccylinder(d = sc_frame_part_D, h = h2);
            translate(sc_shell_positions[10]) ccylinder(d = sc_frame_part_D, h = h2);
            translateZ(-2.5)translate(sc_shell_positions[11]) ccylinder(d = sc_frame_part_D, h = 40);
            translateZ(-2.5)translate(sc_shell_positions[0]) ccylinder(d = sc_frame_part_D, h = 40);
          }

          translate(sc_screen_offset)
          translateZ(3.65) sc_screen_cutouts(for_cutout=false, d = 10, h = 5.5);



        }
        union() {
          // buttons
          sc_button_board_cutouts();

          // joysticks
          sc_joysticks_cutouts();

          // screen
          translate(sc_screen_offset) sc_screen(for_cutout=true);

          // ports
          translate([0, -70, -13])
          ccube([100, 20, 25]);

          // bottom panel
          sc_shell_bottom();

          // triggers
          mirrorX() translate(sc_trigger_offset) sc_triggers();


          // screws
        }
      }
    }

    sc_shell_points = [
      [sc_shell_positions[0][0], sc_shell_positions[0][1], -25],
      [sc_shell_positions[1][0], sc_shell_positions[1][1], -20],
      [sc_shell_positions[2][0], sc_shell_positions[2][1], -20],
      [sc_shell_positions[3][0], sc_shell_positions[3][1], -10],
      [sc_shell_positions[4][0], sc_shell_positions[4][1], -10],
      [sc_shell_positions[5][0], sc_shell_positions[5][1], -30],
    ];
    
    module sc_shell_bottom_sides() {
      difference() {
        sc_shell_bottom();
        sc_shell_bottom_cutter(oversize = 0.9);
      }
    }

    module sc_shell_bottom_battery() {
      intersection() {
        sc_shell_bottom();
        sc_shell_bottom_cutter();
      }
    }

    module sc_shell_bottom_cutter(oversize = 0.1) {
      hull() {
        mirrorX() {
          translate([sc_shell_points[0][0] - 8, sc_shell_points[0][1], sc_shell_points[0][2]]) ccube(d = sc_frame_part_D + oversize);
          translate([sc_shell_points[5][0] - 8, sc_shell_points[5][1], sc_shell_points[5][2]]) ccube(d = sc_frame_part_D + oversize);
        }
      }
    }

    module sc_shell_bottom() {
      // angle panels 
        // 012, 235, 345, 025
        part_size = sc_frame_part_D + 0.01;

        mirrorX()
        union() {
          hull() {
            translate(sc_shell_points[0]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[1]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[2]) flat_bottom_sphere(d = part_size, inv = true);
          }

          hull() {
            translate(sc_shell_points[2]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[3]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[5]) flat_bottom_sphere(d = part_size, inv = true);
          }

          hull() {
            translate(sc_shell_points[3]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[4]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[5]) flat_bottom_sphere(d = part_size, inv = true);
          }

          hull() {
            translate(sc_shell_points[0]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[2]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[5]) flat_bottom_sphere(d = part_size, inv = true);
          }
        }
      // lower panel
        hull() {
          mirrorX() {
            translate(sc_shell_points[0]) flat_bottom_sphere(d = part_size, inv = true);
            translate(sc_shell_points[5]) flat_bottom_sphere(d = part_size, inv = true);
          }
        }
    }

    module flat_bottom_sphere(d = 5, inv=false) {
      union() {
        csphere(d=d);
        if (inv) {
          translateZ(d/4) ccylinder(d=d, h = d/2);
        }
        else {
          translateZ(-d/4) ccylinder(d=d, h = d/2);
        }
      }
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
            hull() mirrorX() translateX(78.49)  {
              translateY(58) ccylinder(d = 8, h = 1.8);
              translateY(-58) ccylinder(d = 8, h = 1.8);
            }
          }
          // pi board
          translateZ(2.5)
          sc_pi_cutouts(shaft_D=6, shaft_H=5);

          // teensy board
          translate([sc_teensy_offset[0],sc_teensy_offset[1],sc_teensy_offset[2]+3.2]) rotate(sc_teensy_rotation) make_drill_holes(size = [36,56,5], shaftD=6);

          // bucky board
          translate([sc_bucky_offset[0],sc_bucky_offset[1],sc_bucky_offset[2]+3.2]) rotate(sc_bucky_rotation) sc_bucky_screws(h = 5, d = 6);

          // battery mounts
          translateZ(3.5)
          mirrorX() translate(sc_battery_offset) rotate(sc_battery_rotation) translateZ(2) battery_holder_dual_18650_part() ccylinder(d = 12, h = 8);


          //TODO: side mounts
        }
        union() {
          sc_shell_screen_frame_cutouts();
        }
      }
    }


    module sc_shell_screen_frame_cutouts() {

      // box cutouts
      translate(sc_screen_offset) {
        translate([40,-10,-7.8]) makeRoundedBox([20,30,10]);
        translate([10,0,-7.8]) makeRoundedBox([20,20,10]);
        translate([-40,6,-7.8]) makeRoundedBox([40,20,10]);
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
      translate(sc_bucky_offset) rotate(sc_bucky_rotation) sc_bucky_screws(h = 15);

      // battery mounts
      translateZ(4.5)
      mirrorX() translate(sc_battery_offset) rotate(sc_battery_rotation) translateZ(2) battery_holder_dual_18650_part() {
        rivnut(bore_D = 4.7, bore_H = 11, flange_D = 7, flange_H = 0.8);
      }

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
