INCLUDE=-Isequence -Icommon -Itrack
LIBDIR=
LIBS=-lm -ltiff -lz
CFLAGS=-O3
BINDIR=./bin

COMMON=	common/imgcoord.o \
		common/intersect.o \
		common/lsqadj.o \
		common/multimed.o \
		common/pointpos.o \
		common/ray_tracing.o \
		common/rotation.o \
		common/tools.o \
		common/trafo.o

SEQUENCE_OBJS=	sequence/correspondences.o \
		sequence/jw_ptv.o \
		sequence/epi.o \
		sequence/image_processing.o \
		sequence/peakfitting.o \
		sequence/segmentation.o \
		sequence/sequence_main.o 

TRACK_OBJS=	track/track.o \
		track/ptv.o \
		track/jw_ptv_track.o \
		track/track_main.o \
		track/ttools.o \
		track/orientation.o \
		track/dynamic_track.o
	

.SUFFIXES: .c .o
	
all: sequence track
	
sequence: $(SEQUENCE_OBJS) $(COMMON) 
	gcc $(CFLAGS) -o $(BINDIR)/sequence $(LIBDIR) $(LIBS) $(SEQUENCE_OBJS) $(COMMON)
	
track: $(TRACK_OBJS) $(COMMON) 
	gcc $(CFLAGS) -o $(BINDIR)/track $(LIBDIR) $(LIBS) $(TRACK_OBJS) $(COMMON)



clean:
	rm -rf $(COMMON) $(TRACK_OBJS) $(SEQUENCE_OBJS)


# Implicit rules:
.c.o:
	gcc $(CFLAGS) -c $(INCLUDE) -o $@ $<

