

# the following prompts can be used to extract specific information from code

prompt_var_dat_code <- "Please review the following R code and identify the variables used, 
along with the corresponding datasets they belong to. 
Provide a table that can be directly saved as a csv, with two columns: 
one for the variable names and the other for the associated dataset names. no explanation please"

prompt_filter_code <- "Please review the following R code and identify the filtering criteria applied. 
no explanation please. no line break please."

prompt_output_code <- "Please review the following R code and identify the output file name. 
no explanation please"

prompt_parse_dat_var <- "Below is a table with two columns: one for the variable names and the other for the associated dataset names. 
For each row, generate one value by parsing the data set name and the variable name, seperated by a dot. 
captialize all characters. no explanation please. do not include line break please"

# first extract all information from code, generate a paragraph
# then extract information from the paragraph
# however this approach gave more formatting issues

prompt_tlg_code_extraction <- "Please review the following R code and summarize three bullet points 
1) the variables used, along with the corresponding datasets they belong to. 
2) the filtering criteria applied.
3) the output file name. 
no explanation please"

prompt_var_dat_para <- "Please review the following description. 
Provide a table that can be directly saved as a csv, with two columns: 
one for the variable names and the other for the associated dataset names. no explanation please"

prompt_filter_para <- "Please review the following description and identify the filtering criteria applied. 
no explanation please. no line break please. "

prompt_output_para <- "Please review the following description and identify the output file name. 
no explanation please. do not include character ` please"
