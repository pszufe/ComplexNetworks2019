# Summer School on Data Science Tools and Techniques in Modelling Complex Networks

### [Przemysław Szufel](https://szufel.pl/en/)

#### Installation instructions

1. Copy this repository to your local folder. This can be done by running the following command:

```bash
  git clone https://github.com/pszufe/ComplexNetworks2019.git
  ```
  Note that on the Windows platform the above command requires the *git* tool available at [https://git-scm.com/download/win](https://git-scm.com/download/win).

2. Please download Julia from [https://julialang.org/downloads/](https://julialang.org/downloads/) and install 
*Current stable release* (at the time of the workshop it is version `1.1.1`. We recommend selecting the 64-bit platform.

3. Type `julia` to start Julia and run the following installation scripts:

  ```julia
  using Pkg
  Pkg.add("PyCall")
  Pkg.add("Conda")
  using Conda
  Conda.runconda(`install folium -c conda-forge`)
  ```

4. Note that on the day 4 we will be processing XML data. 

  On the Linux platform processing such data requires the XML library `libexpat` to be present in the operating system.
  When using Linux Ubuntu run the following command:
  ```bash
  sudo apt install libexpat-dev
  ```
  The above step is not required on Windows. 

5. The programming environment for Julia is an Atom (https://atom.io/) plugin named Juno. In order to install Atom with Juno please follow the steps below:

  a)      Download and install Atom (available at https://atom.io/).
  
  b)      Start Atom and press `Ctrl` + `,` ( *Ctrl  key* + *comma key* ) to open the *Atom settings* screen.
  
  c)      Select the *Install* tab.
  
  d)      In the *Search packages* field, type uber-juno and press *Enter* .
  
  e)      You will see the uber-juno package developed by JunoLab—click *Install* to install the package.

6. Optionally, it is possible to use Julia within Jupyter notebook (this was largely used during the days 1 and 2 of the workshop).
In order to try Julia inside a Jupyter notebook start the Julia console and run the two following commands:

  ```julia
  using IJulia
  notebook(dir="/folder/to/source/codes")   # a new web browser tab should open
  ```


## Modelling hyperaphs in Julia with the Hypergraphs.jl package

### Day 3, Wednesday, August 21st, 2019, 13:00 to 16:00

**Objective**: 
Understand how SimpleHypergraphs.jl can be used to process hypergraph data.
Represent the Yelp reviews dataset as a hyperaph and measure modularity across different communities. 

All files needed for this part wil be stored in `day3` folder.

After installing Julia You can run `julia 1_prepareenv.jl` command from system
shell in the `day1` directory before the workshop
(this will load and install all required packages).

## Graph-based analysis of spatial data and transportation system modeling in Julia
### Day 4, Thursday, August 22nd, 2019, 13:00 to 16:00

**Objective**: Provide overview of working with road network and map data in Julia 
using the [OpenStreetMapX.jl](https://github.com/pszufe/OpenStreetMapX.jl/) library.


All files needed for this part are stored in `day4` folder.

After installing Julia You can run `julia 1_prepareenv.jl` command from system
shell in the `day4` directory before the workshop
(this will load and install all required packages).


## Large scale graph analysis with parallel and distributed computing tools in Julia
### Day 5, Friday, August 23rd, 2019, 13:00 to 16:00
**Objective**: understand how to perform distributed computing in Julia and how 
it can be applied to distribute workloads on graph data. 

All files needed for this part are stored in `day5` folder.

After installing Julia You can run `julia 1_prepareenv.jl` command from system
shell in the `day5` directory before the workshop
(this will load and install all required packages).
