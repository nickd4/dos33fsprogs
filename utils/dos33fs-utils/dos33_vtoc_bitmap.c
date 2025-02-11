#include <stdio.h>

#include "dos33.h"

/* FIXME: this code assumes that we have 16 sectors pretty much everywhere */


static int ones_lookup[16]={
	/* 0x0 = 0000 */ 0,
	/* 0x1 = 0001 */ 1,
	/* 0x2 = 0010 */ 1,
	/* 0x3 = 0011 */ 2,
	/* 0x4 = 0100 */ 1,
	/* 0x5 = 0101 */ 2,
	/* 0x6 = 0110 */ 2,
	/* 0x7 = 0111 */ 3,
	/* 0x8 = 1000 */ 1,
	/* 0x9 = 1001 */ 2,
	/* 0xA = 1010 */ 2,
	/* 0xB = 1011 */ 3,
	/* 0xC = 1100 */ 2,
	/* 0xD = 1101 */ 3,
	/* 0xE = 1110 */ 3,
	/* 0xF = 1111 */ 4,
};

	/* could be replaced by "find leading 1" instruction */
	/* if available                                      */
static int find_first_one(unsigned char byte) {

	int i=0;

	if (byte==0) return -1;

	while((byte & (0x1<<i))==0) {
		i++;
	}
	return i;
}


/* Return how many bytes free in the filesystem */
/* by reading the VTOC_FREE_BITMAP */
int dos33_vtoc_free_space(unsigned char *vtoc) {

	unsigned char bitmap[4];
	int i,sectors_free=0;

	for(i=0;i<TRACKS_PER_DISK;i++) {
		bitmap[0]=vtoc[VTOC_FREE_BITMAPS+(i*4)];
		bitmap[1]=vtoc[VTOC_FREE_BITMAPS+(i*4)+1];

		sectors_free+=ones_lookup[bitmap[0]&0xf];
		sectors_free+=ones_lookup[(bitmap[0]>>4)&0xf];
		sectors_free+=ones_lookup[bitmap[1]&0xf];
		sectors_free+=ones_lookup[(bitmap[1]>>4)&0xf];
	}

	return sectors_free*BYTES_PER_SECTOR;
}

/* free a sector from the sector bitmap */
void dos33_vtoc_free_sector(unsigned char *vtoc, int track, int sector) {

	if (debug) {
		fprintf(stderr,"vtoc_free: freeing T=%d S=%d\n",
			track,sector);
	}

	/* each bitmap is 32 bits.  With 16-sector tracks only first 16 used */
	/* 1 indicates free, 0 indicates used */
	if (sector<8) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+1]|=(0x1<<sector);
	}
	else if (sector<16) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+0]|=(0x1<<(sector-8));
	}
	else if (sector<24) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+3]|=(0x1<<(sector-16));
	}
	else if (sector<32) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+2]|=(0x1<<(sector-24));
	}
	else {
		fprintf(stderr,"Error vtoc_free_sector!  sector too big %d\n",sector);
	}
}

/* reserve a sector in the sector bitmap */
void dos33_vtoc_reserve_sector(unsigned char *vtoc, int track, int sector) {

	/* each bitmap is 32 bits.  With 16-sector tracks only first 16 used */
	/* 1 indicates free, 0 indicates used */
	if (sector<8) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+1]&=~(0x1<<sector);
	}
	else if (sector<16) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+0]&=~(0x1<<(sector-8));
	}
	else if (sector<24) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+3]&=~(0x1<<(sector-16));
	}
	else if (sector<32) {
		vtoc[VTOC_FREE_BITMAPS+(track*4)+2]&=~(0x1<<(sector-24));
	}
	else {
		fprintf(stderr,"Error vtoc_reserve_sector!  sector too big %d\n",sector);
	}
}


void dos33_vtoc_dump_bitmap(unsigned char *vtoc, int num_tracks) {

	int i,j;

	printf("\nFree sector bitmap:\n");
	printf("\tU=used, .=free\n");
	printf("\tTrack  FEDCBA98 76543210\n");
	for(i=0;i<num_tracks;i++) {
		printf("\t $%02X:  ",i);
		for(j=0;j<8;j++) {
			if ((vtoc[VTOC_FREE_BITMAPS+(i*4)]<<j)&0x80) {
				printf(".");
			}
			else {
				printf("U");
			}
		}
		printf(" ");
		for(j=0;j<8;j++) {
			if ((vtoc[VTOC_FREE_BITMAPS+(i*4)+1]<<j)&0x80) {
				printf(".");
			}
			else {
				printf("U");
			}
		}
		printf("\n");
	}
}


/* reserve a sector in the sector bitmap */
int dos33_vtoc_find_free_sector(unsigned char *vtoc,
	int *found_track, int *found_sector) {

	int start_track,track_dir,i;
	int bitmap;
	int found=0;

	/* Originally used to keep things near center of disk for speed */
	/* We can use to avoid fragmentation possibly */
	start_track=vtoc[VTOC_LAST_ALLOC_T]%TRACKS_PER_DISK;
	track_dir=vtoc[VTOC_ALLOC_DIRECT];

	if (track_dir==255) track_dir=-1;

	if ((track_dir!=1) && (track_dir!=-1)) {
		fprintf(stderr,"ERROR!  Invalid track dir %i\n",track_dir);
	}

	if (((start_track>VTOC_TRACK) && (track_dir!=1)) ||
		((start_track<VTOC_TRACK) && (track_dir!=-1))) {
		fprintf(stderr,"Warning! Non-optimal values for track dir t=%i d=%i\n",
			start_track,track_dir);
	}

	i=start_track;
	do {

		/* i+1 = sector 0..7 */
		bitmap=vtoc[VTOC_FREE_BITMAPS+(i*4)+1];
		if (bitmap!=0x00) {
			*found_sector=find_first_one(bitmap);
			*found_track=i;
			found++;
			break;
		}

		/* i+0 = sector 8..15 */
		bitmap=vtoc[VTOC_FREE_BITMAPS+(i*4)];
		if (bitmap!=0x00) {
			*found_sector=find_first_one(bitmap)+8;
			*found_track=i;
			found++;
			break;
		}

		/* Move to next track, handling overflows */
		i+=track_dir;
		if (i<0) {
			i=VTOC_TRACK;
			track_dir=1;
		}
		if (i>=TRACKS_PER_DISK) {
			i=VTOC_TRACK;
			track_dir=-1;
		}
	} while (i!=start_track);

	if (found) {
		/* clear bit indicating in use */
		dos33_vtoc_reserve_sector(vtoc, *found_track, *found_sector);

		return 0;
	}

	/* no room */
        return -1;

}
