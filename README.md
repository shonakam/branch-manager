# 📄 Git Branch Manager Documentation

## 📌 Overview
**Branch Manager** is a Git-based tool designed to enforce **project-wide unique branch naming conventions** by registering and managing user nicknames in `members.json`. This script ensures that all contributors use **consistent and conflict-free branch prefixes**, preventing duplicate nicknames and automating Git synchronization.

The script seamlessly integrates with a **Git remote repository**, handling branch updates and reducing conflicts.

## 🚀 Features
✅ **Unique nickname registration** for standardized branch prefixes  
✅ **Automatic Git synchronization** with `main` or `master`  
✅ **Conflict prevention** using `git pull --rebase` before modifications  
✅ **Simple alias `git co`** for creating prefixed branches  
✅ **Project-wide enforcement**, ensuring consistency across repositories  

## 📌 Usage

### 1️⃣ Move to the Project Repository  
Navigate to your project repository where you want to use **Branch Manager**.

```sh
cd /path/to/your-project
```

### 2️⃣ Clone Branch Manager
Clone the Branch Manager repository into your project directory.

```sh
git clone <branch-manager>
```

### 3️⃣ Set Up Branch Manager
Navigate to the Branch Manager directory and make the script executable.

```sh
cd branch-manager
chmod +x branch-manager.sh
```
Register your nickname for branch prefixing.

```sh
bash branch-manager.sh -s
```

### 4️⃣ Create a New Branch
Use the git co command to create a new branch with your nickname as a prefix.

```sh
git co <branch-name>
```

🔹 Example
```sh
git co feature-login -> alice/feature-login
```