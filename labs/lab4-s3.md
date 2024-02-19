# Lab 4: S3 Storage

Follow all the steps below for practice working with the S3 service in Amazon Web Services. You will write a series of scripts for this lab. Create a folder within `mywork/` named `lab4` and put your scripts into that directory. Commit these to your forked copy of the course repository, and paste the GitHub URL to the folder into the answer for submission.

This lab requires that you have both the AWS CLI tool (with keys) and Python3 / `boto3` installed.
- AWS Academy students can use the built-in web terminal, which has Python3, `boto3`, and the AWS CLI installed, or can set them up in their local environment.
- BYO Account students will need Python3, `boto3`, and the AWS CLI installed and configured locally with security credentials. Here is a [video](https://www.youtube.com/watch?v=-UNmEC9OmR8) that walks you through setting up those keys.

Installations:
- [Python3](https://www.python.org/downloads/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- `boto3` - is a simple `pip` command in your terminal:
```bash
python3 -m pip install boto3
```

## Objectives

In this lab you will:

1. Using the AWS CLI, create a bucket in S3.
2. Upload a file into the bucket.
3. Verify the file is in the bucket.
4. Verify the file is not publicly accessible.
5. Create an expiring URL for the file and verify access.
6. Modify the bucket ACL to allow for public access.
7. Upload a new file with public access enabled, and verify access.
8. Upload a file and delete it.
9. Finally, write Python3 scripts using the `boto3` library to upload one private file and one public file.

## About S3 and URL Access

S3 buckets are PRIVATE by default. No files/objects uploaded to a plain, unaltered bucket is ever publicly-accessible. In this lab you will learn more about public/private buckets and objects.

AWS operates many `regions` of infrastructure around the world. We will be using the `us-east-1` region, the first and one of their largest regions. To get the web URL to any public file in `us-east-1` this is the syntax:

```
https://s3.amazonaws.com/ + BUCKET_NAME + / file/path.sfx
```
For example, this URL is to a publicly-accessible file within a publicly-accessible bucket:
[`https://s3.amazonaws.com/ds2002-nem2p/vuelta.jpg`](https://s3.amazonaws.com/ds2002-nem2p/vuelta.jpg)



## Create and Configure an S3 Bucket

1. From either the Learner Lab terminal web page OR your local terminal, list any existing buckets (there should be none):

    ```
    aws s3 ls
    ```

2. Create a new bucket using the `mb` S3 subcommand. Add your computing ID to the name of the bucket, i.e. `ds2002-mst3k` and so on. Note the use of the `s3://` protocol before the bucket name.

    ```
    aws s3 mb s3://ds2002-mst3k
    ```

3. Grab an image file. Using the `curl` command below you can retrieve any image from the Internet you want to use for this lab. Once you have the URL copied for the image, use this command syntax:

    ```
    curl URL > file
    ```
    For example, to fetch the Google logo. You can output the image to a new file name.
    ```
    curl https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png > google_logo.png
    ```

4. So now you have a local file. Imagine you want to upload the file to your new S3 bucket. Use the AWS CLI to do this. The syntax is:
    ```
    aws s3 cp FILE s3://BUCKET/
    ```

    For example, to upload the google logo:

    ```
    aws s3 cp google_logo.png s3://ds2002-mst3k/
    ```

5. Go ahead and upload your file. List the contents of your bucket to verify it is there. Notice it is the same `ls` command, but specifying the bucket to list the contents of:

    ```
    aws s3 ls s3://ds2002-mst3k/
    ```
    which should return something like:
    ```
    $ aws s3 ls s3://ds2002-nem2p/
    2024-02-19 08:13:49     309510 vuelta.jpg
    ```

6. Take the bucket and file path and assemble a public URL to your file as described at the start of this lab:
    ```
    # https://s3.amazonaws.com/ + BUCKET_NAME + / FILE_PATH
    
    https://s3.amazonaws.com/ds2002-nem2p/vuelta.jpg
    ```
    Test that URL using your web browser. What do you see?

7. You cannot retrieve the file using a plain HTTPS address because anonymous web access is not allowed to your bucket or your file. Let's do a special trick S3 is capable of by creating an "expiring" URL that allows access to your file for a specified amount of time.

    The syntax for the command is:
    ```
    aws s3 presign --expires-in 30 s3://ds2002-nem2p/vuelta.jpg

    # The --expires-in flag is how many seconds the file should be public.
    # The s3:// is the BUCKET+FILE path to your specific file.
    ```

    Once you issue this command, it will return a very long URL with signature. Open that link in a browser - you should be able to see your file.

    Finally, refresh the browser page after the expiration period has elapsed. What do you see then?

8. Update your bucket's ACL (Access Control List)

    - Open the AWS Management Console to perform this task.
    - AWS Academy users click the "Download URL" button in the "AWS Details" panel of your Learner Lab.
    - Within the AWS Management Console, open the S3 service and find your bucket.
    - Click the name of the bucket to get detailed settings.
    - Select the Permissions tab within your bucket settings.
    - Click "Edit" within the Block public access section.
    - Uncheck all boxes and save your settings. Confirm the change.
    - Click "Edit within the Object Ownership section.
    - Enable ACLs by checking the right-hand radio button. Confirm your changes by checking the box. Leave "Bucket owner preferred" selected. Save your changes.

    These changes have not made your bucket or any of its contents public. However, they have now allowed you the option to specifically make any contents public if you choose to do so.

    S3 allows you to set a bucket policy to allow public access to ALL objects, or objects of certain types, if you need to do so.

9. Now that your bucket allows you to set public access, fetch another image file from the Internet (`.gif`, `.png`, `.jpg`, etc.) and upload it with this syntax to make it public:

    ```
    aws s3 cp --acl public-read IMAGE s3://BUCKET_NAME/
    ```

    For example:
    ```
    aws s3 cp --acl public-read vuelta.jpg s3://ds2002-mst3k/
    ```

10. Test access

    Using the `bucket/file` path structure, construct the URL for your file like this: 
    [`https://s3.amazonaws.com/ds2002-mst3k/vuelta.jpg`](https://s3.amazonaws.com/ds2002-mst3k/vuelta.jpg)

11. Delete a file in your bucket. Using the AWS CLI, upload another image file to the bucket. List the bucket contents to confirm it has been uploaded. And, finallly, delete the file using this syntax:

    ```
    aws s3 rm s3://BUCKET_NAME/FILE_NAME
    ```
    For example
    ```
    aws s3 rm s3://ds2002-mst3k/vuelta.jpg
    ```
    And confirm the file has been deleted:
    ```
    aws s3 ls s3://ds2002-mst3k/
    ```

## Using the `boto3` library with Python3

Developers should keep in mind that S3 is a web service, or API, which means that in addition to using the AWS Management Console or CLI tools you can work with any AWS service using the language of your choice.

In this final section of the lab you will perform basic S3 operations using Python3 and the `boto3` library.

### Install and Import `boto3`

To work with `boto3` you must first make sure it is installed, so that you can import it. From a terminal:

```
python3 -m pip install boto3
```
You can confirm that `boto3` is installed if you open a Python3 session and try to import it. A successful `import` should result in no errors/warnings.
```
$ python3
Python 3.7.5 (default, Dec 18 2019, 06:24:58) 
[GCC 5.5.0 20171010] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import boto3
>>>
```
The following tasks assume you are able to import `boto3` successfully.

### Upload a file to S3 and keep it private

1. Each AWS service you connect to via `boto3` needs a `client` or `resource` or some other reusable connection. Let's create a simple client for the S3 service:

    ```
    import boto3

    s3 = boto3.client('s3', region_name='us-east-1')
    ```
    The variable `s3` populated with an instance of the `boto3.client` class can be named anything you like. It is now a reusable object for calling that specific service.

    **NOTE**: If you get a Python 3.7 `PythonDeprecationWarning` that is to be expected. If you are using the AWS Academy Learner Lab you can get around this by explicitly invoking `python3.8` when you run Python.

2. Once you have created a client you are now ready to work with it. In your command prompt (in a local terminal or VSCode, etc.), upon invoking the `s3` class object you just created, you will notice many new options:

    ```python3
    s3.<TAB>
    ```

3. For instance, you can list your buckets:

    ```
    import boto3

    s3 = boto3.client('s3', region_name="us-east-1")
    response = s3.list_buckets()

    # now iterate through the responses:
    for r in response['Buckets']:
      print(r['Name'])
    ```

    This should return the name(s) of any bucket(s) in your account. Note that above, a variable named `response` was created and populated with the results of the `list_buckets()` method. This is an arbitrary variable name - you can always use your own.

4. To upload a file to your bucket:

    ```
    bucket = 'ds2002-mst3k'
    local_file = 'project/vuelta.jpg'

    resp = s3.put_object(
        Body = local_file,
        Bucket = bucket,
        Key = local_file
    )
    ```

    Some explanation:

      - The `bucket` is an S3 bucket that already exists.
      - The `local_file` is the path/file that you want to upload.
      - The `Key` within the `put_object()` method is the destination path you want for the uploaded path.
      - These three parameters are the minimum required for a `put_object` call. There are many other options.

5. Write your own upload script and test for success. Try getting the file using a public URL. You should get `Permission Denied`.

### Upload a file to S3 and make it public

Upload a new file to S3 with public visibility. The request will be like the one above, but add the following parameter:

    ```
        ACL = 'public-read',
    ```

Test your file upload using a public URL to see if you can access it.

## Submit your work

Your work should be put into a folder `ds2002-course/mywork/lab4` within your fork of the course repository -- added, committed, and pushed.

Submit the GitHub URL to that folder into Canvas for grading.