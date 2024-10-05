# ShiftCare Code Challenge
Please use `ruby-3.3.0` as this is used on the development. It should automatically set as I have created a 
`.ruby-version` file but just to be sure.

### Running the Command Line Application
To run the command line application, you can run the following command:
```sh 
> ruby app.rb -h
Usage: 'ruby app.rb [options]'
    -p, --path FILEPATH              File path to read
    -f, --find FIELD=VALUE           Specify field and value to search (e.g. --find name=John)
    -d, --find-duplicate FIELD       Find duplicate
```

I have included the `clients.json` file that is sent in the email in the repo so that we can use that to run the 
command. I have also added my own files to test the application. They can be found at `test/fixtures/`

### Example
```sh
ruby app.rb -p clients.json -f full_name='John Doe' -d email
```

### Example Output
```sh
Searching for full_name: John Doe
Number of objects found: 1
---------------------------------
{"id"=>1, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}
---------------------------------
Duplicate email='jane.smith@yahoo.com' found:
{"id"=>2, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"}
{"id"=>15, "full_name"=>"Another Jane Smith", "email"=>"jane.smith@yahoo.com"}
```

### Running the Tests
Simply run this to run all the test
```sh
rake test
```

I used MiniTest on this application since its only a Ruby App. I usually use RSpec when I work on 
Ruby on Rails Applications


### Assumptions on the Exam
The exam seemed pretty straightforward so I made it as like the instruction said, however, I made more
improvements as I had the time. I added the possible additional capabilities that is mentioned on the 
exam, and more. 

### Additional Capabilities
- error handling
- dynamic search by passing the field
- dynamic duplicate search by passing field
- capable of reading any kind of json file, not just the one provided
- capable of reading json files with multiple objects that are not the same
- guide on how to run the application