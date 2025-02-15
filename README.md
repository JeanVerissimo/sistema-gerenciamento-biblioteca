# 📚 Library Management System (COBOL)

[🇧🇷 Leia em Português](README.pt.md)

Welcome to the **Library Management System**, a system developed in **COBOL** to manage books, users, and loans in a library.

## 📌 Description

This system allows the control of book loans, user registration, and report generation, all within a COBOL environment for mainframes.

## 🏗 Project Structure

The system is composed of the following COBOL modules:

- **SISTEMA-BIBLIOTECA.cbl** → Main module that manages integration between subsystems.
- **SIS-LIVROS.cbl** → Book management (registration, queries, and maintenance).
- **SIS-USUARIOS.cbl** → User management (registration, queries, and maintenance).
- **SIS-EMPRESTIMOS.cbl** → Loan and book return management.
- **SIS-RELATORIOS.cbl** → Operational report generation.

## 🚀 Installation and Execution

### 1️⃣ Compile the source code

Use the **Enterprise COBOL** compiler to compile the modules:

```sh
cobc -x SISTEMA-BIBLIOTECA.cbl -o library
```

Or, for a z/OS environment, use JCL to submit the compilation:

```
//COMPILE JOB (COBOL),
// MSGCLASS=A,CLASS=A
//STEP1 EXEC IGYCRCTL
//SYSIN DD DSN=USER.SOURCE(SISTEMA-BIBLIOTECA),DISP=SHR
//SYSLIN DD DSN=USER.OBJLIB(SISTEMA-BIBLIOTECA),DISP=SHR
//SYSPRINT DD SYSOUT=*
//
```

### 2️⃣ Run the program

After successful compilation, execute:

```sh
./library
```

Or in z/OS:

```
//RUN EXEC PGM=SISTEMA-BIBLIOTECA
//STEPLIB DD DSN=USER.LOADLIB,DISP=SHR
//SYSOUT DD SYSOUT=*
//
```

## 📊 Features

- 📘 **Book registration and queries**
- 👤 **User management**
- 🔄 **Loan and return processing**
- 📑 **Report generation**

