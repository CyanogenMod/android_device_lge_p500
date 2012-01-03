ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),p500)
include $(call first-makefiles-under,$(call my-dir))
endif
