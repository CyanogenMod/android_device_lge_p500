/**
 * brcm_patchram_plus.c
 *
 * Copyright (C) 2009 Broadcom Corporation.
 * 
 * This software is licensed under the terms of the GNU General Public License,
 * version 2, as published by the Free Software Foundation (the "GPL"), and may
 * be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GPL for more details.
 * 
 * A copy of the GPL is available at http://www.broadcom.com/licenses/GPLv2.php
 * or by writing to the Free Software Foundation, Inc.,
 * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */


/*****************************************************************************
**                                                                           
**  Name:          brcm_patchram_plus.c
**
**  Description:   This program downloads a patchram files in the HCD format
**                 to Broadcom Bluetooth based silicon and combo chips and
**				   and other utility functions.
**
**                 It can be invoked from the command line in the form
**						<-d> to print a debug log
**						<--patchram patchram_file>
**						<--baudrate baud_rate>
**						<--bd_addr bd_address>
**						<--enable_lpm>
**						<--enable_hci>
**						uart_device_name
**
**                 For example:
**
**                 brcm_patchram_plus -d --patchram  \
**						BCM2045B2_002.002.011.0348.0349.hcd /dev/ttyHS0
**
**                 It will return 0 for success and a number greater than 0
**                 for any errors.
**
**                 For Android, this program invoked using a 
**                 "system(2)" call from the beginning of the bt_enable
**                 function inside the file 
**                 system/bluetooth/bluedroid/bluetooth.c.
**
**                 If the Android system property "ro.bt.bdaddr_path" is
**                 set, then the bd_addr will be read from this path.
**                 This is overridden by --bd_addr on the command line.
**  
******************************************************************************/

// TODO: Integrate BCM support into Bluez hciattach

#include <stdio.h>
#include <getopt.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdlib.h>

#ifdef ANDROID
#include <termios.h>
#else
#include <sys/termios.h>
#endif

#include <string.h>
#include <signal.h>

#include <cutils/properties.h>

#ifndef N_HCI
#define N_HCI	15
#endif

#define HCIUARTSETPROTO		_IOW('U', 200, int)
#define HCIUARTGETPROTO		_IOR('U', 201, int)
#define HCIUARTGETDEVICE	_IOR('U', 202, int)

#define HCI_UART_H4		0
#define HCI_UART_BCSP	1
#define HCI_UART_3WIRE	2
#define HCI_UART_H4DS	3
#define HCI_UART_LL		4


int uart_fd = -1;
int hcdfile_fd = -1;
int termios_baudrate = 0;
int bdaddr_flag = 0;
int enable_lpm = 0;
int enable_hci = 0;
int debug = 0;

/* TAG JB 03/11/2011 */
int hard_reset_bt = 0;
#define RFKILL_WAIT 200000
/* End of tag */

struct termios termios;
unsigned char buffer[1024];

unsigned char hci_reset[] = { 0x01, 0x03, 0x0c, 0x00 };

unsigned char hci_download_minidriver[] = { 0x01, 0x2e, 0xfc, 0x00 };

unsigned char hci_update_baud_rate[] = { 0x01, 0x18, 0xfc, 0x06, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00 };

unsigned char hci_write_bd_addr[] = { 0x01, 0x01, 0xfc, 0x06, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

/* google code, Broadcom Bluetooth Feature */
/* Message content :
 * 0x01 -> header
 * 0x27 -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x0c -> size of the content (starting from the byte after this one. set to 0xA in winmo)
 * 0xXX -> SleepModeMode (0 = no sleep, 1 = uart, 3 = USB, 5 = USB with HOST_WAKE, 6 = SDIO)
 * 0xXX -> SleepModeSuspendTimeout_Host (formula to reverse)
 * 0xXX -> SleepModeSuspendTimeout_HC (same formula as above)
 * 0xXX -> SleepModeBT_WAKEActiveHigh
 * 0xXX -> SleepModeHOST_WAKEActiveHigh
 * 0x01 -> Fixed parameter ?
 * 0x01 -> Fixed parameter ?
 * 0x00 -> Fixed parameter ?
 * 0xXX -> SleepModeUSBSleepOnSuspend
 * 0xXX -> SleepModeUSBResumeTimeout
 * 0xXX -> Not used in winmo
 * 0xXX -> Not used in winmo
 */
/*
unsigned char hci_write_sleep_mode[] = { 0x01, 0x27, 0xfc, 0x0c, 
	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00,
	0x00, 0x00 };
*/
unsigned char hci_write_sleep_mode[] = { 0x01, 0x27, 0xfc, 0x0a, 
	0x01, 0x00, 0x0a, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00};

/* TAG JB 03/11/2011 */
unsigned char hci_write_high_speed_uart_msg[] = { 0x01, 0x45, 0xfc, 0x01, 
	0x01};

/* PCM settings msg 1
 * Message content :
 * 0x01 -> header
 * 0x1c -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x05 -> size of the content (starting from the byte after this one)
 * 0xXX -> PCMRouting
 * 0xXX -> PCMInCallBitclock
 * 0xXX -> PCMShortFrameSync
 * 0xXX -> PCMSyncMode
 * 0xXX -> PCMClockMode
 */
unsigned char hci_write_pcm_setting_1[] = { 0x01, 0x1c, 0xfc, 0x05, 
	0x00, 0x04, 0x00, 0x00, 0x00};

/* PCM settings msg 2
 * Message content :
 * 0x01 -> header
 * 0x1e -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x05 -> size of the content (starting from the byte after this one)
 * 0xXX -> PCMLSBFirst
 * 0xXX -> PCMFillValue  ( might be swapped with PCMFillNum in some case)
 * 0xXX -> PCMFillMethod
 * 0xXX -> PCMFillNum    ( might be swapped with PCMFillValue in some case)
 * 0xXX -> PCMRightJustify
 */
unsigned char hci_write_pcm_setting_2[] = { 0x01, 0x1e, 0xfc, 0x05, 
	0x00, 0x03, 0x02, 0x00, 0x00};

/* SCO settings 
 * Not found in registry, defaulted to 0
 *
 * Message content :
 * 0x01 -> header
 * 0x22 -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x01 -> size of the content (starting from the byte after this one)
 * 0xXX -> SCOTimeSlot
 */
unsigned char hci_write_sco_setting[] = { 0x01, 0x22, 0xfc, 0x01, 
	0x00};

/* Comfort noise settings 
 * Not found in registry, defaulted to 0
 *
 * Message content :
 * 0x01 -> header
 * 0x20 -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x03 -> size of the content (starting from the byte after this one)
 * 0xXX -> ComfortNoiseGain
 * 0xXX -> ComfortNoiseRepeatLastSampleCount
 * 0xXX -> ComfortNoiseGain
 */
unsigned char hci_write_comfort_noise_setting[] = { 0x01, 0x20, 0xfc, 0x03, 
	0x00, 0x00, 0x00};

/* Coexistence settings 
 * Message content :
 * 0x01 -> header
 * 0x41 -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x08 -> size of the content (starting from the byte after this one)
 * 0xXX -> CollaborationSolution | (CollaborationArchitecture<<7)
 * 0xXX -> CollaborationPriorities & 0xFF
 * 0xXX -> (CollaborationPriorities >> 8) & 0xFF
 * 0xXX -> (CollaborationPriorities >> 16) & 0xFF
 * 0xXX -> (CollaborationPriorities >> 24) & 0xFF
 * 0xXX -> Fixed value ?
 * 0xXX -> Fixed value ?
 * 0xXX -> Fixed value ?
 */
unsigned char hci_write_coexistence_setting[] = { 0x01, 0x41, 0xfc, 0x08, 
	0x83, 0xb0, 0xbd, 0x7f, 0xcb, 0x00, 0x00, 0x0A};

/* Supported features settings :
 * Not found in registry, defaulted to LocalSupportedFeatures1 = 0xFE8DFFFF
 * and LocalSupportedFeatures2 = 0x8000F99B
 *
 * Message content :
 * 0x01 -> header
 * 0x0b -> msg_id
 * 0xfc -> ?? msg_type ?
 * 0x08 -> size of the content (starting from the byte after this one)
 * 0xXX -> LocalSupportedFeatures1 & 0xFF
 * 0xXX -> (LocalSupportedFeatures1 >> 8) & 0xFF
 * 0xXX -> (LocalSupportedFeatures1 >> 16) & 0xFF
 * 0xXX -> (LocalSupportedFeatures1 >> 24) & 0xFF
 * 0xXX -> LocalSupportedFeatures2 & 0xFF
 * 0xXX -> (LocalSupportedFeatures2 >> 8) & 0xFF
 * 0xXX -> (LocalSupportedFeatures2 >> 16) & 0xFF
 * 0xXX -> (LocalSupportedFeatures2 >> 24) & 0xFF
 */
unsigned char hci_write_supported_features_setting[] = { 0x01, 0x0b, 0xfc, 0x08, 
	0xff, 0xff, 0x8d, 0xfe, 0x9b, 0xf9, 0x00, 0x80};

/* End of TAG */

int
parse_patchram(char *optarg)
{
	char *p;

	if (!(p = strrchr(optarg, '.'))) {
		fprintf(stderr, "file %s not an HCD file\n", optarg);
		exit(3);
	}

	p++;

	if (strcasecmp("hcd", p) != 0) {
		fprintf(stderr, "file %s not an HCD file\n", optarg);
		exit(4);
	}

	if ((hcdfile_fd = open(optarg, O_RDONLY)) == -1) {
		fprintf(stderr, "file %s could not be opened, error %d\n", optarg, errno);
		exit(5);
	}

	return(0);
}

void 
BRCM_encode_baud_rate(uint baud_rate, unsigned char *encoded_baud)
{
	if(baud_rate == 0 || encoded_baud == NULL) {
		fprintf(stderr, "Baudrate not supported!");
		return; 
	}

	encoded_baud[3] = (unsigned char)(baud_rate >> 24);
	encoded_baud[2] = (unsigned char)(baud_rate >> 16);
	encoded_baud[1] = (unsigned char)(baud_rate >> 8);
	encoded_baud[0] = (unsigned char)(baud_rate & 0xFF);
}

typedef struct {
	int baud_rate;
	int termios_value;
} tBaudRates;

tBaudRates baud_rates[] = {
	{ 115200, B115200 },
	{ 230400, B230400 },
	{ 460800, B460800 },
	{ 500000, B500000 },
	{ 576000, B576000 },
	{ 921600, B921600 },
	{ 1000000, B1000000 },
	{ 1152000, B1152000 },
	{ 1500000, B1500000 },
	{ 2000000, B2000000 },
	{ 2500000, B2500000 },
	{ 3000000, B3000000 },
#ifndef __CYGWIN__
	{ 3500000, B3500000 },
	{ 4000000, B4000000 }
#endif
};

int
validate_baudrate(int baud_rate, int *value)
{
	unsigned int i;

	for (i = 0; i < (sizeof(baud_rates) / sizeof(tBaudRates)); i++) {
		if (baud_rates[i].baud_rate == baud_rate) {
			*value = baud_rates[i].termios_value;
			return(1);
		}
	}

	return(0);
}

int
parse_baudrate(char *optarg)
{
	int baudrate = atoi(optarg);

	if (validate_baudrate(baudrate, &termios_baudrate)) {
		BRCM_encode_baud_rate(baudrate, &hci_update_baud_rate[6]);
	}

	return(0);
}

int
parse_bdaddr(char *optarg)
{
	int bd_addr[6];
	int i;

	sscanf(optarg, "%02X:%02X:%02X:%02X:%02X:%02X",
		&bd_addr[5], &bd_addr[4], &bd_addr[3],
		&bd_addr[2], &bd_addr[1], &bd_addr[0]);

	for (i = 0; i < 6; i++) {
		hci_write_bd_addr[4 + i] = bd_addr[i];
	}

	bdaddr_flag = 1;	

	return(0);
}

int
parse_enable_lpm(char *optarg)
{
	enable_lpm = 1;
	return(0);
}

int
parse_enable_hci(char *optarg)
{
	enable_hci = 1;
	return(0);
}

int
parse_cmd_line(int argc, char **argv)
{
	int c;
	int digit_optind = 0;

	typedef int (*PFI)();

	PFI parse_param[] = { parse_patchram, parse_baudrate,
		parse_bdaddr, parse_enable_lpm, parse_enable_hci };

    while (1)
    {
    	int this_option_optind = optind ? optind : 1;
        int option_index = 0;

       	static struct option long_options[] = {
         {"patchram", 1, 0, 0},
         {"baudrate", 1, 0, 0},
         {"bd_addr", 1, 0, 0},
         {"enable_lpm", 0, 0, 0},
         {"enable_hci", 0, 0, 0},
         {0, 0, 0, 0}
       	};

/* TAG JB 02/09/2011 (added 'r') */
        c = getopt_long_only (argc, argv, "dr", long_options, &option_index);
/* End of TAG */

       	if (c == -1) {
      		break;
		}

       	switch (c) {
        case 0:
        	printf ("option %s", long_options[option_index].name);

        	if (optarg) {
           		printf (" with arg %s", optarg);
			}

           	printf ("\n");

			(*parse_param[option_index])(optarg);
		break;

		case 'd':
			debug = 1;
		break;

/* TAG JB 02/09/2011 */
        case 'r':
            hard_reset_bt = 1;
        break;
/* end of TAG */

        case '?':
			//nobreak
        default:

			printf("Usage %s:\n", argv[0]);
			printf("\t<-d> to print a debug log\n");
			printf("\t<--patchram patchram_file>\n");
			printf("\t<--baudrate baud_rate>\n");
			printf("\t<--bd_addr bd_address>\n");
			printf("\t<--enable_lpm\n");
			printf("\t<--enable_hci\n");
			printf("\tuart_device_name\n");
           	break;

        }
	}

   	if (optind < argc) {
       	if (optind < argc) {
       		printf ("%s ", argv[optind]);

			if ((uart_fd = open(argv[optind], O_RDWR | O_NOCTTY)) == -1) {
				fprintf(stderr, "port %s could not be opened, error %d\n", argv[2], errno);
			}
		}

       	printf ("\n");
    }

	return(0);
}

void
init_uart()
{
	tcflush(uart_fd, TCIOFLUSH);
	tcgetattr(uart_fd, &termios);

#ifndef __CYGWIN__
	cfmakeraw(&termios);
#else
	termios.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP
                | INLCR | IGNCR | ICRNL | IXON);
	termios.c_oflag &= ~OPOST;
	termios.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
	termios.c_cflag &= ~(CSIZE | PARENB);
	termios.c_cflag |= CS8;
#endif

	termios.c_cflag |= CRTSCTS;
	tcsetattr(uart_fd, TCSANOW, &termios);
	tcflush(uart_fd, TCIOFLUSH);
	tcsetattr(uart_fd, TCSANOW, &termios);
	tcflush(uart_fd, TCIOFLUSH);
	tcflush(uart_fd, TCIOFLUSH);
	cfsetospeed(&termios, B115200);
	cfsetispeed(&termios, B115200);
	tcsetattr(uart_fd, TCSANOW, &termios);
}

void
dump(unsigned char *out, int len)
{
	int i;

	for (i = 0; i < len; i++) {
		if (i && !(i % 16)) {
			fprintf(stderr, "\n");
		}

		fprintf(stderr, "%02x ", out[i]);
	}

	fprintf(stderr, "\n");
}

void
read_event(int fd, unsigned char *buffer)
{
	int i = 0;
	int len = 3;
	int count;

	while ((count = read(fd, &buffer[i], len)) < len) {
		i += count;
		len -= count;
	}

	i += count;
	len = buffer[2];

	while ((count = read(fd, &buffer[i], len)) < len) {
		i += count;
		len -= count;
	}

	if (debug) {
		count += i;

		fprintf(stderr, "received %d\n", count);
		dump(buffer, count);
	}
}

void
hci_send_cmd(unsigned char *buf, int len)
{
	if (debug) {
		fprintf(stderr, "writing\n");
		dump(buf, len);
	}

	write(uart_fd, buf, len);
}

void
expired(int sig)
{
	hci_send_cmd(hci_reset, sizeof(hci_reset));
	alarm(4);
}

void
proc_reset()
{
	signal(SIGALRM, expired);


	hci_send_cmd(hci_reset, sizeof(hci_reset));

	alarm(4);

	read_event(uart_fd, buffer);

	alarm(0);
}

void
proc_patchram()
{
	int len;

	hci_send_cmd(hci_download_minidriver, sizeof(hci_download_minidriver));

	read_event(uart_fd, buffer);

	read(uart_fd, &buffer[0], 2);

	usleep(50000);

	while (read(hcdfile_fd, &buffer[1], 3)) {
		buffer[0] = 0x01;

		len = buffer[3];

		read(hcdfile_fd, &buffer[4], len);

		hci_send_cmd(buffer, len + 4);

		read_event(uart_fd, buffer);
	}

	proc_reset();
}

/* TAG JB 03/11/2011 : 
 * + Enable High speed uart on BCM module (required for baudrate above 3000000 bps)
 * + Specific device settings (based on winmo values, might be retrieved from a configuration file)
 */
void
proc_high_speed_msg()
{
	hci_send_cmd(hci_write_high_speed_uart_msg, sizeof(hci_write_high_speed_uart_msg));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting hs msg\n");
	}
}

void
proc_pcm_settings()
{
	hci_send_cmd(hci_write_pcm_setting_1, sizeof(hci_write_pcm_setting_1));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting pcm settings part 1\n");
	}

	hci_send_cmd(hci_write_pcm_setting_2, sizeof(hci_write_pcm_setting_2));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting pcm settings part 2\n");
	}
}

void
proc_sco_setting()
{
	hci_send_cmd(hci_write_sco_setting, sizeof(hci_write_sco_setting));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting sco settings\n");
	}
}

void
proc_comfort_noise_setting()
{
	hci_send_cmd(hci_write_comfort_noise_setting, sizeof(hci_write_comfort_noise_setting));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting comfort noise settings\n");
	}
}

void
proc_coexistence_setting()
{
	hci_send_cmd(hci_write_coexistence_setting, sizeof(hci_write_coexistence_setting));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting coexistence settings\n");
	}
}

void
proc_supported_features_setting()
{
	hci_send_cmd(hci_write_supported_features_setting, sizeof(hci_write_supported_features_setting));

	read_event(uart_fd, buffer);

	if (debug) {
		fprintf(stderr, "Done setting supported features settings\n");
	}
}
/* End of tag */

void
proc_baudrate()
{
/* TAG JB 03/11/2011 */
    if ( termios_baudrate >= B3000000 ) {
        proc_high_speed_msg();
    }
/* End of TAG */

	hci_send_cmd(hci_update_baud_rate, sizeof(hci_update_baud_rate));

	read_event(uart_fd, buffer);

	cfsetospeed(&termios, termios_baudrate);
	cfsetispeed(&termios, termios_baudrate);
	tcsetattr(uart_fd, TCSANOW, &termios);

	if (debug) {
		fprintf(stderr, "Done setting baudrate\n");
	}
}

void
proc_bdaddr()
{
	hci_send_cmd(hci_write_bd_addr, sizeof(hci_write_bd_addr));

	read_event(uart_fd, buffer);
}

void
proc_enable_lpm()
{
	hci_send_cmd(hci_write_sleep_mode, sizeof(hci_write_sleep_mode));

	read_event(uart_fd, buffer);
}

void
proc_enable_hci()
{
	int i = N_HCI;
	int proto = HCI_UART_H4;
	if (ioctl(uart_fd, TIOCSETD, &i) < 0) {
		fprintf(stderr, "Can't set line discipline\n");
		return;
	}

	if (ioctl(uart_fd, HCIUARTSETPROTO, proto) < 0) {
		fprintf(stderr, "Can't set hci protocol\n");
		return;
	}
	fprintf(stderr, "Done setting line discpline\n");
	return;
}

/* TAG JB 03/11/2011 : Ensure proper reset of BCM moduel via power down/up sequence */
void
reset_bt()
{
    FILE* btfd;
    char *rfkill = "/sys/class/rfkill/rfkill0/state";
    char *disable = "0";
    char *enable = "1";
    struct timespec req = {0};

    req.tv_sec = 0;
    req.tv_nsec = RFKILL_WAIT * 1000L;

    btfd = fopen(rfkill, "w");
    if (btfd == 0 ) {
        fprintf(stderr, "open(%s) failed: %s (%d)", rfkill, strerror(errno),
            errno);
        return;
    }
    fputs(disable, btfd);
    fclose(btfd);
    nanosleep(&req, (struct timespec *)NULL);

    btfd = fopen(rfkill, "w");
    if (btfd == 0 ) {
        fprintf(stderr, "open(%s) failed: %s (%d)", rfkill, strerror(errno),
            errno);
        return;
    }
    fputs(enable, btfd);
    fclose(btfd);
    nanosleep(&req, (struct timespec *)NULL);
}
/* End of TAG */

void
read_default_bdaddr()
{
	int sz;
	int fd;
/* TAG JB 03/11/2011 : Read BDADDR from rfkill (who reads bdaddr from smem)
 * Might be removed if we can use the ro.bt.bdaddr_path property instead. More clean
 */
	char path[PROPERTY_VALUE_MAX] = "/sys/module/board_htcraphael_rfkill/parameters/bdaddr";
/* End of TAG */
	char bdaddr[18];

	property_get("ro.bt.bdaddr_path", path, "");
	if (path[0] == 0)
		return;

	fd = open(path, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "open(%s) failed: %s (%d)", path, strerror(errno),
				errno);
		return;
	}

	sz = read(fd, bdaddr, sizeof(bdaddr));
	if (sz < 0) {
		fprintf(stderr, "read(%s) failed: %s (%d)", path, strerror(errno),
				errno);
		close(fd);
		return;
	} else if (sz != sizeof(bdaddr)) {
		fprintf(stderr, "read(%s) unexpected size %d", path, sz);
		close(fd);
		return;
	}

	printf("Read default bdaddr of %s\n", bdaddr);
	parse_bdaddr(bdaddr);
}

int
main (int argc, char **argv)
{
	read_default_bdaddr();

	parse_cmd_line(argc, argv);

	if (uart_fd < 0) {
		exit(1);
	}

/* TAG JB 03/11/2011 : Ensure proper reset of the module */
    if (hard_reset_bt) {
        printf("Hard Resetting BCM module\n");
        reset_bt();
    }
/* End of TAG */

	init_uart();

	proc_reset();

	if (hcdfile_fd > 0) {
		proc_patchram();
	}

	if (termios_baudrate) {
		proc_baudrate();
	}


	if (bdaddr_flag) {
		proc_bdaddr();
	}

	if (enable_lpm) {
		proc_enable_lpm();
	}

/* TAG JB 03/11/2011 : Specific device settings */
    proc_pcm_settings();
    proc_sco_setting();
    //proc_comfort_noise_setting();
    //proc_coexistence_setting();
    //proc_supported_features_setting();
/* End of TAG */

	if (enable_hci) {
		proc_enable_hci();
	}

	if (enable_hci) {
		while (1) {
			sleep(UINT_MAX);
		}
	}

	exit(0);
}
