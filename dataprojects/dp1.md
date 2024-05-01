# Data Project 1: Build a Data-driven API

In this Data Project you will build on your FastAPI code by providing data dynamically to your API from a database.

- The database will be a MySQL RDS instance running in AWS.
- The API will be your FastAPI instance built into a container.
- Finally, a simple web page will display your API data visually.

- - -
Here are the steps:
- [Data Project 1: Build a Data-driven API](#data-project-1-build-a-data-driven-api)
  - [1. Setup](#1-setup)
    - [Set Environment Variables](#set-environment-variables)
    - [Python Installation](#python-installation)
    - [Update your `Dockerfile`](#update-your-dockerfile)
    - [Gitpod Configuration File](#gitpod-configuration-file)
    - [Python Imports](#python-imports)
    - [Static Files](#static-files)
  - [2. Database Prep](#2-database-prep)
  - [3. Connect FastAPI to your Database](#3-connect-fastapi-to-your-database)
  - [4. Add an endpoint to fetch a single album](#4-add-an-endpoint-to-fetch-a-single-album)
  - [5. Run your project container](#5-run-your-project-container)
  - [6. Submit your work](#6-submit-your-work)

## 1. Setup

This data project assumes you have successfully completed **Lab 6** and that pushes to your `fastapi-demo` repository build container images successfully. If you have not completed this step, you must before you can continue.

You may either develop/test your code locally or using Gitpod. There is no preference, though more advanced students who want the challenge may choose to develop locally.

### Set Environment Variables

Follow the instructions found at <a href="https://canvas.its.virginia.edu/courses/105117/pages/rds-credentials" target="_new" style="font-weight:bold;">this page</a> in Canvas and set your `DBHOST`, `DBUSER`, and `DBPASS` environment variables in your development environment.

These `ENV` variables provide a server, username, and password for your Python to communicate with the MySQL service.

### Python Installation

At the end of your `requirements.txt` file add a new line:
```
mysqlclient
```
In your environment (local computer or Gitpod) run this command:
```
python3 -m pip install mysqlclient
```

This installs the `MySQLdb` package for database communications.

(If you are developing locally and run into installation problems with this package, you'll need to Google around for a working solution.)

### Update your `Dockerfile`

The `Dockerfile` in your project needs a few more pieces of software for database communications. Add the second line below so that your entire `Dockerfile` looks like this:

```
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9-alpine3.14
RUN apk add musl-dev mariadb-connector-c-dev gcc
COPY ./app /app
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt
```

### Gitpod Configuration File

Replace the contents of your `.gitpod.yml` file with <a href="https://gist.github.com/nmagee/828db0b668518ee397326bd5407b82b2" target="_new">this configuration</a>.

### Python Imports

Add the following entries to the top of your `app/main.py` file:

```
import os
import MySQLdb
from fastapi.staticfiles import StaticFiles
```
These imports let you use environment variables within your code, communicate with the MySQL database service, and will enable FastAPI to display a simple HTML page (see below).

Next, below your instantiation of the `app = FastAPI()` object, enter these lines:

```
app.mount("/static", StaticFiles(directory="static", html=True), name="static")

DBHOST = os.environ.get('DBHOST')
DBUSER = os.environ.get('DBUSER')
DBPASS = os.environ.get('DBPASS')
DB = "mst3k"  # replace with your UVA computing ID / database name
```
These lines configure FastAPI to display static pages and populate three new variables with the `ENV` variables you set above.

### Static Files

Within the `app/` directory of your FastAPI, create a new subdirectory named `static/`. Inside that new directory, copy three files:

- [`index.html`](static/index.html) - A simple framework to display your API data for humans.
- [`script.js`](static/script.js) - The logic of the page that communicates with your API.
- [`styles.css`](static/styles.css) - A stylesheet for decorating the HTML file.

These files interact with your API to fetch data and display it in a human-readable format.

Take the time to read through the code and see what you can understand.

The static page configuration now means that your FastAPI deployment has an additional endpoint: `/static/index.html` appended to your API's URL will display this page.


## 2. Database Prep
   
1. Run a PhpMyAdmin container either locally or in Gitpod using the command below. This will give you a GUI for interacting with your database.

    ```
    docker run -d -e PMA_HOST=$DBHOST -e PMA_USER=$DBUSER -e PMA_PASSWORD=$DBPASS -p 8001:80 phpmyadmin
    ```

3. Following the instructions from class, create a new database (if you haven't already) with your UVA user ID as the name (i.e. `nem2p` or `mst3k` etc.) Do this by clicking on "New" at the top of the list of databases in the lefthand navigation. Then provide a database name, leave the collation selection as-is, and press CREATE.

4. Click into your database on the left. Then click on the "SQL" tab at the top of the screen. You will be given a large text box to run SQL queries against your database. 

5. Copy this script and paste **BUT EDIT** the name of the database before `albums` (where it says `mst3k` below replace it with your DB name) and then press GO.

    ```
    CREATE TABLE `mst3k`.`albums` (`id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(30) NULL , `artist` VARCHAR(30) NULL , `genre` VARCHAR(15) NULL , `year` INT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
    ```

6. The command should execute quickly and you will see your `albums` table appear on the left under your database. Click into that. Note that it is empty, i.e. it has no records.

7. Click on the INSERT tab at the top of the screen. Using the top form entry, add a favorite album of yours to the database. Leave the ID entry empty, but add an album NAME, ARTIST, GENRE, and YEAR. Then press GO to save it.

8. Next let's add more entries using direct SQL. Click into the SQL tab again. Copy the code below and modify it for another entry. Since the `id` column auto-increments you can pass either `NULL` for its value or omit it altogether. The `year` column should have a 4-digit integer value (no quotes):

    ```
    INSERT INTO `albums`(
        `id`, 
        `name`, 
        `artist`, 
        `genre`, 
        `year`
    ) VALUES (
        NULL,
        '<ALBUM-NAME>',
        '<ALBUM-ARTIST>',
        '<ALBUM-GENRE>',
        '<ALBUM-YEAR>'
    )
    ```

    Here's an example entry on one line:

    ```
    INSERT INTO `albums`(`name`, `artist`, `genre`, `year`) VALUES ('The Queen is Dead','The Smiths','pop',1986);
    ```

9.  Repeat this process until you have at least 10 entries in your database.

## 3. Connect FastAPI to your Database

You have now installed the necessary libraries and software for FastAPI to communicate with a database, you have updated your `Dockerfile` to match those changes, and you have created a data table with data in it.

Now let's write a new API endpoint that will retrieve your table data and return it in JSON.

9. Create a new FastAPI endpoint decorator `("/albums)` using the **GET** method. Add a new function below it with a unique name. It does not require a parameter.

    ```
    @app.get("/albums")
    def get_albums():
    ```

10. Next, as part of your function, set up a database connection. This will be a `MySQLdb.connection` object, which means you can reuse the connection and all of its available methods. Use the connection string and be sure the `DB` value is set as a variable in your code.

    ```
        db = MySQLdb.connect(host=DBHOST, user=DBUSER, passwd=DBPASS, db=DB)
    ```
11. Next we will create a cursor, which is what executes SQL against the database service. The cursor will then execute some SQL and fetch the results. Copy this code and paste it below your DB connection string:

    ```
        c = db.cursor(MySQLdb.cursors.DictCursor)
        c.execute("""SELECT * FROM albums ORDER BY name""")
        results = c.fetchall()
    ```
    Notice the SQL here selects all rows from your `albums` table and orders them alphabetically by album name. It is wrapped in triple quotes as a visual cue to developers (but regular quotes work fine)

12. At this point you can test your results by adding a final line:

    ```
        return results
    ```
    And then run `./preview.sh` in either Gitpod or locally. Using either the Gitpod URL or your local `http://127.0.0.1:8000/` address, add `/albums` to the URL and check for your albums to be returned. The server will display your data in JSON format. This is because your cursor was declared as a `DictCursor` and therefor returned data arrays as dictionaries, which Python can easily convert into JSON.

    ![API image rendering](https://s3.amazonaws.com/ds2002-resources/images/albums-json.png)

13. However, if you were to add more entries to your DB table at this point and refresh the API page, you would not see any new values. This is because the database connection has been opened and the query executed, but the connection was not closed, so no new fetches will occur.

    To close the connection, add this line before your `return` command:

    ```
        db.close()
        return results
    ```

    Closing connections after each request is an important practice for data scientists and developers. Connections left open take up possible connections used elsewhere, and remain open until they time out.

    Your complete new endpoint should look something like this:
    ```
    @app.get("/albums")
    def get_all_albums():
        db = MySQLdb.connect(host=DBHOST, user=DBUSER, passwd=DBPASS, db=DB)
        c = db.cursor(MySQLdb.cursors.DictCursor)
        c.execute("SELECT * FROM albums ORDER BY name")
        results = c.fetchall()
        db.close()
        return results
    ```

14. Test your API by adding another album entry to the database and refresh to see if your endpoint returns the new results.

15. View the results of a simple JavaScript web page pointed to your albums API endpoint. Add the following endpoint to the end of your Gitpod or local URL:

    ```
    /static/index.html
    ```

    You will see something like this:

    ![API image rendering](https://s3.amazonaws.com/ds2002-resources/images/api-results.png)


## 4. Add an endpoint to fetch a single album

16. Copy the entire `@` decorator and function you just wrote, but append a `{id}` variable and rename the function, passing in the `id` parameter. It should look something like this:

    ```
    @app.get("/albums/{id}")
    def get_one_album(id):
        db = MySQLdb.connect(host=DBHOST, user=DBUSER, passwd=DBPASS, db=DB)
        c = db.cursor(MySQLdb.cursors.DictCursor)
        c.execute("SELECT * FROM albums WHERE id=" + id)
        results = c.fetchall()
        db.close()
        return results
    ```
    Note the SQL syntax has changed, now including a `WHERE` statement and removing the `ORDER BY` statement.

    Be sure that your `./preview.sh` script is running the local `uvicorn` server. Now append one of your album IDs after `/albums` like this:

    ```
    http://127.0.0.1:8000/albums/8
    ```
    And you will fetch the data for a single album.

    ![API single album](https://s3.amazonaws.com/ds2002-resources/images/single-album.png)

17. Add, Commit, and Push your code to GitHub. Be sure your container builds are successful in GitHub Actions. Debug as necessary.

## 5. Run your project container

Stop your `./preview.sh` script running either locally or in Gitpod, as well as your PhpMyAdmin container. Assuming your FastAPI container images are successfully building in GitHub Actions, let's now run your completed API container.

Either locally or in Gitpod, run the following command. Update the URL accordingly with your own GitHub username:

```
docker run -d -p 8080:80 -e DBHOST=$DBHOST -e DBUSER=$DBUSER -e DBPASS=$DBPASS ghcr.io/GITHUB-USERNAME/fastapi-demo:latest
```

In Gitpod a new tab should automatically open to your API. If you are developing locally, open a browser to http://127.0.0.1:8080/

Explore the three new endpoints you created:

- http://API-URL/albums
- http://API-URL/albums/4
- http://API-URL/static/index.html

Try adding or removing albums to your database table and verify the results are visible in your API.

## 6. Submit your work

You will need to submit three (3) pieces for this Data Project. Create an "images/" directory in your FastAPI repository and add the two images below. Then add/commit/push them, and submit the URL to your FastAPI repo in GitHub.

- Add a screenshot of your `/albums` JSON from your web browser
- Add a screenshot of your `/static/` page showing cards for all your albums.
- Submit the URL to your `FastAPI` repository in GitHub.
