/**********************************************************************\
 * Name:           track_main 
 *
 * Description:    Entry point for sequencing module of the jw_ptv
 *                 particle tracking utility. Originally, sequencing and
 *                 tracking were performed by the same executable under
 *                 a Tcl/Tk front end.
 *
 *                 This code is part of an executable that contains only
 *                 the sequencing code in command line form.
 *               
 * Author:         Chris Bunney, University of Plymouth
 *
 * Created:        July 2005
\**********************************************************************/

#include "ptv.h"
#include <unistd.h>

int main( int argc, char **argv )
{
	char opt;
	
	useCompression = 0;
	verbose = 0;

	while( ( opt = getopt( argc, argv, "cvh" ) ) != -1 ) {
		switch( opt ) {
			case 'c':
			fprintf( stderr, "Enabling compression\n" );
			useCompression = 1;
			break;

			case 'v':
			fprintf( stderr, "Printing extra verbose output\n" );
			verbose = 1;
			break;
			
			case 'h':
			default:
			printf( "\nUsage: sequence [-cvh]\n\n"
					"Options:\n"
					"   -c\n"
				 	"        Enable gzip compression of output files.\n"
					"        This includes all files written to the res/\n"
					"        directory and img/*_target files.\n\n"
					"        If you run 'sequence' using the -c flag,\n"
					"        make sure you also run 'track' with the -c flag.\n\n"
					"        Note: Reading of gzipped image files is done\n"
					"        implicitly and is not effected by this flag.\n\n"
					"   -v\n"
					"        Prints extra verbose output.\n\n"
					"   -h\n"
					"        Prints this usage informaton.\n\n"
				  );

			return 0;
		}
	}
	
	init_proc_c();
	start_proc_c();
	sequence_proc_c();

	fprintf( stderr, "\n\nComplete\n\n" );

	quit_proc_c();
	return 0;
}
