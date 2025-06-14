turtles-own
  [ sick?                ;; if true, the turtle is infectious
    got-infected?        ;; if the person got the virus this day
    vaccinated?          ;; if the turtle is vaccinated
    time-seated          ;; the time and agents sits
    mask-on?             ;; if the turtle is wearing a mask
]


globals
  [ %sick            ;; what % of the population is infectious
    %new-infected         ;; what % of the population is vaccinated
    overall-visitors     ;; all visitors during the evening
    overall-infected     ;; all infected
    overall-sick
    overall-healthy

    timeOpen             ;; the time how long the bar stays open
    vaccine-effectiveness;; the effectiveness of the vaccine
    infection-risk       ;; the risk of infection after mask and vaccine calculations
]


to setup
  clear-all
  setup-constants
  setup-bar
  setup-turtles
  update-global-variables
  update-display
  reset-ticks
end


;; We create a variable number of turtles of which 10 are infectious,
;; and distribute them randomly
to setup-turtles
  create-turtles number-people
    [ setxy random-xcor random-ycor
      set vaccinated? False
      set sick? False
      set got-infected? False
      set time-seated 0
      set size 1.5  ;; easier to see
      set overall-visitors overall-visitors + 1
      set mask-on? ifelse-value mask? [True][False]
]
  ask n-of (number-people * initialy-sick / 100.0) turtles
    [ set sick? True
      set overall-sick overall-sick + 1]

  ask n-of (number-people * vaccinated-people / 100.0) turtles
    [ set vaccinated? True ]
end

to setup-bar
  ask patches [
   if pxcor = min-pxcor or pxcor = max-pxcor or pycor = min-pycor or pycor = max-pycor[
      set pcolor brown
    ]
   if seats?[
    place-seats
    ]
    set timeOpen 10 * 60
  ]
end

to place-seats
   if (pxcor > 10 and pxcor < max-pxcor) and (pycor < 15 and pycor > -15) and (pxcor mod 7 = 0) and (pycor mod 7 = 0)[
      ask neighbors4  [set pcolor yellow]]
end



;; This sets up basic constants of the model.
to setup-constants
  set vaccine-effectiveness 70
end




to go
  ask turtles [
    move
    if sick? [infect]
   ]
  if exit?[
    exit
  ]
  set timeOpen timeOpen + 1
  if timeOpen = time-of-closing * 60 [stop]
  update-global-variables
  update-display

  tick
end



to update-global-variables
  if count turtles > 0
    [ set %sick (count turtles with [ sick? ] / count turtles) * 100
      set %new-infected (count turtles with [ got-infected? ] / count turtles) * 100]
  set overall-healthy overall-visitors - overall-sick - overall-infected
end

to update-display
  ask turtles
    [ set shape ifelse-value mask-on? [ "masked-human" ]["person"]
      set color ifelse-value sick? [ red ] [ ifelse-value got-infected? [ orange ] [ green ] ] ]
end







to create-new-turtle
      setxy random-xcor (min-pycor + 2)
      set vaccinated? ifelse-value  random 100 < vaccinated-people [True][False]
      ifelse  random 100 < initialy-sick [set sick? True  set overall-sick overall-sick + 1][set sick? False]
      set got-infected? False
      set time-seated 0
      set size 1.5
      set mask-on? ifelse-value mask? [True][False]
      set overall-visitors overall-visitors + 1
end


;; Turtles move about at random.
to move ;; turtle procedure
  ifelse time-seated > 0 [set time-seated time-seated - 1 if time-seated = 0 and mask?[ set mask-on? True]][
    ifelse pcolor = brown [face patch 0 0 fd 1][
           ifelse distancing? and any? other turtles in-radius 3 [ face one-of turtles in-radius 3 rt 90 fd 1][
                                                                                 rt random 100
                                                                                 lt random 100 fd 1]

      ]
    if pcolor = yellow and (not any? other turtles-here)[set time-seated 50  set mask-on? False]
  ]
end


;; If a turtle is sick, it infects other turtles on the same patch.
to infect
  set infection-risk infectiousness                         ;; resetting infection-risk to manipulate if a turtle wears a maks or not
  ask other turtles-here with [ not got-infected?]
    [
      if mask-on? [set infection-risk (infectiousness * (100 - mask-effectiveness) )/ 100]
      ifelse vaccinated?[
      if (random-float 100) < (infection-risk * (100 - vaccine-effectiveness)/ 100)
      [ spread-virus ] ] [ if (random-float 100) < infection-risk [spread-virus]]]
end


;; infectign others
to spread-virus ;; turtle procedure
  set got-infected? true
  set overall-infected overall-infected + 1
end


;; turtles may enter or leave the bar during the evening
to exit
  if ticks > 0 and ticks mod 100 = 0 [
    ask turtles with [ycor < -15] [die]
    if count turtles < house-capacity * 0.8 [create-turtles random  house-capacity * 0.2 [ create-new-turtle]]
  ]
end

to startup
  setup-constants
end
@#$#@#$#@
GRAPHICS-WINDOW
280
10
698
429
-1
-1
10.0
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
30.0

SLIDER
5
85
199
118
infectiousness
infectiousness
0.0
99.0
70.0
1.0
1
%
HORIZONTAL

BUTTON
5
45
75
80
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

BUTTON
130
45
201
81
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
0

PLOT
0
450
252
614
Populations at given Times
time
people
0.0
50.0
0.0
50.0
true
true
"" ""
PENS
"sick" 1.0 0 -2674135 true "" "plot count turtles with [ sick? ]"
"healthy" 1.0 0 -10899396 true "" "plot count turtles with [ not sick? and not got-infected?]"
"total" 1.0 0 -13345367 true "" "plot count turtles"
"infected" 1.0 0 -955883 true "" "plot count turtles with [got-infected?]"

SLIDER
5
10
199
43
number-people
number-people
10
house-capacity
60.0
1
1
NIL
HORIZONTAL

MONITOR
0
405
75
450
NIL
%sick
1
1
11

MONITOR
75
405
172
450
NIL
%new-infected
1
1
11

MONITOR
175
405
249
450
hours
ticks / 60
1
1
11

SLIDER
105
285
277
318
vaccinated-people
vaccinated-people
0
100
76.0
1
1
%
HORIZONTAL

SWITCH
0
180
103
213
seats?
seats?
0
1
-1000

SLIDER
105
215
277
248
time-of-closing
time-of-closing
18
24
18.0
1
1
NIL
HORIZONTAL

SLIDER
105
180
277
213
initialy-sick
initialy-sick
0
99
25.0
1
1
%
HORIZONTAL

SWITCH
0
250
103
283
mask?
mask?
0
1
-1000

SLIDER
105
250
277
283
mask-effectiveness
mask-effectiveness
0
99
73.0
1
1
%
HORIZONTAL

MONITOR
0
305
112
350
infection-risk-mask
word ((infectiousness * (100 - mask-effectiveness)) / 100) \" %\"
17
1
11

MONITOR
0
355
112
400
infection-risk-vacc
word (infection-risk * (100 - vaccine-effectiveness) / 100) \" %\"
17
1
11

SWITCH
0
145
117
178
distancing?
distancing?
0
1
-1000

SLIDER
105
145
277
178
house-capacity
house-capacity
0
200
110.0
1
1
NIL
HORIZONTAL

PLOT
500
455
700
605
Overall Population
time
people
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"total" 1.0 0 -13345367 true "" "plot overall-visitors"
"infected" 1.0 0 -955883 true "" "plot overall-infected"
"sick" 1.0 0 -2674135 true "" "plot overall-sick"
"healthy" 1.0 0 -13840069 true "" "plot overall-healthy"

MONITOR
425
560
497
605
sick
word ( precision (overall-sick / overall-visitors * 100) 1) \" %\"
3
1
11

MONITOR
425
515
482
560
infected
word (precision (overall-infected / overall-visitors * 100)1) \" %\"
3
1
11

TEXTBOX
430
440
580
458
Overall
14
0.0
1

MONITOR
365
470
422
515
visitors
overall-visitors
11
1
11

MONITOR
425
470
482
515
healthy
word (precision (overall-healthy / overall-visitors * 100)1 )  \" %\"
3
1
11

SWITCH
0
215
103
248
exit?
exit?
0
1
-1000

MONITOR
115
355
262
400
infection-risk-vacc+mask
word ((infectiousness * (100 - mask-effectiveness) * (100 - vaccine-effectiveness)) / 10000) \" %\"
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model simulates the transmission of the covid virus in a social based environment.

The model simulates interaction between agents in a bar environment to tackle. The aim of the model is to get a closer and more direct look into government measures against the covid outbreak and the combination of these measures.

## HOW IT WORKS

The model gets initialized with 60 people. The environment has a defined limit, in the given setup 110, 25% of these will start as sick-agents, meaning they are able to spread the virus. Newly infected agents are not able to spread the virus. 85% of the population will be vaccinated and have 70% resistance to the spread. 
Agents are allowed to exit and a specific amount will enter if the capacity has not reached over 80% of the house-capcity. Agents are able to sit down upon which they will take off their masks if the masks are activated for the given run. The effectiveness of the mentioned masks is changeable.

### House-capacity

The amount of people which are allowed to be in the building, a number which will never be exceeded by the model.

### Masks

Masks affect the infection risk this parameter can be chosen and changed. By disabling masks their protection-rate will not be taking into account, if enabled agents will wear them until seated upon which they will take them of, standing up will revert the agent back to a mask wearing agent.

### Infected

An infected agent is not able to infect another due to the incubation rate of the covid. Given that our model takes place in a single day does not give the virus enough time to be spreadable from the new host.

### Infectiousness

Infectiousness can be changed by a slider. The covid is very infectious and has the ability to mutate quite often, in addition to a lot of uncertainty to define the infection rate of the virus itself, leads to a model with infection variability.


### Hard-coded parameters

Two parameters are Hard-coded, in other words not reachable by the interface and constant to some extent. The vaccine-effectiveness, which is set to 70 and infection-risk, which gets used to calculate the infection risk when taking vaccination and mask usage into account.


## HOW TO USE IT

The setup button takes the set in variables from the sliders and switches and prepares the simulation. The time is set to start at 10 in the morning and runs till the given amount of the slider time-of-closing. 

Two plots are given, the left plot gives information about the given amount of healthy, sick and infected people at the given time. The right plot gives the same information for the overall population of visitors over the evening. The added monitors also reflect the given percentage for infected people and infectious people.

There are also monitors reflecting the different percentages for the spread of the virus. Notice the vaccine monitor will set itself after pressing the go button.


## THINGS TO TRY

Trying different combinations for infectiousness and vaccinated people show how effective a vaccine can be even if it does not give 100% of immunity to the virus itself, as well as trying to stay on a realistic level of parameters shows that it is impossible to never infect anyone, but seeing how strong one can diminish the infections with small adjustments of the restrictions is astounding. 


## Base of the model

* Wilensky, U. (1998).  NetLogo Virus model.  http://ccl.northwestern.edu/netlogo/models/Virus.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## Copyright notice

The model upon which this one was based was changed nearly in its entirety which is why the copyright section was taken out. The full rights are still in the original model given under the "Base of the model" section.
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

masked-human
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Rectangle -11221820 true false 105 45 195 75

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>overall-visitors</metric>
    <metric>overall-infected</metric>
    <metric>overall-sick</metric>
    <enumeratedValueSet variable="distancing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="house-capacity">
      <value value="110"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="seats?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infectiousness">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccinated-people">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialy-sick">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-people">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="exit?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-of-closing">
      <value value="18"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
1
@#$#@#$#@
