patches-own[ object_type near_window? near_aircon? near_cr? pax available? number]
turtles-own [status eating_time waiting_time choice found_table table preferred_table_type happiness]
breed [customer group]

to start
  clear-all
  initialize_layout
  spawn_customer
  reset-ticks

end


to go
 ask turtles [

    (ifelse
      status = "entering" [
        enter_door
      ]

      status = "finding" [
        preference_table ;find their preferred table, random if no available
      ]
      status = "waiting" [
        print word "ako ay " status
        set waiting_time (waiting_time - 2)
        ifelse waiting_time > 0 [set status " finding" ][print "tagal!! alis na ko >:( " set status "exit_door"]
      ]
      status = "sitting"[

      ]

      status = "eating" [
        eat_at_table ; eat at table
      ]

      status = "exiting" [
        exit_door ; leave
      ]

      [])
 ]
 tick
end

to initialize_layout
  (ifelse
    table_layout = 1 [
      init_layout_1
    ]
    table_layout = 2 [
      init_layout_2
    ]
    [])
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;     LAYOUTS     ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to init_layout_1
  ask patches [
    set pcolor red
  ]

  init_sofa 1 6 1 true false false
  init_sofa 7 6 2 true false false
  init_sofa 13 6 3 true false false
  init_sofa 19 6 4 true false false
  init_sofa 25 6 5 true false false

  init_regtable 7 10 1 false false false
  init_regtable 15 10 2 false false false
  init_regtable 15 0 3 false false false
  init_regtable 7 0 4 false false false

  init_doubletable 4 10 1 false false false
  init_doubletable 9 10 2 false false false
  init_doubletable 14 10 3 false false false
  init_doubletable 4 0 4 false false false
  init_doubletable 9 0 5 false false false
  init_doubletable 14 0 6 false false false

  init_static

  ; Setup the cr
  ask patches with [
    (pxcor = (max-pxcor) and pycor = (0)) or
    (pxcor = (max-pxcor) and pycor = (1)) or
    (pxcor = (max-pxcor) and pycor = (2)) or
    (pxcor = (max-pxcor) and pycor = (3))
  ] [
    set pcolor black
    set object_type "cr"
  ]

  ;Setup Aircon
  ask patches with [
    (pxcor = (7) and pycor = (max-pycor)) or
    (pxcor = (8) and pycor = (max-pycor)) or
    (pxcor = (9) and pycor = (max-pycor)) or
    (pxcor = (10) and pycor = (max-pycor)) or
    (pxcor = (11) and pycor = (max-pycor))
  ] [
    set pcolor gray
    set object_type "aircon"
  ]

  ;Setup Aircon
  ask patches with [
    (pxcor = (0 - max-pxcor) and pycor = (0)) or
    (pxcor = (0 - max-pxcor) and pycor = (1)) or
    (pxcor = (0 - max-pxcor) and pycor = (2)) or
    (pxcor = (0 - max-pxcor) and pycor = (3)) or
    (pxcor = (0 - max-pxcor) and pycor = (4))
  ] [
    set pcolor gray
    set object_type "aircon"
  ]


end

to init_layout_2
  ask patches [
    set pcolor blue
  ]

  init_sofa 1 7 1 true false false
  init_sofa 1 12 2 false false false
  init_sofa 1 17 3 false false false
  init_sofa 1 22 4 false false false
  init_sofa 1 27 5 false false false

  init_regtable (max-pxcor + 6) 6 1 false false false
  init_regtable (max-pxcor - 8) 6 2 false false false
  init_regtable (max-pxcor + 6) -4 3 false false false
  init_regtable (max-pxcor - 8) -4 4 false false false

  init_doubletable -1 6 1 false false false
  init_doubletable -1 -4 2 false false false

  init_doubletable 13 6 3 false false false
  init_doubletable 13 -4 4 false false false

  init_doubletable -15 6 5 false false false
  init_doubletable -15 -4 6 false false false

  init_static

  ; Setup the cr
  ask patches with [
    (pxcor = (max-pxcor) and pycor = (0)) or
    (pxcor = (max-pxcor) and pycor = (1)) or
    (pxcor = (max-pxcor) and pycor = (2)) or
    (pxcor = (max-pxcor) and pycor = (3))
  ] [
    set pcolor black
    set object_type "cr"
  ]

  ;Setup Aircon
  ask patches with [
    (pxcor = (7) and pycor = (max-pycor)) or
    (pxcor = (8) and pycor = (max-pycor)) or
    (pxcor = (9) and pycor = (max-pycor)) or
    (pxcor = (10) and pycor = (max-pycor)) or
    (pxcor = (11) and pycor = (max-pycor))
  ] [
    set pcolor gray
    set object_type "aircon"
  ]

  ;Setup Aircon
  ask patches with [
    (pxcor = (-7) and pycor = (max-pycor)) or
    (pxcor = (-8) and pycor = (max-pycor)) or
    (pxcor = (-9) and pycor = (max-pycor)) or
    (pxcor = (-10) and pycor = (max-pycor)) or
    (pxcor = (-11) and pycor = (max-pycor))
  ] [
    set pcolor gray
    set object_type "aircon"
  ]


end






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;     OBJECTS     ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to init_doubletable [x y num nearWindow nearAircon nearCR]
  ask patch (x) y [
    set pcolor brown
  ]

  let selected-patches patches with [
    (pxcor = (x) and pycor = (y + 2)) or
    (pxcor = (x) and pycor = (y - 2))
  ]

  ask selected-patches [
    set pcolor white
    set object_type "2-table"
    set near_window? nearWindow
    set near_aircon? nearAircon
    set near_cr? nearCr
    set pax 2
    set available? true
    set number num
  ]

end

to init_regtable [x y num nearWindow nearAircon nearCR]
  ask patch (x - max-pxcor) y [
    set pcolor brown
  ]

  let selected-patches patches with [
    (pxcor = ((x - 2) - max-pxcor) and pycor = (y)) or
    (pxcor = ((x + 2) - max-pxcor) and pycor = (y)) or
    (pxcor = (x - max-pxcor) and pycor = (y + 2)) or
    (pxcor = (x - max-pxcor) and pycor = (y - 2))
  ]

  ask selected-patches [
    set pcolor white
    set object_type "4-table"
    set near_window? nearWindow
    set near_aircon? nearAircon
    set near_cr? nearCr
    set pax 4
    set available? true
    set number num
  ]
end

to init_sofa [x y num nearWindow nearAircon nearCR]
  ask patch ((x + 2) - max-pxcor) ((y + 2) - max-pycor) [
    set pcolor brown
  ]
 let selected-patches patches with [
    (pxcor = (x - max-pxcor) and pycor = (y - max-pycor)) or
    (pxcor = (x - max-pxcor) and pycor = ((y + 1) - max-pycor)) or
    (pxcor = (x - max-pxcor) and pycor = ((y + 2) - max-pycor)) or
    (pxcor = ((x + 1) - max-pxcor) and pycor = (y - max-pycor)) or
    (pxcor = ((x + 2) - max-pxcor) and pycor = (y - max-pycor)) or
    (pxcor = ((x + 3) - max-pxcor) and pycor = (y - max-pycor))
 ]

 ask selected-patches [
    set pcolor white
    set pax 4
    set object_type "sofa"
    set near_window? nearWindow
    set near_aircon? nearAircon
    set near_cr? nearCr
    set available? true
    set number num
 ]
end

to init_static
  ask patches with [
    pxcor = max-pxcor or
    pxcor = min-pxcor or
    pycor = max-pycor or
    pycor = (min-pycor + 4)
  ] [
    set pcolor brown
    set object_type "wall"
  ]


  ; customer spawn area
  ask patches with [
    pycor = -16 or
    pycor = -15 or
    pycor = -14 or
    pycor = -13
  ][
    set pcolor gray
    set object_type "customer_area"
  ]

  ; Setup the door
  ask patches with [
    (pxcor = (max-pxcor - 4) and pycor = (4 - max-pycor)) or
    (pxcor = (max-pxcor - 5) and pycor = (4 - max-pycor)) or
    (pxcor = (max-pxcor - 6) and pycor = (4 - max-pycor)) or
    (pxcor = (max-pxcor - 7) and pycor = (4 - max-pycor))
  ] [
    set pcolor black
    set object_type "door"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (1 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (2 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (3 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (4 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (7 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (8 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (9 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (10 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (13 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (14 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (15 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (16 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (19 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (20 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (21 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (22 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (25 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (26 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (27 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (28 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]

  ; Setup windows
  ask patches with [
    (pxcor = (25 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (26 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (27 - max-pxcor) and pycor = (4 - max-pycor)) or
    (pxcor = (28 - max-pxcor) and pycor = (4 - max-pycor))
  ] [
    set pcolor white
    set object_type "window"
  ]
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;     CUSTOMERS     ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to spawn_customer
  ask one-of patches with [object_type = "customer_area"] [
    sprout 1 + random 4 [
      set breed customer
      set shape "person"
      set color yellow
      set size 2
      set status "entering"
      set eating_time 1 + random 50
      set waiting_time 1 + random 50
      set choice random 3
      set found_table FALSE
      set table nobody
      set happiness random 5 + 1  ; happiness random number from 1-5
      set preferred_table_type one-of ["near_window" "near_aircon" "near_cr"] ; preferred table type
    ]
  ]
end

to enter_door
  let door-patch one-of patches with [object_type = "door"]
  let ahead-turtle one-of turtles-on patch-ahead 1
  if door-patch != nobody [
    ifelse ahead-turtle != nobody [
      ifelse [status] of ahead-turtle = "entering" [
        ; If there's a turtle in front of the door and it's entering, wait behind it
        face ahead-turtle
        if distance ahead-turtle < 2 [
          ; Wait behind the turtle
          set status "waiting"
        ]
      ] [
        ; If there's a turtle in front of the door but it's not entering, continue moving towards the door
        face door-patch
        if distance door-patch < 1 [
          set status "finding"
        ]
      ]
    ] [
      ; If there's no turtle in front of the door, continue moving towards the door
      face door-patch
      if distance door-patch < 1 [
        set status "finding"
      ]
    ]
  ]
  fd 1
end

to find_table [chair_type]

  if (not found_table)[
    set table one-of patches with [available? = true]
    print word "available pba lahat? " table
    ifelse table != nobody[
      set table one-of patches with [object_type = chair_type and available? = true]
      let chosen-seat table

      print word "table" table
      if table = nobody[
        print "inside nobody"
        ;randomized_table
        while [table = nobody][
          set table one-of patches with [available? = true]
          set chosen-seat table
          ;print word "table " table
        ]
      ]
      set found_table TRUE
      ;print word "table " [number] of table
      ask chosen-seat [set available? false]
    ][
      set status "waiting"
    ]


  ]
  if table != nobody[
    face table
    if distance table < 1 [
      set status "eating"
    ]
  fd 1]

end

to eat_at_table
  let chosen-seat table
  ifelse chosen-seat != nobody [
    ifelse [object_type] of chosen-seat = preferred_table_type [
      set happiness min (list (happiness + 2) 5) ; max 5 happiness
    ] [ ; not preferred table minus 1-3 randomly
      set happiness max (list (happiness - random 3 + 1) 0) ; min 0 happiness
    ]
    ifelse eating_time = 0 [
      set status "exiting"
      ask chosen-seat [set available? true]
    ]
    [
      set eating_time (eating_time - 1)
    ]
  ] [
    set status "waiting" ; No table found, wait
  ]
end

to exit_door
  let door-patch one-of patches with [object_type = "door"]
  if door-patch != nobody [
    face door-patch
    if distance door-patch < 1 [
      die
    ]
  ]
  fd 1
end


to preference_table

  if choice = 0 [find_table "sofa"]
  if choice = 1 [find_table "2-table"]
  if choice = 2 [find_table "4-table"]
end