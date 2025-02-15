       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SIS-RELATORIOS.
       AUTHOR.        JEAN CARLOS.
       DATE-WRITTEN.  12/02/2025.
       DATE-COMPILED. 15/02/2025.
       SECURITY.      APENAS O AUTOR PODE MODIFICA-LO.
      *REMARKS.       Gera relatórios simples do sistema de biblioteca.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES. DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LIVROS ASSIGN TO 'LIVROS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS LIVRO-COD
               FILE STATUS IS WS-FILE-STATUS.

           SELECT USUARIOS ASSIGN TO 'USUARIOS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS USUARIO-COD
               FILE STATUS IS WS-FILE-STATUS.

           SELECT EMPRESTIMOS ASSIGN TO 'EMPRESTIMOS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS EMPRESTIMO-COD
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD LIVROS.
       01 REG-LIVRO.
           02 LIVRO-COD                PIC 9(5).
           02 LIVRO-TITULO             PIC X(50).
           02 LIVRO-AUTOR              PIC X(30).
           02 LIVRO-ANO                PIC 9(4).
           02 LIVRO-STATUS             PIC X(1).

       FD USUARIOS.
       01 REG-USUARIO.
           02 USUARIO-COD              PIC 9(5).
           02 USUARIO-NOME             PIC X(40).
           02 USUARIO-TELEFONE         PIC X(11).
           02 USUARIO-EMAIL            PIC X(20).
           02 USUARIO-STATUS           PIC X(1).

       FD EMPRESTIMOS.
       01 REG-EMPRESTIMO.
           02 EMPRESTIMO-COD           PIC 9(5).
           02 EMPRESTIMO-USUARIO       PIC 9(5).
           02 EMPRESTIMO-LIVRO         PIC 9(5).
           02 EMPRESTIMO-DATA-EMP      PIC X(10).
           02 EMPRESTIMO-DATA-DEV      PIC X(10).
           02 EMPRESTIMO-DATA-ENTREGA  PIC X(10).
           02 EMPRESTIMO-STATUS        PIC X(1).

       WORKING-STORAGE SECTION.
       77 WS-FILE-STATUS               PIC X(2)       VALUE SPACES.
       77 WS-OPCAO                     PIC X(1)       VALUE 'S'.
       77 WS-REG-CONTADOR              PIC 9(5)       VALUE 0.
       77 WS-REG-DISPONIVEIS           PIC 9(5)       VALUE 0.
       77 WS-REG-ATIVOS                PIC 9(5)       VALUE 0.
       77 WS-REG-EMPRESTIMOS-ATIVOS    PIC 9(5)       VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM MENU.
           STOP RUN.

       MENU.
           PERFORM UNTIL WS-OPCAO = "N"
               DISPLAY "-------------------------------------"
               DISPLAY "        RELATÓRIOS DO SISTEMA       "
               DISPLAY "-------------------------------------"
               DISPLAY "1 - Lista de Livros Disponíveis"
               DISPLAY "2 - Lista de Usuários Cadastrados"
               DISPLAY "3 - Lista de Emprestimos Ativos"
               DISPLAY "4 - Voltar"
               DISPLAY "Escolha uma opção (1/2/3/4): "
               ACCEPT WS-OPCAO

               EVALUATE WS-OPCAO
                   WHEN '1'
                       PERFORM RELATORIO-LIVROS
                   WHEN '2'
                       PERFORM RELATORIO-USUARIOS
                   WHEN '3'
                       PERFORM RELATORIO-EMPRESTIMOS
                   WHEN '4'
                       MOVE "N" TO WS-OPCAO
                   WHEN OTHER
                       DISPLAY "OPÇÃO INVÁLIDA!"
               END-EVALUATE
           END-PERFORM.

       ABRIR-EMPRESTIMOS.
           OPEN I-O EMPRESTIMOS.
           EVALUATE WS-FILE-STATUS
               WHEN "00" CONTINUE
               WHEN "35"
                   DISPLAY "CRIANDO EMPRESTIMOS.DAT..."
                   OPEN OUTPUT EMPRESTIMOS
                   CLOSE EMPRESTIMOS
                   OPEN I-O EMPRESTIMOS
               WHEN OTHER
                   DISPLAY "ERRO AO ABRIR EMPRESTIMOS.DAT! STATUS: "
                   WS-FILE-STATUS
                   STOP RUN
           END-EVALUATE.

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

       ABRIR-LIVROS.
           OPEN I-O LIVROS.
           EVALUATE WS-FILE-STATUS
               WHEN "00" CONTINUE
               WHEN "35"
                   DISPLAY "CRIANDO LIVROS.DAT..."
                   OPEN OUTPUT LIVROS
                   CLOSE LIVROS
                   OPEN I-O LIVROS
               WHEN OTHER
                   DISPLAY "ERRO AO ABRIR LIVROS.DAT! STATUS: "
                   WS-FILE-STATUS
                   STOP RUN
           END-EVALUATE.

       RELATORIO-LIVROS.
           MOVE 0 TO WS-REG-CONTADOR.
           MOVE 0 TO WS-REG-DISPONIVEIS.
           PERFORM ABRIR-LIVROS

           DISPLAY "==================================================="
           DISPLAY "                RELATÓRIO DE LIVROS DISPONÍVEIS    "
           DISPLAY "==================================================="
           DISPLAY " CÓDIGO  |         TÍTULO               |   ANO    "
           DISPLAY "---------------------------------------------------"

           PERFORM UNTIL WS-FILE-STATUS = "10"
               READ LIVROS NEXT RECORD
                   AT END MOVE "10" TO WS-FILE-STATUS
               NOT AT END
                   ADD 1 TO WS-REG-CONTADOR
                   IF LIVRO-STATUS = "D" THEN
                       ADD 1 TO WS-REG-DISPONIVEIS
                       DISPLAY LIVRO-COD          " | "
                               LIVRO-TITULO(1:30) " | "
                               LIVRO-ANO
                   END-IF
           END-PERFORM.

           CLOSE LIVROS.
           DISPLAY "---------------------------------------------------"
           DISPLAY " TOTAL DE LIVROS DISPONÍVEIS: " WS-REG-DISPONIVEIS
           DISPLAY " TOTAL DE LIVROS NO SISTEMA: "  WS-REG-CONTADOR
           DISPLAY "==================================================".

       RELATORIO-USUARIOS.
           MOVE 0 TO WS-REG-CONTADOR.
           MOVE 0 TO WS-REG-ATIVOS.
           PERFORM ABRIR-USUARIOS.

           DISPLAY "==================================================="
           DISPLAY "                RELATÓRIO DE USUÁRIOS ATIVOS       "
           DISPLAY "==================================================="
           DISPLAY " CÓDIGO  |         NOME                | TELEFONE  "
           DISPLAY "---------------------------------------------------"

           PERFORM UNTIL WS-FILE-STATUS = "10"
               READ USUARIOS NEXT RECORD
                   AT END MOVE "10" TO WS-FILE-STATUS
               NOT AT END
                   ADD 1 TO WS-REG-CONTADOR
                   IF USUARIO-STATUS = "A" THEN
                       ADD 1 TO WS-REG-ATIVOS
                       DISPLAY USUARIO-COD        " | "
                               USUARIO-NOME(1:30) " | "
                               USUARIO-TELEFONE
                   END-IF
           END-PERFORM.

           CLOSE USUARIOS.
           DISPLAY "---------------------------------------------------"
           DISPLAY " TOTAL DE USUÁRIOS ATIVOS: "      WS-REG-ATIVOS
           DISPLAY " TOTAL DE USUÁRIOS CADASTRADOS: " WS-REG-CONTADOR
           DISPLAY "==================================================".

       RELATORIO-EMPRESTIMOS.
           MOVE 0 TO WS-REG-EMPRESTIMOS-ATIVOS.
           PERFORM ABRIR-EMPRESTIMOS.
           PERFORM ABRIR-USUARIOS.
           PERFORM ABRIR-LIVROS.

           DISPLAY "==================================================="
           DISPLAY "     RELATÓRIO DE EMPRÉSTIMOS EM ANDAMENTO         "
           DISPLAY "==================================================="
           DISPLAY "CÓD. EMP  |USUÁRIO      |LIVRO       |  EMP  | DEV "
           DISPLAY "---------------------------------------------------"

           PERFORM UNTIL WS-FILE-STATUS = "10"
               READ EMPRESTIMOS NEXT RECORD
                   AT END MOVE "10" TO WS-FILE-STATUS
               NOT AT END
                   IF EMPRESTIMO-STATUS = "E" THEN
                       ADD 1 TO WS-REG-EMPRESTIMOS-ATIVOS

                       MOVE EMPRESTIMO-USUARIO TO USUARIO-COD
                       READ USUARIOS KEY IS USUARIO-COD
                           INVALID KEY MOVE "USUÁRIO NÃO ENCONTRADO"
                           TO USUARIO-NOME
                       END-READ

                       MOVE EMPRESTIMO-LIVRO TO LIVRO-COD
                       READ LIVROS KEY IS LIVRO-COD
                           INVALID KEY MOVE "LIVRO NÃO ENCONTRADO"
                           TO LIVRO-TITULO
                       END-READ

                       DISPLAY EMPRESTIMO-COD      " | "
                               USUARIO-NOME(1:20)  " | "
                               LIVRO-TITULO(1:20)  " | "
                               EMPRESTIMO-DATA-EMP " | "
                               EMPRESTIMO-DATA-DEV
                   END-IF
           END-PERFORM.

           CLOSE EMPRESTIMOS.
           CLOSE USUARIOS.
           CLOSE LIVROS.
           DISPLAY "---------------------------------------------------"
           DISPLAY " TOTAL DE EMPRÉSTIMOS EM ANDAMENTO: "
                               WS-REG-EMPRESTIMOS-ATIVOS
           DISPLAY "==================================================".
