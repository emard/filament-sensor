# Filament Sensor

Sensor detects presence or absence of the filament.
Openscad 3D Printable models for filament sensors
with cotactless Hall sensor or with mechanical microswitch.

# Hall sensor

Applies very small force to the filament,
minimizing friction.

Magnet (5x5 mm Neodymium cylinder) is the only moving
part. Solid state Hall sensor (Honeywell SS495A or similar)
in 3-pin transistor plastic case directly connects to
printer motherboard electronics.

When sensor is empty, magnet is placed at the
position in channel close to the empty filament
guide. Inserted filament displaces the magnet.

Sensor is precisely located on the special
position in space where magnetic flux has one
sign when sensor is empty and opposite sign
when sensor is loaded so the sensor reacts
reliably reading logical 1 or 0. To invert
logic, flip both magnets or flip the sensor.
Flipping sensor moves triggering point, internal
chip is closer to the flat side of the sensor
plastic package. Default orientation is flat
side away from filament.

When filament moves thru the sensor, it can
either slide over the magnet or rotate the
magnet in the channel. In either case, friction
is very small.

When filament is removed, magnet returns to its
default position by its own gravity or by attractive
force from the second magnet.

Second magnet should be used if filament sensor is
not always vertical. It provides a more reliable return
but it increases force, increasing the friction too.
Friction can be tuned by varying distance of
second magnet from the filament detection magnet.

Attractive force holds magnets together so they
won't leave sensor easily. To remove inserted
DxH=5x5 mm magnets, insert filament, approach
external magnet DxH=10x5 mm from the side and
drag it.

# Mechanical switch

Mechanical switch with roller applies default
force to the filament. It should be precisely
positioned relative to the filament to reliably
trigger. The friction between filament and the
roller of the switch is higher than with Hall
sensor.
