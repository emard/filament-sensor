# Filament Sensor

Sensor detects presence or absence of the filament.
Openscad 3D Printable models for filament sensors
with cotactless Hall sensor or with mechanical microswitch.

# Hall sensor

![Image](/pic/filament-sensor-hall.png)

Applies very small force to the filament,
minimizing friction.

    prusa has this logic in its original IR filament sensor
    sensor OUT:
    0 (LOW)  LOADED
    1 (HIGH) EMPTY
    IR sensor pinout
    +  +5V
    O  OUT
    -  GND
    
    MK2S rambo13a 10-pin connector looking at PCB pins
    ---------
    x x x x x
    x s x - +
    ---------
    -=GND, +=+5V, s=signal
    
    MK3 einsy10a 10-pin connector looking at PCB pins
    ---   ---
    x x x x x
    s x x - +
    ---------
    -=GND, +=+5V, s=signal
    
    HALL sensor Honeywell SS495A, on package is written 95A
    pinout looking at pins, plastic case at the back
      _______
     / + - o \
     ---------
    
    connect
     - -
     + +
     s o
    
    Prusa MK2.5S firmware can be loaded to MK2S
    Support -> Sensor info
    Fil. sensor: 1-LOADED, 0-EMPTY

Magnet (5x5 mm Neodymium cylinder) is the only moving
part. Solid state Hall sensor (Honeywell SS495A or similar for 5V)
in 3-pin transistor plastic case directly connects to
printer motherboard electronics.

When sensor is empty, magnet is placed at the
position in channel close to the empty filament
guide. Inserted filament displaces the magnet.

Best location for the Hall sensor is where magnetic
flux reverses sign when filament is inserted,
so the sensor reliably reads logical 1 or 0.
To invert logic, flip both magnets or flip the sensor.
Default orientation is flat side towards filament.

Flipping or using different sensor may need adjustment,
experiment with position along the channel, in case of
false runout, reduce the X parameter in steps of 0.1:

    hall_pos = [X,Y,Z];

Hall sensor used is SS495A, analog rail-to-rail output
with high sensitivity 3 mV/Gauss = 30 V/Tesla.
Digital output sensor could be used too but I
haven't tried them yet. For example SS411P with
bipolar triggering in range of +50/-50 Gauss
or AH3377 with unipolar triggering in
range of +115/+90 Gauss.

When filament moves thru the guide, it can
either slide over the magnet or rotate the
magnet in the channel. In either case, friction
is very small.

When filament is removed, magnet returns to its
default position by its own weight or by attractive
force from the second magnet.

Second magnet should be used if filament sensor is
not always vertical. It provides a more reliable return
but it increases force, increasing the friction too.
Friction can be tuned by varying distance of
second magnet from the filament detection magnet.

Attractive force holds magnets together so they
won't leave sensor easily. To remove inserted
DxH=5x5 mm magnets, insert filament, try to shake
it out, touch it with some steel or approach
external magnet DxH=10x5 mm from the side and
drag it.

# Mechanical switch

![Image](/pic/filament-sensor-switch.png)

Applies more friction to the filament than
the Hall sensor.

Mechanical switch with roller applies its designed
force to the filament. Roller should be precisely
positioned relative to the filament to reliably
trigger so there is not much space to tune the
force.
