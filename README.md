## Installation

- Set system password using `sudo passwd`.
- For SSH, either:
  - Generate a new SSH key using `ssh-keygen`.
    Be sure to import the new SSH key into your GitHub account.
  - Import an existing SSH key using `ssh-add`.
    You can use   `ssh-add -l` to view all valid SSH keys.
- Clone the repository and run `install.sh`:
  ```sh
  git clone git@github.com:darth10/dotfiles.git
  cd dotfiles
  ./install.sh
  ```
