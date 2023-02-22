## Installation

- Set system password using `sudo passwd`.
- For SSH, either:
  - Generate a new SSH key using `ssh-keygen`.
    Be sure to import the new SSH key into your GitHub account.
  - Import an existing SSH key using `ssh-add`.
    You can use   `ssh-add -l` to view all valid SSH keys.
- Download the pCloud binary from [here][pcloud-download], and copy it to
  `~/.local/bin`:
  ```sh
  chmod u+x pcloud
  mv pcloud ~/.local/bin
  ```

- Clone the repository and run `scripts/install.sh`:
  ```sh
  git clone git@github.com:darth10/dotfiles.git
  cd dotfiles
  ./scripts/install.sh
  ```

[pcloud-download]: https://www.pcloud.com/download-free-online-cloud-file-storage.html
