# Persistent AWS Credentials for Terminal Use (without CLI)

> This guide explains how to set up persistent AWS credentials for use with Terraform, Packer, and other AWS-compatible tools on Windows, without needing AWS CLI.

## ℹ️ Context
For Terraform to be able to make changes in your AWS account, you will need to set the AWS credentials for the IAM user your created.

You can do it executing these commands:
```
CMD:
$ set AWS_ACCESS_KEY_ID=(your access key id)
$ set AWS_SECRET_ACCESS_KEY=(your secret access key)

PowerShell:
$env:AWS_ACCESS_KEY_ID="YOUR_NEW_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_NEW_SECRET_KEY"
```

The problem is these variables apply only to the current shell, so if you open a new terminal or reboot your computer you'll need to set these variables again.

## How to make it persistent

---

### 🛠️ Ensure `$HOME` Environment variable exists

This variable should point to your user folder `C:\Users\<Your user>`. To make sure it exists open PowerShell and execute:

```
echo $env:HOME
```
If there's no output you have to create it:
- Open **"Edit environment variables for your account"**.
- Click **"New"** under "User variables".
- Set:
  - **Variable name:** `HOME`.
  - **Variable value:** `C:\Users\<Your user>`.
- Click **OK** and restart your terminal.


---


### 🔑 Create the `.aws/credentials` File

- Open File Explorer and navigate to your user folder `C:\Users\<Your user>`
- Create a new folder named `.aws` (dot included).
- Inside `.aws`, create a new file named `credentials`.
- Open the file with a text editor and add: 
  ```
  [default]
  aws_access_key_id=<Your aws access key id>
  aws_secret_access_key=<Your aws secret access key>
  ```
- Replace the keys with your credentials and save.
- Make sure your file doesn't have any extension. Right-click the file and rename it removing .txt, or run:
  `Rename-Item "$env:HOME\.aws\credentials.txt" "credentials"`


---


### ✅ Verifying the Setup

- Close and reopen your terminal to ensure environment variables are loaded.
- Run a tool like Terraform or Packer. If configured correctly, they will use your credentials automatically.


---


## ⚠️ Troubleshooting

- Make sure the file is named exactly `credentials` (no `.txt` extension).
- Ensure the `.aws` folder and `credentials` file are in your user directory.
- Double-check that `$HOME` points to your user folder.
- Restart your terminal after making changes to environment variables.


---


With this setup, your AWS credentials will be persistent and available for all terminal-based tools.