__includes["initialization.nls" "populationprocesses.nls" "diseaseprocesses.nls" "writeoutput.nls" "fishing.nls" "intervention.nls"]

extensions [gis profiler]

globals [
  hhdetcount
  nbdetcount
  inputvariable
  ;change it here! AND in initialization.nls + remove slider!
  probabilityoftreatment
  personmonths
  personmonthscontrol
  personmonthscontact
  personmonthsblanket
  personmonths_household_small
  personmonths_household_medium
  personmonths_household_large
  personmonths_cluster_house
  personmonths_cluster_neighbor
  personmonths_cluster_no
  newcase
  newcasecontrol
  newcasecontact
  newcaseblanket
  newcasehhsmall
  newcasehhmedium
  newcasehhlarge
  newcasehhcontact
  newcasenbcontact
  newcasenocontact
  householdcontact
  neighborcontact
  noncontact
  simulation-iterator
  act1
  act2
  detection-delay
  detection-delay-variance
  relapse-rate
  neighborhouses
  fertilityrate
  childmortality
  lifeexpectancy
  boat-dataset
  island-dataset
  house-dataset
  year
  uberlist
  newlist
  newline
  children
  potentialpartner
  infection-count
  susceptible-turtles
  infectious-turtles
]

breed [houses house]
breed [people person]
breed [boats boat]

links-own [activelink?]

patches-own [
  isIsland?
  island_ID
]

houses-own [
  householdID
  homeIsland
  occupied?
  allocated?
  householdsize
  numberofinhabitants
]

people-own [
  isnewcase
  infectionchance
  ;pop-model:
  sex
  age
  life-expectancy
  ;household-structure:
  partner
  myisland
  hhID
  sizehh
  ;activity-model:
  age-to-marry
  age-own-house
  fisherman?
  fishing?
  onboatid
  time-fishing
  ;disease-model:
  susceptible?
  stage
  infected?
  genetic-type
  months-since-infection
  pb-selfhealing
  infectiousness
  incubation-time
  time-until-detection
  immune?
  household-status
  contact-status
]

boats-own [
  boatID
  active?
]
to setup
  clear-all
  reset-ticks
  set simulation-iterator 0
  set hhdetcount 0
  initialization
  generate-txt-and-headers
end

to profiler
  setup
  profiler:start
  repeat 150 [go]
  profiler:stop
  print profiler:report
  profiler:reset
end

to go
  disease-development
  infect
  death
  birth
  marry
  move
  set-household-sizes
  set year year + (1 / 12)
  ask people [set age age + (1 / 12)]
  tick
  set-globals
  ;2000
  if ticks = 485 [
    if fishing-on? = true [
      initiate-fishing
    ]
    set personmonths 0
    
    ;see sheet intervention:
;    set-status-fields-for-clustering
    
    ;see sheet writeoutput:
;    write-output-prevalence-2000
    write-output-clusters-2000
    write-output-yearly-prevalence
    write-output-hhdetcount-2000
    do-intervention
    
  ]
  
  if ticks > 485[ 
    set personmonths personmonths + count people with [stage != "symptomatic"]

;    if ticks < 531 [
;      set personmonths_household_small personmonths_household_small + count people with [household-status = "1-4"]
;      set personmonths_household_medium personmonths_household_medium + count people with [household-status = "5-7"]
;      set personmonths_household_large personmonths_household_large + count people with [household-status = ">7"]
;      set personmonths_cluster_house personmonths_cluster_house + count people with [contact-status = "hh-contact"]
;      set personmonths_cluster_neighbor personmonths_cluster_neighbor + count people with [contact-status = "neighbor-contact"]
;      set personmonths_cluster_no personmonths_cluster_no + count people with [contact-status = "no-contact"]
;    ]    
;    set personmonthscontrol personmonthscontrol + count people with [myIsland = 3 and stage != "symptomatic"]
;    set personmonthscontact personmonthscontact + count people with [myIsland = 2 and stage != "symptomatic"]
;    set personmonthsblanket personmonthsblanket + count people with [myIsland = 0 and stage != "symptomatic"]
;    set personmonthsblanket personmonthsblanket + count people with [myIsland = 1 and stage != "symptomatic"]
;    set personmonthsblanket personmonthsblanket + count people with [myIsland = 4 and stage != "symptomatic"]
    if fishing-on? = true [
      fish-return-check
      if remainder ticks 6 = 0[
        go-fishing
      ]
   ]


  ]
  ;2001
  if ticks = 497 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2002
  if ticks = 509 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2003
  if ticks = 518 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2004
  if ticks = 530 [
;    write-output-incidence-per-cluster
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2005
  if ticks = 542 [
    if medicine_effect = 2 [
      ask people with [immune? = true][
        set immune? false
      ]
    ]
    write-output-incidence
    write-output-yearly-prevalence
    write-output-hhdetcount
    set personmonths 0
    set newcase 0
  ]
  ;2006
  if ticks = 554 [
     write-output-incidence
     write-output-yearly-prevalence
     set personmonths 0
    set newcase 0
  ]
  ;2007
  if ticks = 566 [
     write-output-incidence
     write-output-yearly-prevalence
     set personmonths 0
    set newcase 0
  ]
  ;2008
  if ticks = 578 [
     write-output-incidence
     write-output-yearly-prevalence
     set personmonths 0
    set newcase 0
  ]
  ;2009
  if ticks = 590 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2010
  if ticks = 602 [
    write-output-incidence
    write-output-yearly-prevalence
    write-output-hhdetcount
    set personmonths 0
    set newcase 0
  ]
  ;2011
    if ticks = 614 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2012
    if ticks = 626 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2013
    if ticks = 638 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2014
    if ticks = 650 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2015
    if ticks = 662 [
    write-output-incidence
    write-output-yearly-prevalence
    write-output-hhdetcount
    set personmonths 0
    set newcase 0
  ]
  ;2016
    if ticks = 674 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2017
    if ticks = 686 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2018
    if ticks = 698 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2019
    if ticks = 710 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2020
    if ticks = 722 [
    write-output-incidence
    write-output-yearly-prevalence
    write-output-hhdetcount
    set personmonths 0
    set newcase 0
  ]
  ;2021
    if ticks = 734 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2022
    if ticks = 746 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2023
    if ticks = 758 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2024
    if ticks = 770 [
    write-output-incidence
    write-output-yearly-prevalence
    set personmonths 0
    set newcase 0
  ]
  ;2025
    if ticks = 782 [
    write-output-incidence-end
    write-output-yearly-prevalence-end
    write-output-hhdetcount-end
    set personmonths 0
    set newcase 0
        print simulation-iterator
    set simulation-iterator simulation-iterator + 1
    clear-turtles
    reset-ticks
    set year 0
    initialization
  ]
  
  if simulation-iterator >= number-of-runs [stop]

end
@#$#@#$#@
GRAPHICS-WINDOW
498
10
1070
603
140
140
2.0
1
10
1
1
1
0
0
0
1
-140
140
-140
140
0
0
1
ticks
30.0

BUTTON
19
22
82
55
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
19
67
157
112
pop-1960
pop-1960
1779
0

BUTTON
90
22
153
55
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
17
121
221
154
marriage-between-islands?
marriage-between-islands?
0
1
-1000

SLIDER
17
373
194
406
percentage-fisherman
percentage-fisherman
0
1
0.9
0.01
1
NIL
HORIZONTAL

SLIDER
13
413
185
446
boat-capacity
boat-capacity
0
10
10
1
1
NIL
HORIZONTAL

SWITCH
19
160
135
193
fishing-on?
fishing-on?
0
1
-1000

SLIDER
277
250
456
283
percentage-MB-relapse
percentage-MB-relapse
0
1
0.9
0.01
1
NIL
HORIZONTAL

CHOOSER
290
313
428
358
number-of-runs
number-of-runs
1 2 5 10 17 25 50 100
0

BUTTON
168
21
242
54
NIL
profiler
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
330
193
363
marry-rate
marry-rate
0
1
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
21
287
269
320
percentage-own-house-at-marriage
percentage-own-house-at-marriage
0
1
0.25
0.01
1
NIL
HORIZONTAL

SLIDER
23
202
220
235
percentage-susceptible
percentage-susceptible
0
1
0.32
0.001
1
NIL
HORIZONTAL

SLIDER
238
73
482
106
infection-rate
infection-rate
0.00000001
0.001
4.83E-4
0.000000001
1
NIL
HORIZONTAL

SLIDER
281
127
453
160
hh-factor
hh-factor
0
20
7
0.1
1
NIL
HORIZONTAL

SLIDER
279
164
451
197
nb-factor
nb-factor
0
20
3
.1
1
NIL
HORIZONTAL

SLIDER
280
204
452
237
is-factor
is-factor
0
20
15
1
1
NIL
HORIZONTAL

SLIDER
25
245
197
278
percentage-MB
percentage-MB
0
1
0.25
0.001
1
NIL
HORIZONTAL

CHOOSER
291
414
429
459
medicine_effect
medicine_effect
1 2 3
0

CHOOSER
291
368
442
413
intervention_employed
intervention_employed
"no" "blanket" "contact" "household"
1

CHOOSER
266
495
404
540
follow_up
follow_up
"household" "contact"
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -16777216 true false 60 150 105 210 195 210 240 150 150 150 150 90 165 90 135 60 135 150 60 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

human
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
