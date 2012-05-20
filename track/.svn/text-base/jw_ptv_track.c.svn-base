/****************************************************************************
*****************************************************************************

Author/Copyright:      	Hans-Gerd Maas / Jochen Willneff

Address:	            Institute of Geodesy and Photogrammetry
		                ETH - Hoenggerberg
		                CH - 8093 Zurich

Creation Date:	       	took a longer time ...

Description:	       	target detection, correspondences and
		                positioning with tclTk display
					    -> 4 camera version

Routines contained:    	many ...

Amended:                June 2005, Chris Bunney, University of Plymouth.
                        Removed all Tcl/Tk code and implemented a
                        facility for reading a dynamic tracking parameters
                        input file. Also, files can now be read/written
						in compressed form using zlib.

****************************************************************************/
#include "ptv.h"

#define nmax 5120
#define TCL_OK 0
#define TCL_ERROR 1

/*  global declarations for ptv  */
/*-------------------------------------------------------------------------*/

int	n_img;	       		      	/* no of images */
int	hp_flag=0;           	      	/* flag for highpass */
int	tiff_flag=0;           	      	/* flag for tiff header */
int oddevenflag=0;              /* flag for oddeven */
int	chfield;       		       	/* flag for field mode */
int	nfix;	       	       	       	/* no. of control points */
int	num[4];	       		       	/* no. of targets per image */
int numc[4];                        /* no. of targets in current image */
int nump[4];                        /* no. of targets in previous image */
int numn[4];                        /* no. of targets in next image */
int n_trac[4];	           	/* no. of tracks */
int	match=0;		      	/* no. of matches */
int	match2=0;	      	       	/* no. of matches in 2nd pass */
int	nr[4][4];		     	/* point numbers for man. ori */
int	imx, imy, imgsize;	      	/* image size */
int	zoom_x[4],zoom_y[4],zoom_f[4];  /* zoom parameters */
int	pp1=0, pp2=0, pp3=0, pp4=0;   	/* for man. orientation */
int	seq_first, seq_last;	       	/* 1. and last img of seq */
int	demo_nr;		      	/* for demo purposes */
int	examine = 0;		       	/* for more detailed output */
int	dump_for_rdb;		       	/* # of dumpfiles for rdb */
int cr_sz;                          /* size of crosses */
int display;                        /* display flag */
int corp, corc, corn;
int m[4];
int trackallocflag = 0;      /* checkflag if mega, c4, t4 already allocated */

double	pix_x, pix_y;			      	/* pixel size */
double	ro;			      	        /* 200/pi */
double	cn, cnx, cny, csumg, eps0, corrmin;	/* correspondences par */
double 	rmsX, rmsY, rmsZ, mean_sigma0;		/* a priori rms */
double  X_lay[2], Zmin_lay[2], Zmax_lay[2];	/* illu. layer data */

FILE	*fp1, *fp2, *fp3, *fp4, *fpp;
gzFile	fgz;

char	img_name[4][256];      	/* original image names */
char   	img_lp_name[4][256]; 	/* lowpass image names */
char   	img_hp_name[4][256];   	/* highpass image names */
char   	img_cal[4][128];       	/* calibrayion image names */
char   	img_ori[4][128];       	/* image orientation data */
char   	img_ori0[4][128];      	/* orientation approx. values */
char   	img_addpar[4][128];    	/* image additional parameters */
char   	img_addpar0[4][128];   	/* ap approx. values */
char   	seq_name[4][128];      	/* sequence names */
char   	track_dir[128];	       	/* directory with dap track data */
char    fixp_name[128];
char   	res_name[128];	      	/* result destination */
char   	filename[128];	      	/* for general use */
char   	buf[256], val[256];	       	/* buffer */

unsigned char	*img[4];      	/* image data */
unsigned char	*img0[4];      	/* image data for filtering etc */
unsigned char	*zoomimg;     	/* zoom image data */

Exterior       	Ex[4];	      	/* exterior orientation */
Interior       	I[4];	       	/* interior orientation */
ap_52	       	ap[4];	       	/* add. parameters k1,k2,k3,p1,p2,scx,she */
mm_np	       	mmp;	       	/* n-media parameters */
target	       	pix[4][nmax]; 	/* target pixel data */
target	       	pix0[4][4];    	/* pixel data for man_ori points */

target          *t4[4][4];
int             nt4[4][4];

coord_2d       	crd[4][nmax];  	/* (distorted) metric coordinates */
coord_2d       	geo[4][nmax];  	/* corrected metric coordinates */
coord_3d       	fix[4096];     	/* testfield points coordinates */
n_tupel	       	con[nmax];     	/* list of correspondences */

corres	       	*c4[4];
trackparameters tpar;           /* tracking parameters */

mm_LUT	       	mmLUT[4];     	/* LUT for multimedia radial displacement */
coord_3d        *p_c3d;
P *mega[4];

/* ChrisB added: */
char szDynTParFilename[128];		/* Filename for dynamic tracking parameters*/
int useCompression;					/* Compressed input/output flag. */
int staticTracking;					/* Static/dynamic tracking flag. */
int verbose;						/* Verbosity flag */

/***************************************************************************/

int init_proc_c(int argc, const char** argv)
{
  int  i;
  const char *valp;

  if( verbose ) puts ("\nMultimedia Particle Positioning and Tracking\n");

  // ChrisB: Do we need this? no....
  //valp = Tcl_GetVar(interp, "examine",  TCL_GLOBAL_ONLY);
  //examine = atoi (valp);

  ro = 200/M_PI;

  /*  read from main parameter file  */
  fpp = fopen_r ("parameters/ptv.par");

  fscanf (fpp, "%d\n", &n_img);

  for (i=0; i<4; i++)
    {
      fscanf (fpp, "%s\n", img_name[i]);
      fscanf (fpp, "%s\n", img_cal[i]);
    }
  fscanf (fpp, "%d\n", &oddevenflag);
  fscanf (fpp, "%d\n", &hp_flag);
  fscanf (fpp, "%d\n", &tiff_flag);
  fscanf (fpp, "%d\n", &imx);
  fscanf (fpp, "%d\n", &imy);
  fscanf (fpp, "%lf\n", &pix_x);
  fscanf (fpp, "%lf\n", &pix_y);
  fscanf (fpp, "%d\n", &chfield);
  fscanf (fpp, "%lf\n", &mmp.n1);
  fscanf (fpp, "%lf\n", &mmp.n2[0]);
  fscanf (fpp, "%lf\n", &mmp.n3);
  fscanf (fpp, "%lf\n", &mmp.d[0]);
  fclose (fpp);

  /* read illuminated layer data */
  fpp = fopen_r ("parameters/criteria.par");
  fscanf (fpp, "%lf\n", &X_lay[0]);
  fscanf (fpp, "%lf\n", &Zmin_lay[0]);
  fscanf (fpp, "%lf\n", &Zmax_lay[0]);
  fscanf (fpp, "%lf\n", &X_lay[1]);
  fscanf (fpp, "%lf\n", &Zmin_lay[1]);
  fscanf (fpp, "%lf\n", &Zmax_lay[1]);
  fscanf (fpp, "%lf", &cnx);
  fscanf (fpp, "%lf", &cny);
  fscanf (fpp, "%lf", &cn);
  fscanf (fpp, "%lf", &csumg);
  fscanf (fpp, "%lf", &corrmin);
  fscanf (fpp, "%lf", &eps0);
  fclose (fpp);

  mmp.nlay = 1;

  /* read sequence parameters (needed for some demos) */

  fpp = fopen_r ("parameters/sequence.par");

  for (i=0; i<4; i++)		fscanf (fpp, "%s\n", seq_name[i]);
  fscanf (fpp,"%d\n", &seq_first);
  fscanf (fpp,"%d\n", &seq_last);
  fclose (fpp);

  /* initialize zoom parameters and image positions */
  for (i=0; i<n_img; i++)
    {
      num[i] = 0;
      zoom_x[i] = imx/2; zoom_y[i] = imy/2; zoom_f[i] = 1;
    }

  imgsize = imx*imy;

  /* allocate memory for images */
  for (i=0; i<n_img; i++)
    {
      img[i] = (unsigned char *) calloc (imgsize, 1);
      if ( ! img[i])
	{
	  printf ("calloc for img%d --> error\n", i);
	  exit (1);
	}
    }

  for (i=0; i<n_img; i++)
    {
      img0[i] = (unsigned char *) calloc (imgsize, 1);
      if ( ! img0[i])
	{
	  printf ("calloc for img0%d --> error\n", i);
	  exit (1);
	}
    }

  // TODO: remove references to zooming some time as we do not need it.
  zoomimg = (unsigned char *) calloc (imgsize, 1);
  if ( ! zoomimg)
    {
      printf ("calloc for zoomimg --> error\n");
      return TCL_ERROR;
    }

  //parameter_panel_init(/*interp*/);
  // ChrisB: size of crosses - not important.
  cr_sz = 4;//atoi(Tcl_GetVar2(interp, "mp", "pcrossize",  TCL_GLOBAL_ONLY));

  display = 1;
  return TCL_OK;

}

#if 1	// we seemingly do need this for tracking.........
int start_proc_c(/*ClientData clientData, Tcl_Interp* interp,*/ int argc, const char** argv)
{
  int  i, k;

  /*  read from main parameter file  */
  fpp = fopen_r ("parameters/ptv.par");

  fscanf (fpp, "%d\n", &n_img);

  for (i=0; i<4; i++)
    {
      fscanf (fpp, "%s\n", img_name[i]);
      fscanf (fpp, "%s\n", img_cal[i]);
    }
  fscanf (fpp, "%d\n", &oddevenflag);
  fscanf (fpp, "%d\n", &hp_flag);
  fscanf (fpp, "%d\n", &tiff_flag);
  fscanf (fpp, "%d\n", &imx);
  fscanf (fpp, "%d\n", &imy);
  fscanf (fpp, "%lf\n", &pix_x);
  fscanf (fpp, "%lf\n", &pix_y);
  fscanf (fpp, "%d\n", &chfield);
  fscanf (fpp, "%lf\n", &mmp.n1);
  fscanf (fpp, "%lf\n", &mmp.n2[0]);
  fscanf (fpp, "%lf\n", &mmp.n3);
  fscanf (fpp, "%lf\n", &mmp.d[0]);
  fclose (fpp);

  /* read illuminated layer data */
  fpp = fopen_r ("parameters/criteria.par");
  fscanf (fpp, "%lf\n", &X_lay[0]);
  fscanf (fpp, "%lf\n", &Zmin_lay[0]);
  fscanf (fpp, "%lf\n", &Zmax_lay[0]);
  fscanf (fpp, "%lf\n", &X_lay[1]);
  fscanf (fpp, "%lf\n", &Zmin_lay[1]);
  fscanf (fpp, "%lf\n", &Zmax_lay[1]);
  fscanf (fpp, "%lf", &cnx);
  fscanf (fpp, "%lf", &cny);
  fscanf (fpp, "%lf", &cn);
  fscanf (fpp, "%lf", &csumg);
  fscanf (fpp, "%lf", &corrmin);
  fscanf (fpp, "%lf", &eps0);
  fclose (fpp);

  mmp.nlay = 1;

  /* read sequence parameters (needed for some demos) */

  fpp = fopen_r ("parameters/sequence.par");

  for (i=0; i<4; i++)		fscanf (fpp, "%s\n", seq_name[i]);
  fscanf (fpp,"%d\n", &seq_first);
  fscanf (fpp,"%d\n", &seq_last);
  fclose (fpp);

  /*  create file names  */
  for (i=0; i<n_img; i++)
    {
      strcpy (img_lp_name[i], img_name[i]); strcat (img_lp_name[i], "_lp");
      strcpy (img_hp_name[i], img_name[i]); strcat (img_hp_name[i], "_hp");
      strcpy (img_ori[i], img_cal[i]);  strcat (img_ori[i], ".ori");
      strcpy (img_addpar[i], img_cal[i]); strcat (img_addpar[i],".addpar");
    }

  /*  read orientation and additional parameters  */
  for (i=0; i<n_img; i++)
    {
      read_ori (&Ex[i], &I[i], img_ori[i]);
      rotation_matrix (Ex[i], Ex[i].dm);

      fp1 = fopen_r (img_addpar[i]);
      fscanf (fp1,"%lf %lf %lf %lf %lf %lf %lf",
	      &ap[i].k1, &ap[i].k2, &ap[i].k3, &ap[i].p1, &ap[i].p2,
	      &ap[i].scx, &ap[i].she);
      fclose (fp1);
    }

  /* read and display original images */
  // ChrisB: or in our case, just read them.
  for (i=0; i<n_img; i++)
    {
      /* reading */
      //sprintf(val, "camcanvas %d", i+1);
      //Tcl_Eval(interp, val);

      //read_image (/*interp,*/ img_name[i], img[i]);
      //sprintf(val, "newimage %d", i+1);

      //Tcl_Eval(interp, val);
      //sprintf(val, "keepori %d", i+1);
      //Tcl_Eval(interp, val);
    }

  if (!trackallocflag)
    {
      for (i=0; i<4; i++)
	{
	  mega[i]=(P *) calloc(sizeof(P),M);
	  c4[i]=(corres *) calloc(sizeof(corres),M);
	  for (k=0; k<4; k++) { t4[i][k]=(target *) calloc(sizeof (target),M);}
	}
      trackallocflag=1;
    }

  return TCL_OK;

}
#endif

/* ********************************* */


int quit_proc_c ( )
{
	int i, k;

	for (i=0; i<n_img; i++) { free (img[i]); free (img0[i]); }
	free (zoomimg);

	/* delete unneeded files */
	for (i=0; i<n_img; i++)      	k = remove (img_lp_name[i]);
	return TCL_OK;
}
