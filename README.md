
## README

### Cloning and updating the repo

```bash
# do this to get the repo, first time only
git clone https://www.github.com/fawda13/oss2017_synthesis.git

# do this every time before you make changes
git pull

# do this after you make changes
git add -A
git commit -m "informative message"
git pull
git push
```
### View info online

Type URL with filename, e.g., <href src="https://fawda123.github.io/oss2017_synthesis/tbrest">https://fawda123.github.io/oss2017_synthesis/tbrest</href>

### Repository info

Folders:

* `data` RData files, load with `data(filename)`
* `data-raw` - put raw and intermediate data files here, e.g., .xlsx., .txt., .csv
* `R` - R scripts

RData files (these should be text files?) in `data`, normalized:

* `bmpdat.RData` restoration projects for water treatment
* `bmpstat.RData` locations of restoration projects for water treatment
* `habdat.RData` restoration projects for habitat
* `habstat.RData` locations of restoration projects for habitat
* `restdat.RData` restoration projects combined
* `reststat.RData` location of restoration projects combined
* `wqdat.RData` TB water quality data by site, date, var, val
* `wqstat.RData` TB water quality stations as lat/lon
