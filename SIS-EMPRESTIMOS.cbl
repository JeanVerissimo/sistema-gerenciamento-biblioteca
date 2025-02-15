       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SIS-EMPRESTIMOS.
       AUTHOR.        JEAN CARLOS.
       DATE-WRITTEN.  12/02/2025.
       DATE-COMPILED. 15/02/2025.
       SECURITY.      APENAS O AUTOR PODE MODIFICA-LO.
      *REMARKS.       Realiza cadastro de novos emprestimos,
      *               devoluções e consulta de emprestimos.

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

           SELECT LIVROS ASSIGN TO 'LIVROS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS LIVRO-COD
               FILE STATUS IS WS-FILE-STATUS.

           SELECT EMPRESTIMOS ASSIGN TO 'EMPRESTIMOS.DAT'
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS EMPRESTIMO-COD
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD USUARIOS.
       01 REG-USUARIO.
           02 USUARIO-COD              PIC 9(5).
           02 USUARIO-NOME             PIC X(40).
           02 USUARIO-TELEFONE         PIC X(11).
           02 USUARIO-EMAIL            PIC X(20).
           02 USUARIO-STATUS           PIC X(1).

       FD LIVROS.
       01 REG-LIVRO.
           02 LIVRO-COD                PIC 9(5).
           02 LIVRO-TITULO             PIC X(50).
           02 LIVRO-AUTOR              PIC X(30).
           02 LIVRO-ANO                PIC 9(4).
           02 LIVRO-STATUS             PIC X(1).

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
       77 WS-FILE-STATUS               PIC X(2)      VALUE SPACES.
       77 WS-OPCAO                     PIC X(1)      VALUE 'S'.
       77 WS-RESPOSTA                  PIC X(1).
       77 WS-DATA-EMP                  PIC X(10).
       77 WS-DATA-DEV                  PIC X(10).
       77 WS-EMP-COD                   PIC 9(5)      VALUE 0.

       01 WS-USUARIO-DADOS.
           02 WS-COD-USUARIO           PIC 9(5).

       01 WS-LIVRO-DADOS.
           02 WS-COD-LIVRO             PIC 9(5).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM MENU.
           STOP RUN.

       MENU.
           PERFORM UNTIL WS-OPCAO = "N"
               DISPLAY "-------------------------------------"
               DISPLAY "      SISTEMA DE EMPRESTIMOS        "
               DISPLAY "-------------------------------------"
               DISPLAY "1 - Cadastrar Empréstimo"
               DISPLAY "2 - Realizar Devolução"
               DISPLAY "3 - Consultar Empréstimo"
               DISPLAY "4 - Voltar"
               DISPLAY "Escolha uma opção (1/2/3/4): "
               ACCEPT WS-OPCAO
               EVALUATE WS-OPCAO
                   WHEN '1'
                       PERFORM CADASTRAR-EMPRESTIMO
                   WHEN '2'
                       PERFORM REALIZAR-DEVOLUCAO
                   WHEN '3'
                       PERFORM CONSULTAR-EMPRESTIMO
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


       CADASTRAR-EMPRESTIMO.
           DISPLAY "DIGITE O CÓDIGO DO USUÁRIO: "
           ACCEPT WS-COD-USUARIO
           MOVE WS-COD-USUARIO TO USUARIO-COD

           PERFORM ABRIR-USUARIOS
           READ USUARIOS KEY IS USUARIO-COD
               INVALID KEY DISPLAY "USUÁRIO NÃO ENCONTRADO."
               CLOSE USUARIOS
               EXIT PARAGRAPH.
           CLOSE USUARIOS.

           DISPLAY "DIGITE O CÓDIGO DO LIVRO: "
           ACCEPT WS-COD-LIVRO
           MOVE WS-COD-LIVRO TO LIVRO-COD

           PERFORM ABRIR-LIVROS
           READ LIVROS KEY IS LIVRO-COD
               INVALID KEY DISPLAY "LIVRO NÃO ENCONTRADO."
               CLOSE LIVROS
               EXIT PARAGRAPH.

           IF LIVRO-STATUS = "E" THEN
               DISPLAY "LIVRO INDISPONÍVEL PARA EMPRÉSTIMO."
               CLOSE LIVROS
               EXIT PARAGRAPH
           END-IF.

           DISPLAY "DIGITE A DATA DE EMPRÉSTIMO (DD/MM/AAAA): "
           ACCEPT WS-DATA-EMP.

           DISPLAY "DIGITE A DATA DE DEVOLUÇÃO (DD/MM/AAAA): "
           ACCEPT WS-DATA-DEV.

           PERFORM GRAVAR-EMPRESTIMO.

           MOVE "E" TO LIVRO-STATUS
           REWRITE REG-LIVRO
           DISPLAY "EMPRÉSTIMO CADASTRADO COM SUCESSO!"

           CLOSE LIVROS.

       GRAVAR-EMPRESTIMO.
           PERFORM ACHAR-ULTIMO-EMP.

           PERFORM ABRIR-EMPRESTIMOS
           MOVE WS-EMP-COD        TO EMPRESTIMO-COD.
           MOVE WS-COD-USUARIO    TO EMPRESTIMO-USUARIO.
           MOVE WS-COD-LIVRO      TO EMPRESTIMO-LIVRO.
           MOVE WS-DATA-EMP       TO EMPRESTIMO-DATA-EMP.
           MOVE WS-DATA-DEV       TO EMPRESTIMO-DATA-DEV.
           MOVE 'E'               TO EMPRESTIMO-STATUS.
           MOVE '--/--/----'      TO EMPRESTIMO-DATA-ENTREGA.

           WRITE REG-EMPRESTIMO
               INVALID KEY DISPLAY "ERRO: REGISTRO JÁ EXISTE!"
               NOT INVALID KEY DISPLAY
               "EMPRÉSTIMO REGISTRADO COM SUCESSO!(COD." WS-EMP-COD")".

           CLOSE EMPRESTIMOS.

       ACHAR-ULTIMO-EMP.
           MOVE 0 TO WS-EMP-COD.
           MOVE "00" TO WS-FILE-STATUS.

           PERFORM ABRIR-EMPRESTIMOS

           PERFORM UNTIL WS-FILE-STATUS = "10"
               IF EMPRESTIMO-COD > WS-EMP-COD
                   MOVE EMPRESTIMO-COD TO WS-EMP-COD
               END-IF

               READ EMPRESTIMOS NEXT RECORD
                   AT END MOVE "10" TO WS-FILE-STATUS
           ADD 1 TO WS-EMP-COD
           END-PERFORM.

           CLOSE EMPRESTIMOS.


       REALIZAR-DEVOLUCAO.
           DISPLAY "DIGITE O CÓDIGO DO EMPRÉSTIMO: "
           ACCEPT WS-EMP-COD
           MOVE WS-EMP-COD TO EMPRESTIMO-COD

           PERFORM ABRIR-EMPRESTIMOS
           READ EMPRESTIMOS KEY IS EMPRESTIMO-COD
               INVALID KEY
                   DISPLAY "EMPRÉSTIMO NÃO ENCONTRADO."
                   CLOSE EMPRESTIMOS
                   EXIT PARAGRAPH.

           DISPLAY "DIGITE A DATA DE DEVOLUÇÃO (DD/MM/AAAA): "
           ACCEPT WS-DATA-DEV.

           MOVE WS-DATA-DEV TO EMPRESTIMO-DATA-ENTREGA
           MOVE "D" TO EMPRESTIMO-STATUS
           REWRITE REG-EMPRESTIMO
           DISPLAY "DATA DE DEVOLUÇÃO E STATUS ATUALIZADOS!"

           MOVE EMPRESTIMO-LIVRO TO WS-COD-LIVRO.
           CLOSE EMPRESTIMOS.

           PERFORM ATUALIZAR-LIVRO.

           DISPLAY "DEVOLUÇÃO REALIZADA COM SUCESSO!".


       ATUALIZAR-LIVRO.
           PERFORM ABRIR-LIVROS
           MOVE WS-COD-LIVRO TO LIVRO-COD

           READ LIVROS KEY IS LIVRO-COD
               INVALID KEY
                   DISPLAY "ERRO AO LOCALIZAR LIVRO NO SISTEMA."
                   CLOSE LIVROS
                   EXIT PARAGRAPH.

           MOVE "D" TO LIVRO-STATUS
           REWRITE REG-LIVRO
           DISPLAY "LIVRO ATUALIZADO PARA DISPONÍVEL!"

           CLOSE LIVROS.


       CONSULTAR-EMPRESTIMO.
           DISPLAY "DIGITE O CÓDIGO DO EMPRÉSTIMO PARA CONSULTA: "
           ACCEPT WS-EMP-COD
           MOVE WS-EMP-COD TO EMPRESTIMO-COD

           PERFORM ABRIR-EMPRESTIMOS
           READ EMPRESTIMOS KEY IS EMPRESTIMO-COD
               INVALID KEY
                   DISPLAY "EMPRÉSTIMO NÃO ENCONTRADO."
                   CLOSE EMPRESTIMOS
                   EXIT PARAGRAPH.

           DISPLAY "=========================================="
           DISPLAY "       DETALHES DO EMPRÉSTIMO            "
           DISPLAY "=========================================="
           DISPLAY "CÓDIGO DO EMPRÉSTIMO: " EMPRESTIMO-COD
           DISPLAY "CÓDIGO DO USUÁRIO:    " EMPRESTIMO-USUARIO
           DISPLAY "CÓDIGO DO LIVRO:      " EMPRESTIMO-LIVRO
           DISPLAY "DATA DO EMPRÉSTIMO:   " EMPRESTIMO-DATA-EMP
           DISPLAY "DATA DA DEVOLUÇÃO:    " EMPRESTIMO-DATA-DEV
           DISPLAY "DATA ENTREGUE:        " EMPRESTIMO-DATA-ENTREGA

           IF EMPRESTIMO-STATUS = "E" THEN
               DISPLAY "STATUS:               EM ANDAMENTO"
           ELSE IF EMPRESTIMO-STATUS = "D" THEN
               DISPLAY "STATUS:               DEVOLVIDO"
           ELSE
               DISPLAY "STATUS:               DESCONHECIDO"
           END-IF.

           DISPLAY "=========================================="

           CLOSE EMPRESTIMOS.
