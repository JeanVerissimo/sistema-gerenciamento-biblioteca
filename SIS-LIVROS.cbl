       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SIS-LIVROS.
       AUTHOR.        JEAN CARLOS.
       DATE-WRITTEN.  12/02/2025.
       DATE-COMPILED. 15/02/2025.
       SECURITY.      APENAS O AUTOR PODE MODIFICA-LO.
      *REMARKS.       Realiza cadastro de novos livros,
      *               pesquisa e apaga registros existentes.

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

       DATA DIVISION.
       FILE SECTION.
       FD LIVROS.
       01 REG-LIVRO.
           02 LIVRO-COD         PIC 9(5).
           02 LIVRO-TITULO      PIC X(50).
           02 LIVRO-AUTOR       PIC X(30).
           02 LIVRO-ANO         PIC 9(4).
           02 LIVRO-STATUS      PIC X(1).

       WORKING-STORAGE SECTION.
       77 WS-FILE-STATUS        PIC X(2)       VALUE SPACES.
       77 WS-OPCAO              PIC X(1)       VALUE 'S'.
       77 WS-RESPOSTA           PIC X(1).
       01 WS-LIVRO-DADOS.
           02 WS-COD            PIC 9(5).
           02 WS-TITULO         PIC X(50).
           02 WS-AUTOR          PIC X(30).
           02 WS-ANO            PIC 9(4).
           02 WS-STATUS         PIC X(1).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM MENU.
           STOP RUN.

       MENU.
           PERFORM UNTIL WS-OPCAO = "N"
               DISPLAY "-------------------------------------"
               DISPLAY "  SISTEMA DE GERENCIAMENTO DE LIVROS"
               DISPLAY "-------------------------------------"
               DISPLAY "1 - Cadastrar Livro"
               DISPLAY "2 - Pesquisar Livro"
               DISPLAY "3 - Deletar Livro"
               DISPLAY "4 - Voltar"
               DISPLAY "Escolha uma opção (1/2/3/4): "
               ACCEPT WS-OPCAO

               EVALUATE WS-OPCAO
                   WHEN '1'
                       PERFORM CADASTRAR-LIVRO
                   WHEN '2'
                       PERFORM PESQUISAR-LIVRO
                   WHEN '3'
                       PERFORM DELETAR-LIVRO
                   WHEN '4'
                       MOVE "N" TO WS-OPCAO
                   WHEN OTHER
                       DISPLAY "OPÇÃO INVÁLIDA!"
               END-EVALUATE
           END-PERFORM.

       CADASTRAR-LIVRO.
           PERFORM ABRIR-LIVROS.
           PERFORM SOLICITAR-DADOS-LIVRO.
           PERFORM GRAVAR-LIVRO.
           CLOSE LIVROS.

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

       SOLICITAR-DADOS-LIVRO.
           INITIALIZE WS-LIVRO-DADOS

           PERFORM UNTIL WS-COD > 0
               DISPLAY "DIGITE O CÓDIGO DO LIVRO (5 DIGITOS): "
               ACCEPT WS-COD
           END-PERFORM.

           PERFORM UNTIL WS-TITULO NOT = SPACES
               DISPLAY "DIGITE O TÍTULO DO LIVRO: "
               ACCEPT WS-TITULO
           END-PERFORM.

           PERFORM UNTIL WS-AUTOR NOT = SPACES
               DISPLAY "DIGITE O AUTOR DO LIVRO: "
               ACCEPT WS-AUTOR
           END-PERFORM.

           PERFORM UNTIL WS-ANO > 0
               DISPLAY "DIGITE O ANO DE PUBLICAÇÃO (4 DIGITOS): "
               ACCEPT WS-ANO
           END-PERFORM.

           PERFORM UNTIL WS-STATUS = "D" OR WS-STATUS = "E"
               DISPLAY "DIGITE O STATUS (D=Disponível / E=Emprestado): "
               ACCEPT WS-STATUS
               MOVE FUNCTION UPPER-CASE(WS-STATUS) TO WS-STATUS
           END-PERFORM.

       GRAVAR-LIVRO.
           MOVE WS-COD    TO LIVRO-COD
           MOVE WS-TITULO TO LIVRO-TITULO
           MOVE WS-AUTOR  TO LIVRO-AUTOR
           MOVE WS-ANO    TO LIVRO-ANO
           MOVE WS-STATUS TO LIVRO-STATUS

           WRITE REG-LIVRO
           INVALID KEY DISPLAY "ERRO: CÓDIGO JÁ EXISTE!"
           NOT INVALID KEY DISPLAY "LIVRO CADASTRADO COM SUCESSO!".

       PESQUISAR-LIVRO.
           DISPLAY "DIGITE O CÓDIGO DO LIVRO PARA PESQUISAR: "
           ACCEPT WS-COD
           MOVE WS-COD TO LIVRO-COD

           PERFORM ABRIR-LIVROS
           READ LIVROS KEY IS LIVRO-COD
               INVALID KEY
                   DISPLAY "LIVRO NÃO ENCONTRADO."
                   CLOSE LIVROS
                   EXIT PARAGRAPH
               NOT INVALID KEY DISPLAY "DADOS DO LIVRO:"
                   DISPLAY "TÍTULO:  " LIVRO-TITULO
                   DISPLAY "AUTOR:   " LIVRO-AUTOR
                   DISPLAY "ANO:     " LIVRO-ANO
                   DISPLAY "STATUS:  " LIVRO-STATUS
           CLOSE LIVROS.

       DELETAR-LIVRO.
           DISPLAY "DIGITE O CÓDIGO DO LIVRO PARA DELETAR: "
           ACCEPT WS-COD
           MOVE WS-COD TO LIVRO-COD

           PERFORM ABRIR-LIVROS
           READ LIVROS KEY IS LIVRO-COD
               INVALID KEY
                   DISPLAY "LIVRO NÃO ENCONTRADO."
                   CLOSE LIVROS
                   EXIT PARAGRAPH
               NOT INVALID KEY
                   DISPLAY "DADOS DO LIVRO:"
                   DISPLAY "TÍTULO: " LIVRO-TITULO
                   DISPLAY "AUTOR:  " LIVRO-AUTOR
                   DISPLAY "ANO:    " LIVRO-ANO
                   DISPLAY "STATUS: " LIVRO-STATUS
                   DISPLAY "DESEJA EXCLUIR ESSE LIVRO? (S/N)"
                   ACCEPT WS-RESPOSTA
                   MOVE FUNCTION UPPER-CASE(WS-RESPOSTA) TO WS-RESPOSTA

                   IF WS-RESPOSTA = "S" THEN
                       DELETE LIVROS
                       DISPLAY "LIVRO DELETADO COM SUCESSO!"
                   ELSE
                       DISPLAY "EXCLUSÃO CANCELADA."
                   END-IF
           CLOSE LIVROS.
