### Table of Content
⩺ [Terminology](#terminology)<br/>
⩺ [Generate keys using PuTTYGen](#generate-keys-using-puttygen)<br/>
⩺ [Generate keys using ssh-keygen on Linux](#generate-keys-using-ssh-keygen)<br/>
⩺ Install the Public Key on the remote host<br/>
&nbsp; ⤷ [OpenVMS host](#openvms-host)<br/>
&nbsp; ⤷ [Linux Host](#linux-host)<br/>
⩺ [Install the private key in PuTTY](#install-the-private-key-in-putty)<br/>
⩺ [Install the private key in WinSCP](#install-the-private-key-in-winscp)<br/>
⩺ [Install the private key in TurboFTP](#install-the-private-key-in-turboftp)<br/>
⩺ [Generate SSH keys on VMS box (For the brave souls)](#generate-ssh-keys-on-vms-box)<br/>

***

# Terminology

#### The client
is a machine you are sitting at. Most of time it is either a michne under your desk or a Citrix session (or Virtual Data Room session in this regard).

#### The host
is the OpenVMS box, i.e. HFCP09, HFCP10, HFCP11, HFCP12 (or XVC001 in Virtual Data Room). We are on closed internal company network, so the maximum possible key strength is not required.

#### User Private Key
is key that is kept secret by the SSH user on his/hers client machine. The user must never reveal the private key to anyone.

#### User Public Key
A user public key is a counterpart to user private key. They are generated at the same time. The user public key can be safely revealed to anyone, without compromising user identity. To allow authorization of the user on a server, the user public key is registered on the server.

# Generate keys using PuTTYGen

1. Run PuTTYGen
   * Either Choose _Run..._ from Windows start menu and type `puttygen`
   * Or Run cmd.exe and type `puttygen`
   * Or Run WinSCP. In the initial "WinSCP Login" window click "Stored sessions..." in the left list and then click "Tools..." button and choose "PuTTYGen".

1. In the PuTTY Key Generator window click the "Generate" button. Fiddle the mouse randomly as asked. Shortly thereafter, the program will generate the key and display the result

1. Do not enter a passphrase in the "Key passphrase" and "Confirm passphrase" boxes, unless you want to be asked for it in future.

1. Save both public key and the private key using approriate buttons. Pick a file location that is accessible only to you.

# Generate keys using ssh-keygen on Linux

1. Log into your Linux account which you want to connect to the remote system.

    * At the prompt write `ssh-keygen`.
    * When asked enter the desired name for the key pair (default is fine as well), leave the standard location ~/.ssh/ .

1. Convert the generated public key into openssh format, you might also want to give the public key a meaningful name: 
   `[haarben@eclwsd110 .ssh]$ ssh-keygen -e -f id_rsa.pub > id_rsa_haarben.pub`

1. Install the converted public key on the remote host as described below, the private key has to remain in the ~/.ssh/ directory of the linux account.

# Install the Public Key on the remote host

**The private key is not installed on any remote host.**

## OpenVMS host

1. Create the subdirectory `[username.SSH2]` if it does not exist:
   ```
   home
   create/directory [.SSH2]
   ```
1. Copy the **public key** file to the server to the user's `[username.SSH2]` directory. Name the file properly: `username-hostname.PUB` replacing dots by undescores (e.g. NOVAKJ-PC12345_OA_PNRAD_NET.PUB)

   Make sure the file is protected properly: `SET FILE/PROTECTION=(S:WRED,O:WRED,G:RE,W:R) NOVAKJ-PC12345_OA_PNRAD_NET.PUB`

1. Create the [username.SSH2]AUTHORIZATION. file. Add entries to the [username.SSH2]AUTHORIZATION. file as necessary. Each entry is a single line that identifies the user's client public key file name. The format of the entry is `KEY username-hostname.PUB`.

   For example, if the user's public key file name is `NOVAKJ-PC12345_OA_PNRAD_NET.PUB`, add the following line to the AUTHORIZATION. file:
   ```
   KEY NOVAKJ-PC12345_OA_PNRAD_NET.PUB
   ```

## Linux Host

1. Launch PuTTY and log into the remote server with your existing user credentials (password).
1. Use your preferred text editor to create and/or open the authorized_keys file:
   ```
   nano ~/.ssh/authorized_keys
   ```
1. Copy the entire public key on windows side (the contents of "Public key for pasting into OpenSSH authorized_keys file:" frame in PuTTY Key Generator)
1. Paste the public key into the authorized_keys file. It has to start with word _ssh-rsa_ and entire key has to be on single line.
   ```
   ssh-rsa AAAAB3Nza…Cܸ7QN7z
   ```
1. Save the file and close the text editor.
1. Adjust the permissions of the authorized_keys file so that the file does not allow group writable permissions.
   ```
   chmod 600 ~/.ssh/authorized_keys
   ```

# Install the private key in PuTTY

1. Start the "PuTTY Configuration" window.
1. Load the appropriate session profile.
1. In the left list go to _Connection_ ⇒ _SSH_ ⇒ _Auth_
1. _Browse_ to select correct *.ppk in the "Private key file for authentication" text box.
1. Don't forget to set _Connection->Data_ Auto-login username.
1. In the left list go back to the _Session_, and click _Save_ to update the profile.
1. The session will use public key authentication without prompting password
 

# Install the private key in WinSCP

1. Run WinSCP.
1. In the initial "WinSCP Login" window 
1. Select a session in the list and click _Edit_ button
1. Browse to select correct *.ppk in the "Private key file" text box.
1. Click _Save_

# Install the private key in TurboFTP
1. Open Address Book
2. Press button "New Site" and select "SFTP over SSH2"
1. Fill-in values in the "General" tab:
   * Site Name: _use target hostname_ (`xvc001` on VDR)
   * Site Address: _use target hostname_ (`xvc001` on VDR)
   * Port: 22 (this values is pre-filled)
   * Initial Local Folder: _your preferred local folder_ (e.g. `P:\` on VDR, `N:\` on Citrix)
1. Check ticks in the "Connect" tab, left others in default:
   * Bypass firewall/proxy for this site
   * PASV mode
   * Server does NOT support download resume
   * Server does NOT support upload resume
   * Enable Anti-Idle
   * Disable MLSD
1. Fill in values in the "Security" tab:
   * Password encryption: Not supported
   * Secure connection mode: SFTP over SSH2
   * Port: 22
   * Public key: filename of your public key
   * Private key: filename of your private key 

# Generate SSH keys on VMS box

For the brave souls if really needed. See also <img src="/dev/ccp.dev/blob/master/img/icon-link-web-16.png"> [OpenVMS Systems Documentation: Setting Up Public-Key Authentication](http://h41379.www4.hpe.com/doc/83final/ba548_90007/ch03s08.html)

The ssh_keygen has strange name on OpenVMS box. Just run
```
MCR TCPIP$SSH_SSH-KEYGEN2.EXE
```
Press <_enter_> twice when asked for Passphrase. Your Private key saved to  `[username.SSH2]id_dsa_2048_a`, your Public key saved to `[username.SSH2]id_dsa_2048_a.pub`, regardless your current default dir.

The file containing your private key must be protected so that only you can access it:
```
home
down ssh2
SET FILE/PROTECTION=(S,W,G,O:RW) ID_DSA_2048_A.
```

The `[username.SSH2]ID_DSA_2048_A.PUB` file contains your public key, which you can copy to other hosts. Ensure that this file is available for world read access

If you want to use the VMS box as ssh client (you are connection from), then create a file named `[username.SSH2]IDENTIFICATION.` The IDENTIFICATION. file identifies your private-key file and tells the client which private keys are available for use in authenticating the server. For your default private-key file (as generated by the SSH_KEYGEN utility) use:
```
IdKey       ID_DSA_2048_A
```


