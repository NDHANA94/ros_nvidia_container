## ROS Docker Container with NVIDIA GPU-Accelerated OpenGL for Gazebo and RViz

This repo explains how to create a docker container on an Ubuntu host machine with NVIDIA GPU accelerated OpenGL for Gazebo and RViz Graphic rendering for a smooth simulation experience with ROS. 

### OUTLINE
1. [Host Machine Setup for NVIDIA GPU](#1-host-machine-setup-for-nvidia-gpu)
2. [Building the Docker Image](#2-building-the-docker-image)
3. [Run the container](#3-run-the-container)
4. [Open in VS-Code DevContainer](#4-open-in-vs-code-dev-container)

</br>
</br>

## 1. Host Machine Setup for NVIDIA GPU:

Follow these steps to setup your Ubuntu host machine to enable docker to use the NVIDIA GPU:

1. Make sure you have installed NVIDIA Driver. 
    - Run this command to verify.
        ```bash
        nvidia-smi
        ```

        If the driver is installed correctly, this command will display information about your NVIDIA GPU, including driver version, and CUDA version. 
        
        </br>

    - If it's **NOT** installed;
        - Update the Package List:
            ```bash
            ubuntu-drivers devices
            ```  
        - Detect Available NVIDIA Drivers: Use the ubuntu-drivers tool to find compatible drivers for your system:
            ```bash
            ubuntu-drivers devices
            ```

            This command will list all available NVIDIA drivers for your GPU. The recommended driver version will be indicated.

        - Install the Recommended Driver: To install the recommended driver version:
            ```bash
            sudo ubuntu-drivers install
            ```

            Alternatively, you can specify a specific driver version (e.g., nvidia-driver-560):

            ```bash
            sudo apt install nvidia-driver-560
            ```
        
        - Reboot the System: After installation, reboot your system for the driver to take effect.
            ```bash
            sudo reboot
            ```

        - Verify Installation: After rebooting, run nvidia-smi to check if the driver was installed successfully.
            ```bash
            nvidia-smi
            ```
            </br>


2. Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) and `nvidia-docker2:

    -  Configure the production repository for `nvidia-container-toolkit`:
        ```bash
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

        ```

    - Update the packages list from the repository and Install the NVIDIA Container Toolkit packages:
        ```bash
        sudo apt-get update
        sudo apt-get install -y nvidia-container-toolkit
        ```

    - Configure the container runtime by using the nvidia-ctk command:
        ```bash
        sudo nvidia-ctk runtime configure --runtime=docker
        ```
    - ⚠️ Make sure `/etc/docker/daemon.json` file exists and configured correctly. It should have the following context.
        ```json
        {
            "default-runtime": "nvidia",
            "runtimes": {
                "nvidia": {
                    "args": [],
                    "path": "nvidia-container-runtime"
                }
            }
        }
        ```

        - If you don't have this file create one:
            ```bash
            sudo nano /etc/docker/daemon.json
            ```

            - copy/paste the above mentioned configuration.
            - save (ctrl+s) and exit (ctrl+x)
         
    - Install `nvidia-docker2`:
        ```bash
        sudo apt-get update
        sudo apt-get install -y nvidia-docker2
        ```

    - Restart the Docker daemon:
        ```bash
        sudo systemctl restart docker
        ```
</br>

3. Make sure your host has selected NVIDIA GPU for rendering:

    - Install `prime`:
        ```bash
        sudo apt-get install nvidia-prime
        ```
    
    - select NVIDIA GPU for rendering:
        ```bash
        sudo prime-select nvidia
        ```
    
    - Verify selection:
        ```bash
        prime-select query
        ```


</br>
</br>

## 2. Building the Docker Image:

- Clone this repo:
    ```bash
    cd ~/
    git clone .....
    cd ros_nvidia_container
    ```
    </br>

- ⚠️ The provided Dockerfile  (`ros_nvidia_container/.devcontainer/Dockerfile`) is configured for installing ROS Noetic in the container. If you wish to use a different ROS distribution, please modify the Dockerfile accordingly.
</br>

- ⚠️ Edit the `cuda-toolkit` version (**line: 43**) for your host cuda version. ( running `nvidia-smi` command you can see the cuda version.)
- Build the docker image:
    ```bash
    cd ~/ros_nvidia_container
    docker build -t <Image Name> .devcontainer/
    ```

- ⚠️ Check if your host has `.Xauthority` file in `HOME` directory:
    ```bash 
    ls ~/.Xauthority
    ```

    - If the file does not exist, create one:

        ```bash
        touch ~/.Xauthority
        ```

-  Permissions to `.Xauthority` file:
    ```bash
    chmod 664 ~/.Xauthority
    ```

</br>
</br>

## 3. Run the container:

Use the `run_ros_nvidia_container.sh` file to run the docker container. 

- ⚠️ Edit the image name in `run_ros_nvidia_container.sh` file (**line: 36)** to the image name you chose to build.

- ⚠️ configuring X11 permissions for Docker:
    ```bash
    xhost +local:docker
    ```
    Running this command is very important before running the container to run GUI applications inside a Docker container and display them on your host's screen.

- Grant executable permission:
    ```bash
    chmod +x ~/ros_nvidia_container/run_ros_nvidia_container.sh
    ```

- Run the container:
    ```bash
    ~/ros_nvidia_container/run_ros_nvidia_container.sh
    ```

</br></br>

## 4. Open in VS-Code Dev Container:

You can use vscode remote extention to open this container.

1. Open VS-Code and Install `Install the Dev Containers` extension.

2. Open Your Project: Open the folder that contains your .devcontainer directory.

3. Reopen in Container:
    - Once you have the folder open in VS Code, you can reopen it in a container by clicking on the green icon in the bottom left corner of the VS Code window.
    - From the menu, select Remote-Containers: Reopen in Container. This option will build the Docker image defined in your Dockerfile and start a new container based on it.

4. Build and Start the Container: 
    - VS Code will automatically read the configuration from the .devcontainer/Dockerfile and .devcontainer.json files, build the container, and open a new window connected to it. You can monitor the output in the terminal that appears in the bottom panel.

5. Access the Terminal: 
    - Once the container is running, you can open a terminal inside the container by going to Terminal > New Terminal. This terminal will give you access to the environment set up in your Docker container.
