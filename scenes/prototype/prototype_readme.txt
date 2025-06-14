So far it's setup so the player triggers mines when coming into their trigger_radius, 
and then they signal the KilledWarning control to display the message, allowing a reset.

Use "scan_for_mine" input to scan the scanner radius around the player. Default key is F.
This currently just checks how many mines there are in range and prints it out. We
can expand this later.
