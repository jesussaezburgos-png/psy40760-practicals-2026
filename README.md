# PSY40760 — Advanced Data Analysis and Statistics in R (2026/27)

Weekly practical materials for PSY40760, MSc Behavioural Neuroscience, UCD. Each week has its own R Markdown notebook you'll work through in RStudio during the practical session.

This repo does **not** contain the take-home exam — that's released separately, on its own repo, at the start of the exam window.

## Getting started (do this once, before Week 2)

1. **Install R and RStudio.** See the "General Setup" section on Brightspace for step-by-step instructions.
2. **Install Git and set up SSH keys**, if you haven't already — also covered in the Brightspace General Setup section.
3. **Clone this repository:**
   ```
   git clone git@github.com:ozika/psy40760-practicals-2026.git
   ```
4. **Point R at the repository folder:** in RStudio, *Session → Set Working Directory → Choose Directory…*, and choose `psy40760-practicals-2026`. (No RStudio Project is needed.)
5. **Load and restore the package environment**, in the console:
   ```r
   renv::load()      # switch this R session to the course's package library
   renv::restore()   # install the exact package versions the course uses
   ```
   This installs the packages into an isolated project library, without touching anything else on your machine.

The empty file `.root-practicals` at the top of the repository marks its root: the worksheets find their data with `here::i_am(".root-practicals")`. Don't move or delete it.

## Getting each week's update

New weeks are added to this repo as the trimester progresses. Before each practical:

```
git pull
```

from inside the repository folder. Then, in RStudio, point R at the folder again and run `renv::load()` followed by `renv::restore()`, which installs any packages added for that week.


