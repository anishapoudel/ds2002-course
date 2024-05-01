# Lab 8 - JavaScript Object Notation (JSON)

## 0. Setup

1. If you have not already, fork this repository: [**https://github.com/nmagee/json-practice/**](https://github.com/nmagee/json-practice/)
2. Open your repository in either Gitpod or locally.
    - Either append `https://gitpod.io/#` before your entire GitHub URL; or
    - Use `git clone` to clone your repo locally to your laptop.
3. Refer to documentation within that repository as needed, and follow the instructions closely below.
4. You will submit two snippets of code for this lab. Create a folder in your fork of `json-practice` and create a subfolder named `lab8`. Place your two scripts in that directory, add/commit/push them, then submit the URL to your repository for grading.

## 1. Parse JSON with `jq`

Review the instructions for how to parse JSON with `jq` on [this page](https://github.com/nmagee/json-practice/tree/main/jq). 

The NOAA manages an open, public API for tracking aviation weather data.  METAR data is a format for weather reporting that includes information on wind, visibility, runway visual range, and more.

The NOAA Aviation Weather API has built-in documentation (look who else uses FastAPI?) here: https://aviationweather.gov/data/api/#/

Retrieve data from this URL, which is for the KMCI (Kansas City) airport, output into JSON format, showing the last 12 hours, bound by a small geographic box:
```
curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json
```

Note that you need to wrap this URL in quotes when using `curl` from the command-line.

Write a `bash` script that does the following:

1. Fetches the METAR data from the URL above.
2. Parses the data and pulls out the `receiptTime` value
3. Outputs only the first six values to the screen.

Your script should output something like this with no more than 6 lines:

```
"2024-04-09 13:56:20"
"2024-04-09 12:56:14"
"2024-04-09 11:56:12"
"2024-04-09 10:56:20"
"2024-04-09 09:56:23"
"2024-04-09 08:56:11"
```

## 2. Parse JSON with Python

1. Review the file [`data/schacon.repos.json`](data/schacon.repos.json) and notice it lists the first 30 repositories owned by Scott Chacon in GitHub. Each entry has around 100 data points.

2. Recall that reading a file into Python looks something like this (in read-only mode):

    ```
    import json
    
    with open('somefile.json', 'r') as file:
        data = json.load(file)
    ```

3. Write a Python script that does the following:
   
   1. Reads in the file as JSON.
   2. Pulls out the following four fields:
      1. `name`
      2. `html_url`
      3. `updated_at`
      4. `visibility`
   3. Assembles these four fields into a comma-separated line.
   4. Appends this line to a new text file named `chacon.csv`
   5. LIMIT the output to 5 lines only. Do not parse all 30 lines into the new CSV file.

Your Python script should output into `chacon.csv` so that it looks exactly like this:

```
3D-Me,https://github.com/schacon/3D-Me,2014-04-10T21:53:58Z,public
aeon,https://github.com/schacon/aeon,2015-07-04T15:31:31Z,public
agitmemnon,https://github.com/schacon/agitmemnon,2019-07-14T17:02:27Z,public
agitmemnon-server,https://github.com/schacon/agitmemnon-server,2024-02-05T21:14:57Z,public
amp,https://github.com/schacon/amp,2017-06-29T22:21:55Z,public
```

## 3. Submit your work

Submit two snippets of code for this lab. Create a folder in your fork of `json-practice` and create a subfolder named `lab8`. Place your two scripts in that directory (one in `bash` one in `python`), add/commit/push them, then submit the URL to your repository for grading.

You do not need to commit any output data files.
