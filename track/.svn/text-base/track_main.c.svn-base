/**********************************************************************\
 * Name:           track_main 
 *
 * Description:    Entry point for tracking module of the jw_ptv
 *                 particle tracking utility. Originally, sequencing and
 *                 tracking were performed by the same executable under
 *                 a Tcl/Tk front end.
 *
 *                 This code is part of an executable that contains only
 *                 the tracking code in command line form.
 *               
 * Author:         Chris Bunney, University of Plymouth
 *
 * Created:        July 2005
\**********************************************************************/
#include "ptv.h"

int main( int argc, char **argv )
{
	char opt;
	extern char *optarg;
	int trackb = 0;		// 0 = forwards only, 1 = forward + back, 2 = back only
	
	strcpy( szDynTParFilename, "parameters/dynamic_track.par" );
	useCompression = 0;
	staticTracking = 0;
	verbose = 0;
		
	while( ( opt = getopt( argc, argv, "bBcp:svh" ) ) != -1 ) {
		switch( opt ) {
			case 'c':
			fprintf( stderr, "Enabling compression.\n" );
			useCompression = 1;
			break;

			case 'p':
			fprintf( stderr, "Using tracking file {%s}.\n", optarg );
			strcpy( szDynTParFilename, optarg );
			break;

			case 's':
			fprintf( stderr, "Using static tracking parameters.\n" );
			staticTracking = 1;
			break;
			
			case 'b':
			fprintf( stderr, "Enabling tracking backwards.\n" );
			trackb = 1;
			break;

			case 'B':
			fprintf( stderr, "Running backwards tacking ONLY.\n" );
			trackb = 2;
			break;

			case 'v':
			fprintf( stderr, "Producing verbose output.\n" );
			verbose = 1;
			break;

			case 'h':
			default:
			printf( "\nUsage: track -[bBcpsvh]\n\n"
					"Options:\n"
					"   -b\n"
					"        Run backwards tracking after forward track.\n\n"
					"   -B\n"
					"        Run backwards tracking ONLY.\n\n"
					"   -c\n"
					"        Enable gzip compression of output files.\n"
					"        This includes all files written to the res/\n"
					"        directory and img/*_target files.\n"
					"        Note: any input file already written by\n"
					"        'sequence' are also expected to be in gzip format.\n\n"
					"   -p <parameter file>\n"
					"        Use the dynamic tracking parameter file specified\n"
					"        in <parameter file> instead of the default file.\n"
					"        Default file is: 'parameters/dynamic_track.par'.\n"
					"        Flag has no effect is -s flag is specified.\n\n"
					"   -s\n"
					"        Use static tracking parameters as defined in the\n"
					"        file 'parameters/track.par'. Overrides -p flag.\n\n"
					"   -v\n"
					"        Print extra verbose output\n\n"
					"   -h\n"
					"        Prints this usage informaton.\n\n"
				  );

			return 0;
		}
	}

	printf( "\n" );

	init_proc_c();
	start_proc_c();	// this is obviously still needed

	if( trackb < 2 ) {
		fprintf( stderr, "Tracking forwards\n" );
		trackcorr_c();
	}

	// track backwards if -b flag set:
	if( trackb > 0 ) {
		fprintf( stderr, "Tracking backwards\n" );
		trackback_c();
	}

	// free up memory and quit:
	quit_proc_c();
	return 0;
}
