# Sasori Sgathan: Azurite
This application is an attempt to analyze a custom data set based on data generated at https://www.cancer-rates.info/ca/; a site displaying data from the California Cancer Registry. Note that the actual site is hosted by the Kentucky Cancer Registry at University of Kentucky. Initially, I will be analyzing 2011-2015 aggregate rates of Invasive Cancer Incidence and Cancer Mortality (all cancer sites/types) by county in the State of California. Eventually this with expand into analyzing rates per county by cancer site/type. The current version of the combined table is in the repository, and will be periodically updated. In addition to the data, it contains notes and citations for data attribution (MLA, APA, & Chicago styles) in case you want to use it in your own studies.

For the most user friendly experience in running this code you should have the R language and R Studio (free version is sufficient) installed on your system. Note that this code has the following package dependencies:
- readxl
- tidyr
- dplyr
- ggplot2
- shiny
- car

When loading this in R Studio, you will have the option in your IDE to download and install any packages you do not currently have.

## Some user notes and limitations
The way this currently works upon running is simple (screenshots coming soon):
- In the drop down select your dependent variables - there's only two choices. Then select your independent variables. You will then see a scatterplot. You can also select other tabs for model summary and diagnostics. Note that currently you can only select 'Incidence_Cases' and 'Mortality_Deaths' as independent variables without throwing an error.
- Filtering. You can filter your input in one of four ways:
  - First, you can filter by state region (a grouping of associated counties) via drop down.
  - You can filter via slider by number of cases, deaths, or total population.
  - One note here. If you move your sliders too far and then try to filter by region, you'll get an [xlim] or [id1...1] error and no output to the tabs. If you want to examine a region, filter that way first then play with the sliders.

The other columns in the data set are precalculated percentage rates of 100,000 person blocks. These include a crude rate, age-adjusted rate (to Year 2000 US Standard Population), and 95% confidence intervals for incidence and mortality. The current code has no way to compare those as independent variables with each other or against the 'Incidence_Cases' and 'Mortality_Deaths' selections.

## Future changes
- Build in a message to display when [xlim] or [id1...1] is output like, _"You may want to increase your <Incidence/Mortality/Population> range for this to display correctly.
- Figure out a way to compare the other columns in the data set.
- In the data set itself, eventually begin bringing in data for incidence and mortality per cancer site/type at the county level. This will also neccessitate some refactoring in the code to allow for those choices, once the data is formatted.
- Add a logo and some color to the UI. Also work on making a widget out of this for embedding in a web site.

## Why this data set?
The analysis of this data set is a personal interest, an attempt to answer a question posed to me in mid-2018. I'll eventually go into detail once I have more to share.

## Variation
You'll notice I've appended the moniker 'Azurite' to the name. For those who aren't geology geeks, it's a deep blue colored carbonate mineral produced by the weathering of copper deposits. I may fork this code for analysing other kinds of data in the future. When I do so, I will append another mineral/element/rock to the name. 

## A special thanks and attribution
This is not the original version of this experiment. I was originally inspired by NCAA-Shiny-App (https://github.com/alexwalterhiggins/NCAA-Shiny-app), an R Shiny application written for users to build multiple linear regression models to predict coaching salary parameters. We've gone through a few iterations, and finally decided to put our own repo together.

Alex (https://github.com/alexwalterhiggins) is a data science instructor in Nebraska, and has only come recently to GitHub. If you want play with the application he's put together and/or are into sports stats, I encourage you to fork his app and follow him. To Alex, thanks for inadvertently giving me a potential path forward to answer my question, and keep on coding.
