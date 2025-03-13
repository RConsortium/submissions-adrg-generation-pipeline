Exploring how LLMs can help streamline tasks related to R-based regulatory submissions. 
This project uses LLMs to simplify the creation of R-based ADRGs, leveraging the latest R ADRG template from PHUSE.

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
    - validation/: contains scripts for result validation. empty now - may consider using a second LLM to validate results from the first LLM

- docs/: documents such as adrg template

- tests/: Contains tests to ensure the performance of the pipeline components.
