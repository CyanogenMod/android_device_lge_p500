#include <fcntl.h>
#include <string.h>
#include <cutils/properties.h>
#include <cutils/log.h>
#include <unistd.h>
#include <errno.h>

#define LOG_TAG "gadget_id"
#define PRODUCT_ID_PATH "/sys/module/g_android/parameters/product_id"
#define TMP_FILE "/data/gadget.pid"
#define UMS "61C5\n"
#define ADB "618E\n"
#define NET "61A1\n"

/* Read properties and set product ID to kernel */

int main() {
    int fd;
    fd = open(TMP_FILE, O_CREAT|O_EXCL|O_RDWR, 00600|00060|00006);
    if (fd < 0) {
        LOGW("Another instance of gadget_id running (%s). Stopping.", strerror(errno));
        return -3;
    }
    close(fd);
    fd = -1;
    sleep(2);
    char prop[2];
    char new_id[]=ADB;

    property_get("net.usb_tethering", prop, "0");
    if(prop[0] == '1') {
        LOGW(stderr, "Usb tethering active, rejecting ID change");
        strncpy(new_id, NET, 5);
        LOGI("Changing ID to NET: %s", NET);
        goto write;
    }
    property_get("persist.service.adb.enable", prop, "1");
    if(prop[0] == '1') {
        strncpy(new_id, ADB, 5);
        LOGI("Changing ID to ADB: %s", ADB);
        goto write;
    }
    strncpy(new_id, UMS, 5);
    LOGI("Changing ID to UMS: %s", UMS);

write:
    fd = open(PRODUCT_ID_PATH, O_RDWR);

    if(fd < 0) {
        LOGE(stderr, "open(%s) failed: %s", PRODUCT_ID_PATH, strerror(errno));
        goto end;
    }
    write(fd, new_id, 5);
    close(fd);

end:
    if(remove(TMP_FILE) != 0) {
        LOGE("Can't remove %s: %s", TMP_FILE, strerror(errno));
    }
    return 0;
}
