/**********************************************************************\
 * Name:           dynamicTrack
 *
 * Description:    Reads dynamic tracking parameters used by jw_ptv
 *                 particle tracking.
 *               
 * Author:         Chris Bunney, University of Plymouth
 *
 * Created:        July 2005
\**********************************************************************/


#include "ptv.h"
#include "dynamic_track.h"

void loadTrackingParameters( TParList *tp, int seq_first, int seq_last )
{
	FILE *fp;					// File pointer to dynamic tracking parameters file
	int nTpSize;				// number of tracking parameters to be read from file
	int nRead;					// number of fileds read in line
	int nLine = 0;				// line number in file
	int nCnt = 0;				// number of lines found that we actually want
	int idx;					// image index of current line
	
	if( staticTracking )
		return;
	
	fprintf( stderr, "Loading dynamic tracking file.\n" );

	if( ( fp = fopen( szDynTParFilename, "r" ) ) == NULL ) {
		fprintf( stderr, "Failed to open file tracking parameters file '%s'\n",
				szDynTParFilename );

		return;
	}

	// allocate memory for tracking data array:
	nTpSize = seq_last - seq_first + 1;
	*tp = (trackparameters*) calloc( nTpSize, sizeof( trackparameters ) );

	while( fgets( buf, 256, fp ) ) {

		nLine++;

		// check if we want this line
		sscanf( buf, "%d", &idx );
		if( idx >= seq_first && idx <= seq_last ) {
			nCnt++;
			nRead = sscanf( buf, "%*d %lf %lf %lf %lf %lf %lf %lf %lf %d\n",
					&(*tp)[idx].dvxmin,
					&(*tp)[idx].dvxmax,
					&(*tp)[idx].dvymin,
					&(*tp)[idx].dvymax,
					&(*tp)[idx].dvzmin,
					&(*tp)[idx].dvzmax,
					&(*tp)[idx].dangle,
					&(*tp)[idx].dacc,
					&(*tp)[idx].add
					);

			// check for malformed line:
			if( nRead != 9 )
			{
				fprintf( stderr, "Malformed line in file {%s} at line %d\n\n",
						szDynTParFilename,
						nLine );
				exit( -1 );
			}
		}
	}	

	// check we read the right amount of parameter lines:
	if( nTpSize != nCnt ) {
		fprintf( stderr, "Error! Expected to read %d lines from %s, actually read %d.\n\n",
				nTpSize,
				szDynTParFilename,
				nCnt
			   );
		exit( -1 );
	}
}

void getCurrentTPar( TParList tplist, trackparameters *tp, int step )
{
	int i = step - seq_first;
	
	tp->dvxmin = tplist[i].dvxmin;
	tp->dvxmax = tplist[i].dvxmax;
	tp->dvymin = tplist[i].dvymin;
	tp->dvymax = tplist[i].dvymax;
	tp->dvzmin = tplist[i].dvzmin;
	tp->dvzmax = tplist[i].dvzmax;
	tp->dangle = tplist[i].dangle;
	tp->dacc = tplist[i].dacc;
	tp->add = tplist[i].add;
}

void freeTrackingParameters( TParList tp )
{
	if( !staticTracking )
		free( tp );
}
