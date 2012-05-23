/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cutils/properties.h>
#include <termios.h>
#include <stdio.h>
#include <fcntl.h>

/* Read original sw version from modem and apply it as baseband */

int main() {

    struct termios  ios;
    char sync_buf[256];
    char *readbuf = sync_buf;
    char *result;
    int old_flags;
    int retry_left = 5;

retry:
  {
    --retry_left;
    int fd = open("/dev/smd7", O_RDWR);
    int read_bytes = 0;

    if (fd <= 0) {
        return 1;
    }
    tcgetattr(fd, &ios);
    ios.c_lflag = 0;
    tcsetattr(fd, TCSANOW, &ios);
    old_flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, old_flags | O_NONBLOCK);
    write(fd,"AT%SWOV\r", 8);
    sleep(1);

    read_bytes = read(fd, sync_buf, sizeof(sync_buf));
    close(fd);

    if (-1 == read_bytes && 0 < retry_left) { // If O_NONBLOCK is set, read() shall return "-1" when the modem was busy.
        sleep(1);
        goto retry;
    }
    else if (read_bytes > 0) { // The modem is not busy
        /* Skip first echoed line */
        while (read_bytes && *readbuf != '\n' && *readbuf !='\0') {
            readbuf++;
            read_bytes--;
        }
        /* Nothing left */
        if (!read_bytes) { return 2; }

        /* Skip line break */
        readbuf++;
        read_bytes--;

        /* Nothing left */
        if (!read_bytes) { return 2; }

        result = readbuf;

        while (*readbuf != '\r' && *readbuf != '\n' && *readbuf !='\0' && read_bytes) {
            readbuf++;
            read_bytes--;
        }
        *readbuf='\0';

        /* Do we have something ? */
        if (strlen(result) > 2) {
            /* Chop off first and last chars */
            *result++;
            *--readbuf='\0';

            /* The baseband string begins with LGP */
            if (0 == strncmp(result, "LGP", 3)) {
                property_set("gsm.version.baseband", result);
                //printf("%s\n",result);
                return 0;
            }
            else if (0 < retry_left) {
                sleep(1);
                goto retry;
            }
        }
     }
  }

  // We tried many times but no luck. Can't set baseband string, modem is always busy.
  return 3;
}

