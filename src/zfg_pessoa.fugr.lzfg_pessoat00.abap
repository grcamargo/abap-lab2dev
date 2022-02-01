*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPESSOA.........................................*
DATA:  BEGIN OF STATUS_ZPESSOA                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPESSOA                       .
CONTROLS: TCTRL_ZPESSOA
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPESSOA                       .
TABLES: ZPESSOA                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
