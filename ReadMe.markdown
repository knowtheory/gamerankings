# Gamerankings Analysis

This project is part of an endeavor into Algorithmic Journalism.  It's purpose is to serve as a replicable base of data and analysis that can be used to explore and explain subjects of interest.

The subject of this repository is game review scoring.  There have been [questions of review outlet bias](http://arstechnica.com/civis/viewtopic.php?f=22&t=62024) towards one platform or another, which are questions that can be answered empirically (even if we can't climb into the brains of reviewers).

## Usage
This repository is divided into 5 parts:

* The fetchers
* The scrapers
* The infrastructure
* The analyzers
* The data

### The Fetchers
The fetchers job is just to pull down all the relevant parts of gamerankings.  They produce data.

### The Scrapers
The scrapers job is to trawl the data and extract the relevant bits of information that we care about.  The scrapers are written in Ruby and rely on a tool called Nokogiri.

### The Infrastructure
The infrastructure provides the repository for the data we care about.  It is written in Ruby and uses a library called DataMapper.  DataMapper is a fairly agnostic library, so you can choose and configure your datastore as you need (whether it's a relational one, like MySQL or Sqlite3, or a non-relational one like flat files.)

### The Analyzers
The analyzers don't exist yet.  The existing analysis we've done has been done on an ad hoc basis and has been filtered through Microsoft Excel.  Ruby tools to do the equivalent are forthcoming.

### The Data
The data is currently zipped and stored as a 20 meg archive of HTML documents.  A mysql DB dump will likely join it in the repository.  The dataset basically consists of three models, games, review outlets, and reviews (check lib for the details of the structure).  The raw HTML pages are pulled straight from gamerankings.com on March 27th, 2010.

## Contact
If you would like to contact me, feel free to message me here at github, or hit me up on twitter at [@knowtheory](http://twitter.com/knowtheory).