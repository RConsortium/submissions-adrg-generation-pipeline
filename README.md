*Exploring how LLMs can help streamline tasks related to R-based regulatory submissions*

This project uses LLMs to simplify the creation of R-based ADRGs, leveraging the latest R ADRG template from PHUSE.

*Welcome!*

Join our slack channel [here](https://app.slack.com/client/TUMBMR083/C08GA7FGR3R?cdn_fallback=2)!

We are excited to have you contribute to the project. To get started, 
please review our issues and feel free to take any open issues that interest you. We picked several
sections from the pilot 3 ADRG that can potentially be streamlined by LLM/automation solution. Please also 
feel free to add new issues!


If you're looking for something to enhance, you can review existing examples in the repository. 
Feel free to improve them, fix any bugs, or make them more efficient. 

Using the section 7.3 table as an example [issue](https://github.com/RConsortium/submissions-adrg-generation-pipeline/issues/2)

- the LLM prompts can be found in pipeline/automation/llm_prompts.R

- Codes to execute the prompts can be found in pipeline/automation/llm_pipeline.qmd. 
The LLM generated table is outputs/intermediate/tlg_var_filter_table.csv

- Codes to compare LLM generated table to the original 7.3 table in 
pilot3 ADRG: pipeline/validation/compare_pilot3original_llmgen.qmd. 
Original table in pilot 3: /submission/pilot3_tlg_var_filter_table.csv. 
Comparison results: validation/results/tlg_var_filter_compare.csv.

- Codes to evaluate output consistency (run gpt4o, deep seek reasoner and claude 3.7 each 10 times). 
Results under pipeline/evaluation/eval_results

- Use multiple LLMs to QC each other: TBC


If you're feeling creative, you can implement new tables, features, or enhancements. Check out the current project structure to see where your changes might fit in.


Subfolders:

- submission/: sdtm data, ADaM data, R codes and ADRG qmd & pdf from pilot 3  

- outputs/: to store pipeline generated intermediate files, and final adrg pdf

- pipeline/:
    - automation/: This folder will contain all the scripts responsible for automating the ADRG generation, mainly focusing on interaction with the LLM.
        - llm_pipeline.qmd: Main script to run the pipeline. 
        The pipeline has four main components - LLM generated TLG related info, LLM generated ADaM related info, 
        R env related info, insert the generated information into the writing template.
        - llm_prompts.R: prompts to be used
    - preprocessing/: Contains scripts to preprocess certain files (if needed, empty now)
    - utils/: Contains utility functions that support various pipeline operations, like calling LLM APIs
    - validation/: contains scripts for result validation. 
    - evaluation/: contains evaluation scripts comparing different models

- docs/: documents such as adrg template

- tests/: Contains tests to ensure the performance of the pipeline components.
