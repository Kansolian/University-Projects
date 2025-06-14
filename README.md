# University-Projects
A Repository housing all code relating to various University projects. In addition to a thorugh explanation of other projects conducted throughout my 5 years in academia

## Bachelor years

* `Multi-Agent Systems` - Covid interaction study simulated in NetLogo.
* `Autonomous Systems` - Code was lost given a faulty laptop, still mentioned given its impact on my knowledge base. The project resulted in building a laser Tag companion robot named ALTO, Image can be seen in the folder. Build using Arduino, while using two arduino boards in conjunction.

* `Cognitive Neuroscience` - Group based analyses of brainwaves. No code given assignment based nature, thus no open exploration of the task.
* `Research Workshop` - Project paper: "A deeper deeper look into online reviews of mental disorders and their impact on Natural Language Processing"
* `Software Engineering` - A bird detection app based on sound and images for android. The folder shows the parts I contributed. The app did not fully work in the end, given inexperienced group members in programming.
* `Foundation of Databases` - This project consists of the creation of a database. The topic chosen was Formula 1
* `Computational Linguistics` - Assignment testing semester acquired knowledge
* `Knowledge Representation` - Project for inference logic, programmed in Prologue
* `Bachelor Thesis` - “A Deep Learning Approach On Fusion Technique Comparison Applied To Affordance Classification”

## Master Years
The code is based on a combined implementation of gazebo and ROS2, thus to run each experiment this environemt has to be guaranteed.

To run the code these packages need to be installed additionally to ROS2 Jazzy:
* `Open-Cv`

The Crazyflie wall following tutorial has been used as a basis for these implementations.
The tutorial can be found under https://www.bitcraze.io/2024/09/crazyflies-adventures-with-ros-2-and-gazebo/.


Once the code has been downloaded, situate yourself in the given experiment folder you want to run.
* First source your ros2 codebase `source /opt/ros/{your-ros2-DIST}/setup.bash`
* Next you need to build the codebase `colcon build`
* Source your setup file `source install/local_setup.bash`
* Execute the simulated environment `ros2 launch LaunchSup.py`

