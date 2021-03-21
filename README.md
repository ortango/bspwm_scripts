bspwm scripts
=============

some bspwm related scripts that have been useful. they are of _varying quality_, but all pretty ugly. written in for either bash (often using v4+ features) or dash.
some require tools like `jq`, `xdo`, `xtitle`, `wmutils` and `xprop` - there are others. i've included a list at the top of the scripts if one needs something extra (there is no "dependency checks", and it will stay that way).

_this is more or less an archive for personal use, so i'll just put a **blanket warning**_:
>_none of these are meant for distribution_, you shouldn't run them before reading them and some may need configuration.

i might add some kind of documentation beyond this list, but not at this point.

node commands
-------------

* btabbed       - manage windows in `tabbed`.
* bubblemv      - move a node in a bubble-like way.
* copynode      - move windows between desktops using receptacles to hold placement
* chlayer       - change a node's layer
* cyclewin      - next/previous window in same state, or move to a different state
* floattoedge   - move to resize a floating window to monitor edge: left, right, top, bottom
* magifloat     - toggle floating in same size and place keeping a receptacle in place
* mvtopresel    - move a {,marked} node to preselection, or mark it.
* promote       - move a node up to the root
* smoothnav     - navigate windows in a intuitive way
* swaphidden    - swap a hidden window for a visible window
* uniform       - arrange all descendants in the same orientation and balance them

node rules
----------

* ignorenew     - don't focus newly mapped windows
* mksquare      - make a node a square by changing split_ratio

query commands 
-------------- 

* boundscoor    - get rectangle in bounds of a monitor
* cardinaldir   - return cardinal direction from polarity and split direction
* centercoor    - get window rectangle centered on a rectangle
* commancestor  - return the first common ancestor of two nodes
* edgewin       - get closest window in direction on an inactive desktop
* leastrecent   - return least recently focused node from a list
* showpath      - print the `@path/` of a node
  * showpath-jq - same, but using jq
* showtree      - print the tree rooted at a node
* showwpaths    - print parsable window info incl. relative path and class of descendants

desktop & monitor commands
--------------------------

* monconf       - run xrandr with predefined arguments
* orderdesks    - move and reorder desktops according to a list

subscribers
-----------

* fakefocus     - set descendants as focused in compton/picom
* notifynew     - send notification when a window spawns outside of active view
* waitonwm      - use subscribe to wait for bspwm to initialize
* watchtree     - watch a `@path/` for node events

rofi modi helper
----------------

* bspwm_common  - pretty print node information for rofi

some examples
-------------

* mkmaster      - promote a window to root and optionally uniform.sh the brother.
* modi-example  - rofi modi using rofi/bspwm_common.sh
* invsiemall    - make all but the focused window transparent using picom
* rolltree      - circulate the tree until a node reaches the target node's path


``` bash
#example to cycle through hidden windows, swapping them out for the current window
node="$(leastrecent.sh $(bspc query -N -d -n .hidden.window.local))" &&
    swaphidden.sh $node
#example to center a focused floating window on a window without going off monitor
centerfloat(){
    s=($(wattr xywh $1));
    s=($(boundscoor.sh $(centercoor.sh ${s[@]})))
    wtp ${s[@]} $(2)
}
centerfloat $(bspc query -N -n last.tiled.window) $(pfw)
```
