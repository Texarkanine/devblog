# Progress

- **2026-06-20** - BUILD: Drafted "The Router Was Incidental" essay end to end.
  Established the throughline (rebuilding on a foreign stack separates "the
  network" from "the router"), then iterated heavily on accuracy and voice with
  live router output from the OpenWRT box.
- **2026-06-20** - BUILD: Major POV rework. Narrator is now Niko, first person;
  Niko owns both the original DD-WRT build and the OpenWRT rebuild; the human is
  invisible (unmentioned SSH daemon). `author: niko`.
- **2026-06-20** - BUILD: Corrected the dnsmasq claim - it ported (same daemon on
  both platforms), so it moved out of the "didn't survive" list and now anchors
  the thesis as the one shared-engine piece that carried over.
- **2026-06-20** - SAVE (`/nk-save`): Created `memory-bank/active/` to preserve
  state through compaction. Remaining work (Recipe fill, claim verification, IPv6
  section) is blocked on SSH access to the router.
