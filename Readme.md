## Netinstall Combo Repository Overview

The **Netinstall Combo** repository serves as a resource for streamlined installation using Alpine Linux.

### Dependencies

Ensure you have the following before proceeding with the installation:

- **Alpine Linux**: It's recommended to use the **edge** version for the latest features and improvements.
- **Required Packages**:
  - **dialog**: For displaying dialog boxes for user interactions.
  - **agetty**: Agetty is a variant of getty and is used for terminal handling.
  - **bash**: Ensure that the Bash shell is available.
  - **ca-certificates**: Used for SSL certificate management.

---

### Installation Steps

1. **Copy Repository Files**:
   - Navigate to the desired location on your system.
   - Utilize the following command to copy the files into the `/netinstall` directory:
     ```bash
     cp -r /path/to/repository/* /netinstall/
     ```

2. **Run the Installation Script**:
   - After copying the files, execute the main installation script with:
     ```bash
     /netinstall/main.sh
     ```

