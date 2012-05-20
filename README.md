command_line
============

Command line version of the 3D-PTV software, provided by Alex Nimmo-Smith, University of 
Plymouth, United Kingdom. As a derivative, work, this branch is distrubuted under the 
same terms as the 3D-PTV software. For more details see COPYING


=========================================================
IMPORTANT NOTICE:
=========================================================
This derivative version of the Particle Tracking Velocimetry
Software (originally developed at IGP/IFU at ETH Zurich) may only be distributed or used 
under the terms of the LICENSE AGREEMENT OF THE PARTICLE TRACKING
VELOCIMETRY SOFTWARE.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE SOFTWARE.

=========================================================
General Notes:
=========================================================
This revised version of the Particle Tracking Velocimetry 
Software is intended to aid in the processing of large 
quantities of data. However, the original version should 
still be used for setting up configuration options and testing.

Main features are (details and usage below):
-- Removal of GUI and separation of 'sequence' and 'track' to
   ease distributed processing of large datasets
-- Clean-up of build system
-- Ability to read and write compressed files
-- Provision of frame-dependent tracking parameters to optimise
   tracking in time-varying flows (e.g.	ocean flows with 
   oscillatory wave motion superimposed on a mean flow)

This revised version has been built, tested and run on GNU/Linux
systems only (so far).

These enhancements have been made for use with the submersible 3D-PTV
system developed by Dr Alex NIMMO SMITH, University of Plymouth,
United Kingdom (www.coastalprocesses.org/sptv/). 
It is hoped that you will also find these modifications
useful in your academic research. Please send feedback and enhancements
to: alex.nimmo.smith AT plymouth.ac.uk

Coding revisions (c) Chris Bunney, University of Plymouth, United Kingdom, 2005

=========================================================
Build:
=========================================================
-- libtiff-devel library is required
-- Create a new directory and change to it
-- tar -xzvf jw_ptv.tgz ./
-- make
-- New executables will be available in the "bin" directory

=========================================================
New Functionality of the Multimedia PTV Tracking Software
=========================================================


[1]	Software has had all Tcl/Tk code removed and can now be run from the
	commandline without the GUI.

[2]	The sequencing and tracking capabilities have been split into two separate
	executables that can be run independently of each other.

[3]	Both 'sequence' and 'track' now take a command line flag (-c) to read and
	write compressed input/output files in gzip format. This includes all files
	written/read from the 'res' directory and the '_target' files in the 'img'
	directory. Compressed images in the 'img' directory are also read if the
	uncompressed image does not exist - this is done implicitly and is not
	affected by the -c flag.

	Note: If you run 'sequence' with the -c flag then you must run 'track' with
	the -c flag as well!! After running the first time with the -c flag, it
	might be a good idea to purge all old uncompressed files in the img/ and
	res/ directories to ensure that they are not loaded by accident (for example
	if the -c flag was accidentally omitted).

	'track' can also take a flag (-p) to specify a different file to use for
	dynamic tracking parameters. The default is 'parameters/dynamic_track.par'.

	To use the original static tracking parameters file ('parameters/track.par')
	pass '-s' to 'track'.

	Run either 'sequence' or 'track' with the -h flag to see usage information.


	Sequence flags:
		-c Turn on gzip compression of input/output files.  
		-v Print verbose output.

	Track flags:
		-b performs backwards tracking after forward tracking.
		-B performs ONLY backward tracking.
		-c Turn on gzip compression of input/output files.
		-p Alternate location of dynamic tracking file
		-s Uses static tracking parameters contained in parameters/track.par
			(original tk_ptv file) instead of dynamic tracking.
		-v Print verbose output.


[4]	A new file now exists in the 'parameters' directory called
	'dynamic_track.par'. This file should contain average particle tracking
	parameters for each timestep (i.e. image set). Each timestep appears on a
	separate line and contains the following space separated fields:

			dvxmin dvxmax dvymin dvymax dvzmin dvzmax dangle dacc add

	There must be the same amount of lines in the dynamic_track.par file as
	there are timesteps in the sequence.

