ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),thunderg)
include $(call first-makefiles-under,$(call my-dir))
endif
