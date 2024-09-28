# Toronto-shelter-utilization
This project aims to examine how Toronto's homeless shelters are being used on a daily basis. I focus on bed-based (communal sleeping room) and room-based (private sleeping room, typically for families or vulnerable individuals) shelters and their occupancy rates from Jan - Sept 2024. This repository serves as a space to store code and data for a paper that reviews the daily utilization of homeless shelters in Toronto from Jan - Sept 2024. Specifically, this project reviews room-based and bed-based shelter programs, caclulates occupancy rates for the same and includes visualisations to better understand the data. Through this analysis, we can gain insight into the daily proceedings of homeless shelters in Toronto and understand whethere their resources are being allocated optimally and efficiently. This will help narrow down any potential areas for improvement or re-allocation of funding and resources. 

# File Structure
The repo is structured as:

* data/raw_data contains the raw data as obtained from Open Data Toronto: https://open.toronto.ca/dataset/daily-shelter-overnight-service-occupancy-capacity/
* data/analysis_data contains the cleaned dataset that was constructed.
* other contains relevant literature, details about LLM chat interactions, and sketches.
* paper contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
* scripts contains the R scripts used to simulate, download and clean data.

# Statement on LLM usage
ChatGPT was used to troubleshoot certain errors while coding, and understanding how to best export the visualisations for the paper. All conversations with ChatGPT are included in the other/llm/usage.txt folder.
