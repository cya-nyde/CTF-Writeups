Notes on Services
===================

Previously included in general notes; port numbers and interaction syntax for commonly found services

## Management

### SSH

Can be installed and enabled with <code>sudo apt install openssh</code> and <code>sudo systemctl enable openssh</code> (may require firewall configuration on client side to work)

#### Syntax

`ssh <username>@x.x.x.x`

- Unless specified in-line (bad practice), will prompt for password upon connection
- Often enabled when **port 22** is open

## File Access

### SMB

From Linux, *smbclient* is used to access shares

#### Syntax

`smbclient //server/share`

- ##### Options
    - **U** followed by username%password to authenticate inline or just the username to prompt for password
    - **N** prompts to enter user and password separately
    - **W** Specifies workgroup name, if applicable

### FTP/TFTP

- **FTP** - File Transfer Protocol
- **TFTP** - Trivial File Transfer Protocol

#### Syntax

- `ftp` is used to interact with the service
- Common commands:
    - **?** displays descriptions for commands
    - **dir** shows content inside remote directory
    - **disconnect** stays within FTP but disconnects from remote server
    - **close** ends the FTP session
    - **get** copies single remote file to local computer
    - **put** copies single file from local computer to host

