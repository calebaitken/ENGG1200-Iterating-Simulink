# ENGG1200 Iterating Simulink
Iterates through all airfoils on airfoiltools.com to and creates a graph of Angle of Incidence vs Flight Distance in MATLAB, Simulink, and Python

This is a horrible hack to iterably execute a Simulink model with changing variables, to determine the best airfoil for an ENGG1200 glider.

A couple of things are done here, in manual steps:
  1) PyGrab.py         ->  this is a webscrape to get all the data avaible on airfoiltools.com for testing. It used the "Airfoil Name CSVs" to find the data; these CSVs were manually written. Saves only the Angle of Attack, Coefficient of Lift, and Coefficient of Drag.
  2) prg_itr_glider.m  ->  using the airfoil data, GliderSim.slx is run for each glider at varying Angles of Incidence, and the results are graphed.
  3) your eyes         ->  if your lucky and the previous step didn't fail (it will), then you can use MATLAB's max() function to find the best glider. However, your gonna have to go through all the graphs.
