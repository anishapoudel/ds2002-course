# Lab 10 - Python Error Handling

First read [this page](https://docs.python.org/3/library/exceptions.html) from Python documentation.

The basics:

- The `try` block lets you test a block of code for errors.
- The `except` block lets you handle the error.
- The `else` block lets you execute code when there is no error.
- The `finally` block lets you execute code, regardless of the result of the try- and except blocks.

When an error (aka exception) occurs, Python normally stops and generates an error message.

These exceptions can be handled using `try`/`except` statements:

```
try:
  print(x)
except:
  print("An exception occurred")
```

Notice, however, that while python detects the exception, the developer has simply programmed a simple message instead of any detail about WHY the exception occurred.

To improve upon this, a generic exception handler can pull out such detail. Here the exception error message is captured into a variable `e` that can be printed and parsed.

```
try:
  sum = "word" + 7
except Exception as e:
  print(e)
```
```
can only concatenate str (not "int") to str
```
The error indicates that strings and ints cannot be added or concatenated.


## 1. Error Handling - Built-in

Review the code below:

```
def throw_me_an_error():
  val1 = 14
  val2 = 0
  return val1 / val2

throw_me_an_error()
```
This function is designed to deliberately throw an error.

Create a new version of the function but add `try` and `except` statements correctly. Your exception should print out the type of error this function created. There are a couple of different ways you could do this.

## 2. Error Handling - `finally`

Look at the error handling within this more complex example:

```
def write_data_to_file(data, filename):
  try:
    with open(filename, 'w', encoding='utf-8') as file:
      file.write(data)
  except FileNotFoundError as e:
    print(f"Error: File {filename} not found.")
  except PermissionError as e:
    print(f"Error: Permission denied to write to {filename}.")
  finally:
    if 'file' in locals():  # Check if 'file' variable exists (was opened)
      file.close()  # Close the file if it was opened

# Example usage
data = "This is some data to write to the file."
filename = "my_data.txt"
write_data_to_file(data, filename)
```
Explain the function of the `finally` block in this snippet. What purpose does it serve?

## 3. Error Handling - Imported Library

Look at this snippet of code, which triggers a specific error from the `json` library:

```
import json

# Invalid JSON data
data = "{invalid_json_key: 'value'}"

try:
  # Attempt to load the JSON data
  json.loads(data)
except json.JSONDecodeError as e:
  # Print the JSON import error
  print(f"JSON import error: {e}")
```
Rewrite this snippet so that it works correctly and does not trigger an exception.


## 4. Submit your work

Submit your snippets of code / answers in GitHub gists. They can be three separate files within the same Gist, or you can simply paste them into one single file.

Submit the URL to your Gist for grading.
