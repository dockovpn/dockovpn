#!/bin/bash

FILE_NAME='client.zip'
FILE_PATH=client/$FILE_NAME

 { echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: application/zip\r\n\Content-Disposition: attachment; filename=\"client.zip\"r\n\Accept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080