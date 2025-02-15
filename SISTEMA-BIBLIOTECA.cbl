       IDENTIFICATION DIVISION.
       PROGRAM-ID.      SISTEMA-BIBLITECA.
       AUTHOR.          JEAN CARLOS.
       DATE-WRITTEN.    12/02/2025.
       DATE-COMPILED.   15/02/2025.
       SECURITY.        APENAS O AUTOR PODE MODIFICA-LO.
      *REMARKS.         Programa principal do sistema de gerenciamento

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES. DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-COMANDO             PIC X(100).
       77 WS-OPCAO               PIC X(1) VALUE SPACES.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM MENU.
           STOP RUN.

       MENU.
           PERFORM UNTIL WS-OPCAO = "N"
               DISPLAY "====================================="
               DISPLAY "  SISTEMA DE GERENCIAMENTO DA BIBLIOTECA"
               DISPLAY "====================================="
               DISPLAY "1 - Livros"
               DISPLAY "2 - Usuários"
               DISPLAY "3 - Emprestimos"
               DISPLAY "4 - Relatorios"
               DISPLAY "5 - Encerrar"
               DISPLAY "Escolha uma opção (1/2/3/4/5): "
               ACCEPT WS-OPCAO

               EVALUATE WS-OPCAO
                   WHEN "1"
                       MOVE "SIS-LIVROS" TO WS-COMANDO
                       CALL "SYSTEM" USING WS-COMANDO
                   WHEN "2"
                       MOVE "SIS-USUARIOS" TO WS-COMANDO
                       CALL "SYSTEM" USING WS-COMANDO
                   WHEN "3"
                       MOVE "SIS-EMPRESTIMOS" TO WS-COMANDO
                       CALL "SYSTEM" USING WS-COMANDO
                   WHEN "4"
                       MOVE "SIS-RELATORIOS" TO WS-COMANDO
                       CALL "SYSTEM" USING WS-COMANDO
                   WHEN "5"
                       DISPLAY "ENCERRANDO PROGRAMA..."
                       MOVE "N" TO WS-OPCAO
                   WHEN OTHER
                       DISPLAY "OPÇÃO INVÁLIDA!"
               END-EVALUATE
           END-PERFORM.
