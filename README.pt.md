# 📚 Sistema de Gerenciamento de Biblioteca (COBOL)

[🇬🇧 Read in English](README.md)

Bem-vindo ao **Sistema de Gerenciamento de Biblioteca**, um sistema desenvolvido em **COBOL** para gerenciar livros, usuários e empréstimos em uma biblioteca.

## 📌 Descrição

Este sistema permite o controle de empréstimos de livros, cadastramento de usuários e geração de relatórios, tudo em um ambiente COBOL para mainframes.

## 🏗 Estrutura do Projeto

O sistema é composto pelos seguintes módulos COBOL:

- **SISTEMA-BIBLIOTECA.cbl** → Módulo principal que gerencia a integração entre os subsistemas.
- **SIS-LIVROS.cbl** → Gerenciamento de livros (cadastro, consulta e manutenção).
- **SIS-USUARIOS.cbl** → Gerenciamento de usuários (cadastro, consulta e manutenção).
- **SIS-EMPRESTIMOS.cbl** → Controle de empréstimos e devoluções de livros.
- **SIS-RELATORIOS.cbl** → Geração de relatórios operacionais.

## 🚀 Instalação e Execução

### 1️⃣ Compilar o código-fonte

Utilize o compilador **Enterprise COBOL** para compilar os módulos:

```sh
cobc -x SISTEMA-BIBLIOTECA.cbl -o biblioteca
```

Ou, para um ambiente z/OS, utilize JCL para submeter a compilação:

```
//COMPILE JOB (COBOL),
// MSGCLASS=A,CLASS=A
//STEP1 EXEC IGYCRCTL
//SYSIN DD DSN=USER.SOURCE(SISTEMA-BIBLIOTECA),DISP=SHR
//SYSLIN DD DSN=USER.OBJLIB(SISTEMA-BIBLIOTECA),DISP=SHR
//SYSPRINT DD SYSOUT=*
//
```

### 2️⃣ Executar o programa

Após a compilação bem-sucedida, execute:

```sh
./biblioteca
```

Ou no z/OS:

```
//RUN EXEC PGM=SISTEMA-BIBLIOTECA
//STEPLIB DD DSN=USER.LOADLIB,DISP=SHR
//SYSOUT DD SYSOUT=*
//
```

## 📊 Funcionalidades

- 📘 **Cadastro e consulta de livros**
- 👤 **Gerenciamento de usuários**
- 🔄 **Empréstimos e devoluções**
- 📑 **Geração de relatórios**
