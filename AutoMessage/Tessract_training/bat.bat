echo fontyp 0 0 0 0 0 >font_properties
tesseract U.Normal.exp0.tif U.Normal.exp0 nobatch box.train
unicharset_extractor U.Normal.exp0.box
shapeclustering -F font_properties -U unicharset -O U.unicharset U.Normal.exp0.tr
mftraining -F font_properties -U unicharset -O U.unicharset U.Normal.exp0.tr
cntraining U.Normal.exp0.tr
rename normproto Normal.normproto
rename inttemp Normal.inttemp
rename pffmtable Normal.pffmtable 
rename unicharset Normal.unicharset
rename shapetable Normal.shapetable
combine_tessdata Normal.
copy normal.traineddata "C:\Program Files (x86)\Tesseract-OCR\tessdata" /y
pause