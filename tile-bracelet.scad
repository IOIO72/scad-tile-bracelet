/*
Tile Bracelet v1.0
by Tamio Patrick Honma <tamio@honma.de> aka IOIO72

For Unicode characters use https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/Symbola.zip

Recommended print and assembly workflow:
1. Export tiles and spacers as separate parts.
2. You may need to print the tiles with a brim for better hot bed adhesion.
3. Print spacers with a raft for better print hot bed adhesion.
4. Thread a rubber thread up to half of the thread through the upper holes of the tiles and spacers.
5. Then thread the second half of the thread through the lower holes of the tiles and spacers.
6. Thread both ends of the thread through the corresponding holes of the last tile to close the bracelet.
7. Knot the ends of the thread together. Keep in mind that you can still pass your hand through the bracelet.

*/


/* [Basic] */

// Content
content = [" ", "P", "E", "A", "C", "E", " ", "L", "O", "V", "E", " "];

// Font (use menu `Help/Font List`)
font = "System Font:style=Regular";

// Text Size
text_size = 10;

// Text Height;
text_height = 0.8;

// Spacer
spacer_width = 3;

// Holes
holes_count = 2; // [0 : "No", 1 : "One", 2 : "Two"]


/* [Print Parts] */

// Print Parts
parts = "All"; // ["Tiles": "Tiles", "Spacers" : "Spacers (Available when Holes are set)", "All": "All"]


/* [Tile] */

// Width, Depth, Height
size = [10, 15, 5];

// Radius for rounded corners
tile_radius = 2.2;


/* [Advanced] */

// Align spacers narrow
spacers_narrow = true;

// Number of fragments
$fn = 50; // [0:100]


/* [Hidden] */

spacer_padding = spacers_narrow ? size.z + 1 : size.x + spacer_width;


/* Elements */

module hole(s, pos) {
  if(holes_count > 0) { 
    translate([0, holes_count == 2 ? pos : 0, 0])
    rotate([0, 90, 0])
    cylinder(s.x + 1, d = s.z / 2, center = true);
  };
};

module tile(s, c, ts, th, r) {
  difference() {
    if (r > 0) {
      minkowski() {
        cube([s.x - r, s.y - r, s.z - 1], center = true);
        cylinder(d = r, center=true);
      };
    } else {
      cube(s, center = true);
    };
    hole(s, s.y / 4);
    hole(s, - s.y / 4);
  };
  translate([0, 0, s.z / 2 + th / 2])
  linear_extrude(th, center = true)
  text(c, ts, font, halign = "center", valign = "center");
};

module spacer(s, sw) {
  difference() {
    scale([1, 1, sw / s.z])
    sphere(d = s.z);
    cylinder(h = s.z + 1, d = s.z / 2, center = true);
  };
};


/* Main */

for(i = [1 : len(content)]) {
  if (parts == "Tiles" || parts == "All") {
    translate([i * (size.x + spacer_width), 0, size.z / 2])
    tile(size, content[i - 1], text_size, text_height, tile_radius);
  };
  if (parts == "Spacers" || parts == "All") {
    if (holes_count > 0) {
      translate([0, size.y, spacer_width / 2 - 0.3]) {
        translate([i * spacer_padding, 0, 0])
        spacer(size, spacer_width);
        if (holes_count == 2) {
          translate([i * spacer_padding, size.z + 2, 0])
          spacer(size, spacer_width);
        };
      };
    };
  };
};

