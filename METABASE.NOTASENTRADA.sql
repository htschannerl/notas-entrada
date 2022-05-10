SELECT
        E440NFC.CODEMP COD_EMPRESA,
        E070EMP.NOMEMP NOME_EMPRESA,
        E440NFC.CODFIL COD_FILIAL,
        E070FIL.NOMFIL NOME_FILIAL,
        E440NFC.CODSNF SERIE_NF,
        E440NFC.CODFOR COD_FORNECEDOR,
        E095FOR.NOMFOR NOME_FORNECEDOR,
        E095FOR.APEFOR FANTASIA_FORNECEDOR,
        E440NFC.NUMNFC NOTA_FISCAL,
        E440NFC.DATEMI DATA_EMISSAO,
        E440NFC.DATENT DATA_ENTRADA,
        E440NFC.DATGER DATA_DIGITACAO,
        E440NFC.USUGER COD_USUARIO_DIGITACAO,
        USU1.NOMCOM    USUARIO_DIGITACAO,
        E440NFC.USUFEC COD_USUARIO_FECHAMENTO,
        USU2.NOMCOM    USUARIO_FECHAMENTO,
        E440NFC.SITNFC SITUACAO_NF,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.TNSPRO
            ELSE
                E440ISC.TNSSER
        END            TRANSACAO,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                TNS1.DESTNS
            ELSE
                TNS2.DESTNS
        END            DESC_TRANSACAO,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E075PRO.CODPRO
            ELSE
                E080SER.CODSER
        END            CODIGO_SER_PRO,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.CPLIPC
            ELSE
                E440ISC.CPLISC
        END            DESCRICAO_PRO_SER,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.EMPNFV
            ELSE
                E440ISC.EMPNFV
        END            EMPRESA_NOTA_VINCULADA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.FILNFV
            ELSE
                E440ISC.FILNFV
        END            FILIAL_NOTA_VINCULADA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.NUMNFV
            ELSE
                E440ISC.NUMNFV
        END            NOTA_VINCULADA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.SNFNFV
            ELSE
                E440ISC.SNFNFV
        END            SERIE_NOTA_VINCULADA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.SEQIPV
            ELSE
                E440ISC.SEQISV
        END            SEQ_ITEM_NOTA_VINCULADA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.SEQIPC
            ELSE
                E440ISC.SEQISC
        END            SEQ_ITEM,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.QTDREC
            ELSE
                E440ISC.QTDREC
        END            QTDE_REC,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.VLRBRU
            ELSE
                E440ISC.VLRBRU
        END            VALOR_BRUTO,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.VLRLIQ
            ELSE
                E440ISC.VLRLIQ
        END            VALOR_LIQUIDO,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.NUMOCP
            ELSE
                E440ISC.NUMOCP
        END            ORDEM_COMPRA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.SEQIPO
            ELSE
                E440ISC.SEQISO
        END            SEQ_ORDEM_COMPRA,
        CASE
            WHEN E440ISC.SEQISC IS NULL THEN
                E440IPC.FILOCP
            ELSE
                E440ISC.FILOCP
        END            FILIAL_ORDEM_COMPRA,
        (
            SELECT
                LISTAGG(E440PAR.VCTPAR,
                        ';')WITHIN GROUP(
                ORDER BY
                    E440PAR.VCTPAR
                )
            FROM
                SAPIENS.E440PAR
            WHERE
                    E440PAR.CODEMP = E440NFC.CODEMP
                AND E440PAR.CODFIL = E440NFC.CODFIL
                AND E440PAR.CODFOR = E440NFC.CODFOR
                AND E440PAR.NUMNFC = E440NFC.NUMNFC
                AND E440PAR.CODSNF = E440NFC.CODSNF
        )               VENCIMENTOS
    FROM
        SAPIENS.E440NFC
        LEFT OUTER JOIN SAPIENS.E440IPC ON(E440NFC.CODEMP = E440IPC.CODEMP
                                           AND E440NFC.CODFIL = E440IPC.CODFIL
                                           AND E440NFC.CODSNF = E440IPC.CODSNF
                                           AND E440NFC.CODFOR = E440IPC.CODFOR
                                           AND E440NFC.NUMNFC = E440IPC.NUMNFC)
        LEFT OUTER JOIN SAPIENS.E440ISC ON(E440NFC.CODEMP = E440ISC.CODEMP
                                           AND E440NFC.CODFIL = E440ISC.CODFIL
                                           AND E440NFC.CODSNF = E440ISC.CODSNF
                                           AND E440NFC.CODFOR = E440ISC.CODFOR
                                           AND E440NFC.NUMNFC = E440ISC.NUMNFC)
        INNER JOIN SAPIENS.E070EMP ON(E440NFC.CODEMP = E070EMP.CODEMP)
        INNER JOIN SAPIENS.E070FIL ON(E070FIL.CODEMP = E070EMP.CODEMP
                                      AND E440NFC.CODFIL = E070FIL.CODFIL)
        INNER JOIN SAPIENS.E095FOR ON(E440NFC.CODFOR = E095FOR.CODFOR)
        LEFT OUTER JOIN SAPIENS.E075PRO ON(E440IPC.CODEMP = E075PRO.CODEMP
                                           AND E440IPC.CODPRO = E075PRO.CODPRO)
        LEFT OUTER JOIN SAPIENS.E080SER ON(E440ISC.CODEMP = E080SER.CODEMP
                                           AND E440ISC.CODSER = E080SER.CODSER)
        LEFT OUTER JOIN SAPIENS.R910USU USU1 ON(USU1.CODENT = E440NFC.USUGER)
        LEFT OUTER JOIN SAPIENS.R910USU USU2 ON(USU2.CODENT = E440NFC.USUFEC)
        LEFT OUTER JOIN SAPIENS.E001TNS TNS1 ON(TNS1.CODEMP = E440NFC.CODEMP
                                                AND TNS1.CODTNS = E440IPC.TNSPRO)
        LEFT OUTER JOIN SAPIENS.E001TNS TNS2 ON(TNS2.CODEMP = E440NFC.CODEMP
                                                AND TNS1.CODTNS = E440ISC.TNSSER)