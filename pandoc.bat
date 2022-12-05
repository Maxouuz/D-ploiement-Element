@ECHO OFF

FOR /F "tokens=1 delims=." %%a in ("%1") do set file=%%a

pandoc -s -V block-headings --toc -N^
    -o %file%.pdf %file%.md^
    --metadata title= %2" - S3.03"^
    --metadata subtitle="HERSSENS Alexandre et STIEVENARD Maxence"
PAUSE