#include <fcntl.h>
#include <string.h>
#include <cutils/properties.h>
#include <cutils/log.h>

#define LOG_TAG "bdaddr"
#define BDADDR_PATH "/data/bdaddr"

/* Read bluetooth MAC from service.brcm.bt.mac,
 * write it to BDADDR_PATH, and set ro.bt.bdaddr_path to BDADDR_PATH */

int main() {
    char tmpbdaddr[13];
    char bdaddr[18];
    int count;
    property_get("service.brcm.bt.mac", tmpbdaddr, "");
	if (strlen(tmpbdaddr) == 12) {
    	count = sprintf(bdaddr, "%02.2s:%02.2s:%02.2s:%02.2s:%02.2s:%02.2s\0",
    	                tmpbdaddr,tmpbdaddr+2,tmpbdaddr+4,tmpbdaddr+6,tmpbdaddr+8,tmpbdaddr+10);
	} else {
	    LOGE("Can't read btaddr from service.brcm.bt.mac.\n");
	    return -1;
	}
	int fd;
	fd = open(BDADDR_PATH, O_WRONLY|O_CREAT|O_TRUNC, 00600|00060|00006);
	if(fd < 0) {
	    fprintf(stderr, "open(%s) failed\n", BDADDR_PATH);
		LOGE("Can't open %s\n", BDADDR_PATH);
		return -2;
	}
	write(fd, bdaddr, 18);
	close(fd);
	property_set("ro.bt.bdaddr_path", BDADDR_PATH);
	return 0;
}
