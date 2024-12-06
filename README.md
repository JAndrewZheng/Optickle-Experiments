# README: Running a Custom Simulation in Optickle

## Steps to Run the Simulation

### 1. Place the MATLAB Script in the Library Folder
- Add your custom MATLAB script (e.g., `simulate_ETM.m`) to the `lib` directory of the Optickle package.
- Example: `Optickle/lib/simulate_ETM.m`.

### 2. Set Up the Bash Script
- Place the provided Bash script in the `Experiments` folder of the Optickle package.
- Ensure the script correctly points to the paths for:
  - The Optickle library.
  - Your custom MATLAB script.

---

## Current Issue with Optickle

### Error Description

#### 1. Inspecting Ports and Components
- **Issue**: Attempted to use the `showopt` and `list` functions to inspect components and port names in the Optickle model.
- **Error Messages**:
  ```plaintext
  Undefined function 'showopt' for input arguments of type 'Optickle'.
  Undefined function 'list' for input arguments of type 'Optickle'.
  ```
- **Impact**: Unable to verify port configurations and understand component structures.

#### 2. Connecting Components
- **Issue**: Errors when attempting to connect components due to invalid port names or misconfigured components.
- **Error Message**:
  ```plaintext
  Error using Optic/getInputPortNum
  Invalid input name "in1" for optic "Interference".

  Error in Optickle/addLink (line 31)
  portTo = getInputPortNum(opt.optic{snTo}, nameIn);

  Error in simulate_ETM (line 42)
  [opt] = addLink(opt, snEPR1, 'out', snInterference, 'in1', 0); % Use correct port names
  ```

#### 3. Serial Number Mismatch
- **Issue**: Errors caused by referencing components or serial numbers incorrectly during linking.
- **Error Message**:
  ```plaintext
  Error using Optickle/getSerialNum
  No optic named "Ti:Sapphire Laser" found.

  Error in Optickle/addLink (line 20)
  snFrom = getSerialNum(opt, snFrom);

  Error in simulate_ETM (line 18)
  addLink(opt, 'Ti:Sapphire Laser', 1, 'SHG', 1, 0); % Use names of components
  ```

#### 4. Duplicate Connections
- **Issue**: Attempted to connect a component already linked to a specific port.
- **Error Message**:
  ```plaintext
  Error using Optickle/addLink
  Unavailable Sink: DelayLine->out already linked to Interference<-in
  ```

#### 5. Lack of Debugging Tools
- **Issue**: Optickle lacks built-in functions to list components or verify port names.
- **Impact**:
  - Difficult to identify available port names (e.g., `inA`, `inB`, etc.).
  - Challenging to confirm valid and non-conflicting connections.
  - Hard to inspect the internal structure of components.

---

## Documentation Challenges
- **Limitations**: The available user documentation for Optickle does not provide sufficient guidance for detailed setups.
- **Workaround**: You'll probs  need to:
  - Examine the examples in the `lib` folder.
  - Reverse-engineer existing scripts to resolve issues and properly configure the simulation.