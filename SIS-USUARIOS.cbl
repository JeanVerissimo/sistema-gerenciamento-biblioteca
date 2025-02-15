       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SIS-USUARIOS.
       AUTHOR.        JEAN CARLOS.
       DATE-WRITTEN.  12/02/2025.
       DATE-COMPILED. 15/02/2025.
       SECURITY.      APENAS O AUTOR PODE MODIFICA-LO.
      *REMARKS.       Realiza cadastro de novos usuarios,
      *               pesquisa e apaga usuarios existentes.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES. DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USUARIOS ASSIGN TO 'USUARIOS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS USUARIO-COD
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD USUARIOS.
       01 REG-USUARIO.
           02 USUARIO-COD           PIC 9(5).
           02 USUARIO-NOME          PIC X(40).
           02 USUARIO-TELEFONE      PIC X(11).
           02 USUARIO-EMAIL         PIC X(20).
           02 USUARIO-STATUS        PIC X(1).

       WORKING-STORAGE SECTION.
       77 WS-FILE-STATUS            PIC X(2)       VALUE SPACES.
       77 WS-OPCAO                  PIC X(1)       VALUE 'S'.
       77 WS-RESPOSTA               PIC X(1).
       01 WS-USUARIO-DADOS.
           02 WS-COD                PIC 9(5).
           02 WS-NOME               PIC X(40).
           02 WS-TELEFONE           PIC X(11).
           02 WS-EMAIL              PIC X(20).
           02 WS-STATUS             PIC X(1).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM MENU.
           STOP RUN.

       MENU.
           PERFORM UNTIL WS-OPCAO = "N"
               DISPLAY "-------------------------------------"
               DISPLAY "  SISTEMA DE CADASTRO DE USU�RIOS"
               DISPLAY "-------------------------------------"
               DISPLAY "1 - Cadastrar Usu�rio"
               DISPLAY "2 - Pesquisar Usu�rio"
               DISPLAY "3 - Deletar Usu�rio"
               DISPLAY "4 - Voltar"
               DISPLAY "Escolha uma op��o (1/2/3/4): "
               ACCEPT WS-OPCAO

               EVALUATE WS-OPCAO
                   WHEN '1'
                       PERFORM CADASTRAR-USUARIO
                   WHEN '2'
                       PERFORM PESQUISAR-USUARIO
                   WHEN '3'
                       PERFORM DELETAR-USUARIO
                   WHEN '4'
                       MOVE "N" TO WS-OPCAO
                   WHEN OTHER
                       DISPLAY "OP��O INV�LIDA!"
               END-EVALUATE
           END-PERFORM.

       CADASTRAR-USUARIO.
           PERFORM ABRIR-USUARIOS.
           PERFORM SOLICITAR-DADOS-USUARIO.
           PERFORM GRAVAR-USUARIO.
           CLOSE USUARIOS.

       ABRIR-USUARIOS.
           OPEN I-O USUARIOS.
           EVALUATE WS-FILE-STATUS
               WHEN "00" CONTINUE
               WHEN "35"
                   DISPLAY "CRIANDO USUARIOS.DAT..."
                   OPEN OUTPUT USUARIOS
                   CLOSE USUARIOS
                   OPEN I-O USUARIOS
               WHEN OTHER
                   DISPLAY "ERRO AO ABRIR USUARIOS.DAT! STATUS: "
                   WS-FILE-STATUS
                   STOP RUN
           END-EVALUATE.

       SOLICITAR-DADOS-USUARIO.
           INITIALIZE WS-USUARIO-DADOS

           PERFORM UNTIL WS-COD > 0
               DISPLAY "DIGITE O C�DIGO DO USU�RIO (5 DIGITOS): "
               ACCEPT WS-COD
           END-PERFORM.

           PERFORM UNTIL WS-NOME NOT = SPACES
               DISPLAY "DIGITE O NOME COMPLETO DO USU�RIO: "
               ACCEPT WS-NOME
           END-PERFORM.

           PERFORM UNTIL WS-TELEFONE NOT = SPACES
               DISPLAY "DIGITE O TELEFONE COM DDD + 9 D�GITOS: "
               ACCEPT WS-TELEFONE
           END-PERFORM.

           PERFORM UNTIL WS-EMAIL NOT = SPACES
               DISPLAY "DIGITE O E-MAIL DO USU�RIO: "
               ACCEPT WS-EMAIL
           END-PERFORM.

           PERFORM UNTIL WS-STATUS = "A" OR WS-STATUS = "I"
               DISPLAY "DIGITE O STATUS (A=Ativo / I=Inativo): "
               ACCEPT WS-STATUS
               MOVE FUNCTION UPPER-CASE(WS-STATUS) TO WS-STATUS
           END-PERFORM.

       GRAVAR-USUARIO.
           MOVE WS-COD      TO USUARIO-COD
           MOVE WS-NOME     TO USUARIO-NOME
           MOVE WS-TELEFONE TO USUARIO-TELEFONE
           MOVE WS-EMAIL    TO USUARIO-EMAIL
           MOVE WS-STATUS   TO USUARIO-STATUS

           WRITE REG-USUARIO
           INVALID KEY DISPLAY "ERRO: C�DIGO J� EXISTE!"
           NOT INVALID KEY DISPLAY "USU�RIO CADASTRADO COM SUCESSO!".

       PESQUISAR-USUARIO.
           DISPLAY "DIGITE O C�DIGO DO USU�RIO PARA PESQUISAR: "
           ACCEPT WS-COD
           MOVE WS-COD TO USUARIO-COD

           PERFORM ABRIR-USUARIOS
           READ USUARIOS KEY IS USUARIO-COD
               INVALID KEY
                   DISPLAY "USU�RIO N�O ENCONTRADO."
                   CLOSE USUARIOS
                   EXIT PARAGRAPH
               NOT INVALID KEY DISPLAY "DADOS DO USU�RIO:"
                   DISPLAY "NOME:     " USUARIO-NOME
                   DISPLAY "TELEFONE: " USUARIO-TELEFONE
                   DISPLAY "E-MAIL:   " USUARIO-EMAIL
                   DISPLAY "STATUS:   " USUARIO-STATUS
           CLOSE USUARIOS.

       DELETAR-USUARIO.
           DISPLAY "DIGITE O C�DIGO DO USU�RIO PARA DELETAR: "
           ACCEPT WS-COD
           MOVE WS-COD TO USUARIO-COD

           PERFORM ABRIR-USUARIOS
           READ USUARIOS KEY IS USUARIO-COD
               INVALID KEY
                   DISPLAY "USU�RIO N�O ENCONTRADO."
                   CLOSE USUARIOS
                   EXIT PARAGRAPH
               NOT INVALID KEY
                   DISPLAY "DADOS DO USU�RIO:"
                   DISPLAY "NOME:     " USUARIO-NOME
                   DISPLAY "TELEFONE: " USUARIO-TELEFONE
                   DISPLAY "E-MAIL:   " USUARIO-EMAIL
                   DISPLAY "STATUS:   " USUARIO-STATUS
                   DISPLAY "DESEJA EXCLUIR ESSE USU�RIO?(S/N)"
                   ACCEPT WS-RESPOSTA
                   MOVE FUNCTION UPPER-CASE(WS-RESPOSTA) TO WS-RESPOSTA

                   IF WS-RESPOSTA = "S" THEN
                       DELETE USUARIOS
                       DISPLAY "USU�RIO DELETADO COM SUCESSO!"
                   ELSE
                       DISPLAY "EXCLUS�O CANCELADA."
                   END-IF
           CLOSE USUARIOS.
