This file set was made to create GCAM NDC constraint files. This document details the steps to create these files.
The data was compiled by Matt Binsted in the Fall of 2016 and the R script and file structure was made by Jonathan Huster in the Summer of 2019

NOTE: The file set is complete as is. These steps should be followed if 
	1. GDP pathways change
	2. Emissions pathways change
	3. NDC paths based off of a new baseline scenario are desired

STEPS:
1. Run a baseline scenario. This is to establish emissions and GDP pathways.

2. Open the modelinterface and run the [PATH]/NDC_generator/input/queries/batch_query_NDC.xml query on the results.
	a. Save the result as "NDC_QUERY.csv" in the same directory

3. Open [PATH]/NDC_generator/generate_NDC.R and ensure the working directory is set to [PATH]/NDC_generator/. 
	a. This can be checked with getwd() and set with setwd([PATH]/NDC_generator).

4. Source generate_NDC.R and the .csv versions of the NDC constraints and linking file will be in the output directory. 

5. Open the GCAM ModelInterface and read the desired scenario constraint with the header file in the output directory. 
	a. Save the files as xmls.
	b. NOTE: the files may have quotation issues from being read through the MI
		i. Open [PATH]/NDC_generator/scripts/clean_xml.R.
		ii. Ensure the working directory is set to "[PATH]/NDC_generator/scripts/".
		iii. Source clean_xml.R and the xmls should now work.