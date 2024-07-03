# User Management Script

This script (`create_users.sh`) automates the creation of Unix users and groups based on input provided in a text file (`test_users.txt`). It also generates random passwords for each user and logs all actions to a specified log file (`/var/log/user_management.log`). The passwords are securely stored in a separate CSV file (`/var/secure/user_passwords.csv`).

## Features

- **User and Group Creation:** Creates Unix users and groups specified in the input file (`test_users.txt`). If users or groups already exist, it logs this information.
  
- **Password Generation:** Generates a random password for each user and securely stores it in `/var/secure/user_passwords.csv`.
  
- **Logging:** Logs all actions, including user/group creation and password generation, with timestamps in `/var/log/user_management.log`.
  
- **Security:** Ensures that sensitive files (`user_passwords.csv`) are created with appropriate permissions (`chmod 600`).

## Usage

### Requirements

- Bash shell environment (Linux/Unix system).
- Input file (`test_users.txt`) formatted with user and group information.

### Running the Script

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Dayvid0063/HNG_DevOps.git
   sudo bash create_users.sh test_users.txt
